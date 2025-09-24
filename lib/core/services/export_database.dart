import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/legacy.dart';

enum ZipStatus {
  idle,
  preparing,
  addingFiles,
  compressing,
  saving,
  done,
  error,
}

class ZipState {
  final ZipStatus status;
  final double progress;
  final String? message;
  final String? filePath;

  const ZipState({
    this.status = ZipStatus.idle,
    this.progress = 0.0,
    this.message,
    this.filePath,
  });

  ZipState copyWith({
    ZipStatus? status,
    double? progress,
    String? message,
    String? filePath,
  }) {
    return ZipState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      message: message ?? this.message,
      filePath: filePath ?? this.filePath,
    );
  }
}

final zipProvider = StateNotifierProvider<ZipNotifier, ZipState>(
  (ref) => ZipNotifier(),
);

class ZipNotifier extends StateNotifier<ZipState> {
  ZipNotifier() : super(const ZipState());

  Future<String> getTempPath() async {
    final tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }

  Future<File?> exportFolderAsZip() async {
    try {
      state = state.copyWith(status: ZipStatus.preparing, progress: 0.0);

      final tempPath = await getTempPath();
      final savePath =
          "$tempPath/talkiehelpie_backup_${DateTime.now().millisecondsSinceEpoch}.zip";

      final docsDir = await getApplicationDocumentsDirectory();

      final archive = Archive();

      // Masukkan file JSON ke dalam folder "data/"
      final jsonStorage = File("${docsDir.path}/data/card_image_storage.json");
      final jsonSelected = File("${docsDir.path}/data/selected_cards_list.json");

      if (await jsonStorage.exists()) {
        final data = await jsonStorage.readAsBytes();
        archive.addFile(ArchiveFile("data/card_image_storage.json", data.length, data));
      }

      if (await jsonSelected.exists()) {
        final data = await jsonSelected.readAsBytes();
        archive.addFile(ArchiveFile("data/selected_cards_list.json", data.length, data));
      }

      // Masukkan gambar ke dalam folder "card_images/"
      final imgDir = Directory("${docsDir.path}/card_images");
      if (await imgDir.exists()) {
        for (var entity in imgDir.listSync(recursive: true)) {
          if (entity is File) {
            final bytes = await entity.readAsBytes();
            final fileName = entity.uri.pathSegments.last;
            archive.addFile(ArchiveFile("card_images/$fileName", bytes.length, bytes));
          }
        }
      }

      // Encode jadi zip
      final zipData = ZipEncoder().encode(archive);
      final outFile = File(savePath);
      await outFile.writeAsBytes(zipData);

      state = state.copyWith(
        status: ZipStatus.done,
        progress: 1.0,
        message: "Zip created",
        filePath: savePath,
      );

      await Share.shareXFiles([XFile(savePath)], text: "Here is your backup zip file");

      return outFile;
    } catch (e) {
      state = state.copyWith(status: ZipStatus.error, message: e.toString());
      return null;
    }
  }

  Future<void> shareExistingZip() async {
    if (state.filePath == null) {
      state = state.copyWith(
        status: ZipStatus.error,
        message: "Tidak ada file zip yang bisa di share.",
      );
      return;
    }

    final file = File(state.filePath!);
    if (await file.exists()) {
      await Share.shareXFiles(
        [XFile(file.path)],
        text: "Ini zip hasil backup data kamu.",
      );
    } else {
      state = state.copyWith(
        status: ZipStatus.error,
        message: "File tidak ditemukan di ${state.filePath}",
      );
    }
  }
}
