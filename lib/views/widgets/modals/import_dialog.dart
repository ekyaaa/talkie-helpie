import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/services/image_card_storage_service.dart';
import '../../../core/style/app_colors.dart';

class ImportDialog extends ConsumerStatefulWidget {
  const ImportDialog({super.key});

  @override
  ConsumerState<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends ConsumerState<ImportDialog> {
  String? _statusMessage;
  bool _isValid = false;
  bool _isImporting = false;
  late dynamic _zipPathResult;
  bool _isFinished = false;

  Future<void> _pickAndValidateZip() async {
    setState(() {
      _statusMessage = "Memilih file...";
      _isValid = false;
    });

    // Buka file picker
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result == null || result.files.single.path == null) {
      setState(() {
        _statusMessage = "Tidak ada file dipilih.";
      });
      return;
    }

    final filePath = result.files.single.path!;
    final fileBytes = await File(filePath).readAsBytes();

    try {
      final archive = ZipDecoder().decodeBytes(fileBytes);

      // Ambil semua path dari isi zip
      final entries = archive.map((e) => e.name).toList();

      // Syarat: folder card_images dan folder data
      final hasCardImages = entries.any((e) => e.startsWith("card_images/"));
      final hasData = entries.any((e) => e.startsWith("data/"));

      // Syarat tambahan di folder data
      final hasCardImageStorage = entries.contains(
        "data/card_image_storage.json",
      );
      final hasSelectedCards = entries.contains(
        "data/selected_cards_list.json",
      );

      if (hasCardImages && hasData && hasCardImageStorage && hasSelectedCards) {
        setState(() {
          _statusMessage = "✅ Zip valid, semua file ditemukan.";
          _isValid = true;
          _zipPathResult = result;
        });
      } else {
        setState(() {
          _statusMessage =
              "❌ Zip tidak valid.\nPastikan ada folder `card_images` dan `data` dengan file JSON yang benar.";
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "❌ Gagal membaca zip: $e";
      });
    }
  }

  Future<void> importZipToAppDir(String zipPath) async {
    try {
      setState(() {
        _isImporting = true;
      });

      // Ambil direktori dokumen aplikasi
      final docsDir = await getApplicationDocumentsDirectory();

      final dataDir = Directory("${docsDir.path}/data");
      final imagesDir = Directory("${docsDir.path}/card_images");

      // 1. Hapus file lama
      final jsonStorage = File("${dataDir.path}/card_image_storage.json");
      final jsonSelected = File("${dataDir.path}/selected_cards_list.json");

      if (await jsonStorage.exists()) {
        await jsonStorage.delete();
      }
      if (await jsonSelected.exists()) {
        await jsonSelected.delete();
      }
      if (await imagesDir.exists()) {
        await imagesDir.delete(recursive: true);
      }

      // Pastikan folder data ada
      if (!await dataDir.exists()) {
        await dataDir.create(recursive: true);
      }
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // 2. Baca zip
      final fileBytes = await File(zipPath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(fileBytes);

      // 3. Ekstrak ke docsDir
      for (final file in archive) {
        final filename = file.name;
        final outPath = "${docsDir.path}/$filename";

        if (file.isFile) {
          final outFile = File(outPath);
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
        } else {
          await Directory(outPath).create(recursive: true);
        }
      }

      debugPrint(
        "✅ Import selesai. Data berhasil diekstrak ke ${docsDir.path}",
      );
    } catch (e, st) {
      debugPrint("❌ Gagal import zip: $e\n$st");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.secondaryBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Import Database",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _pickAndValidateZip,
                icon: const Icon(
                  Icons.upload_file,
                  color: AppColors.primaryFont,
                ),
                label: const Text(
                  "Pilih File Zip",
                  style: TextStyle(color: AppColors.primaryFont),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // radius sudut
                  ),
                  backgroundColor: Colors.white70, // opsional: warna background
                ),
              ),

              const SizedBox(height: 16),

              if (_statusMessage != null || _isFinished) ...[
                Text(
                  _statusMessage!,
                  style: TextStyle(
                    color: _isValid ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 20),
              _isImporting == true
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: _isFinished
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                          icon: const Icon(Icons.close, color: Colors.white),
                          label: const Text(
                            "Tutup",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                        ),
                        if (_isValid)
                          _isFinished == false
                              ? ElevatedButton.icon(
                                  onPressed: () async {
                                    if (_zipPathResult != null &&
                                        _zipPathResult.files.single.path !=
                                            null) {
                                      final zipPath =
                                          _zipPathResult.files.single.path!;
                                      await importZipToAppDir(zipPath);
                                      ref.invalidate(imageStorageAsyncProvider);
                                      setState(() {
                                        _isImporting = false;
                                        _isFinished = true;
                                        _statusMessage =
                                            "Import selesai. Data berhasil diekstrak ke direktori aplikasi.";
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Lanjut",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                )
                              : SizedBox.shrink(),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
