import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:file_picker/file_picker.dart';

enum ZipStatus { idle, preparing, addingFiles, compressing, saving, done, error }

class ZipState {
  final ZipStatus status;
  final double progress;
  final String? message;

  const ZipState({
    this.status = ZipStatus.idle,
    this.progress = 0.0,
    this.message,
  });

  ZipState copyWith({
    ZipStatus? status,
    double? progress,
    String? message,
  }) {
    return ZipState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      message: message ?? this.message,
    );
  }
}

// Provider for zip state
final zipProvider = StateNotifierProvider<ZipNotifier, ZipState>(
      (ref) => ZipNotifier(),
);

// Logic for zip state
class ZipNotifier extends StateNotifier<ZipState> {
  ZipNotifier() : super(const ZipState());

  Future<File?> exportFolderAsZip() async {
    try {
      state = state.copyWith(status: ZipStatus.preparing, progress: 0);

      // 1. Ambil folder aplikasi
      final dir = await getApplicationDocumentsDirectory();
      final files = Directory(dir.path)
          .listSync(recursive: true)
          .whereType<File>()
          .toList();

      final archive = Archive();
      final total = files.length;
      var processed = 0;

      for (var file in files) {
        state = state.copyWith(
          status: ZipStatus.addingFiles,
          progress: processed / total,
          message: "Menambahkan file: ${file.uri.pathSegments.last}",
        );

        final data = await file.readAsBytes();
        final relativePath = file.path.replaceFirst(dir.path, "");
        archive.addFile(ArchiveFile(relativePath, data.length, data));

        processed++;
      }

      // 2. Kompres
      state = state.copyWith(status: ZipStatus.compressing, progress: 1.0);
      final zipData = ZipEncoder().encode(archive);

      // 3. Tentukan lokasi simpan (platform-specific)
      String? savePath;

      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Desktop → dialog save file
        savePath = await FilePicker.platform.saveFile(
          dialogTitle: 'Simpan backup sebagai...',
          fileName:
          "backup_${DateTime.now().toIso8601String().replaceAll(":", "-")}.zip",
        );
      } else if (Platform.isAndroid) {
        // Android → coba Downloads, fallback ke external storage
        final downloads = await getDownloadsDirectory();
        final baseDir = downloads ?? await getExternalStorageDirectory();
        savePath =
        "${baseDir!.path}/backup_${DateTime.now().millisecondsSinceEpoch}.zip";
      } else if (Platform.isIOS) {
        // iOS → sandbox Documents
        final docsDir = await getApplicationDocumentsDirectory();
        savePath =
        "${docsDir.path}/backup_${DateTime.now().millisecondsSinceEpoch}.zip";
      }

      if (savePath == null) {
        state = state.copyWith(
            status: ZipStatus.error, message: "User membatalkan penyimpanan");
        return null;
      }

      // 4. Simpan file
      state = state.copyWith(status: ZipStatus.saving);
      final zipFile = File(savePath);
      await zipFile.writeAsBytes(zipData);

      state = state.copyWith(
          status: ZipStatus.done, progress: 1.0, message: "Selesai");
      return zipFile;
    } catch (e) {
      state =
          state.copyWith(status: ZipStatus.error, message: e.toString());
      return null;
    }
  }
}