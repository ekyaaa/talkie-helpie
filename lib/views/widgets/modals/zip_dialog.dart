import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:talkie_helpie/core/services/export_database.dart';
import '../../../core/style/app_colors.dart';

class ZipDialog extends ConsumerWidget {
  const ZipDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zipState = ref.watch(zipProvider);

    // Tutup dialog otomatis hanya kalau error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (zipState.status == ZipStatus.error) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });

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
              zipState.status == ZipStatus.done
                  ? const SizedBox.shrink() // tidak tampil
                  : const Text(
                      "Export Database",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const SizedBox(height: 20),

              // Konten sesuai state
              switch (zipState.status) {
                ZipStatus.preparing => const Text("Menyiapkan..."),
                ZipStatus.addingFiles => Column(
                  children: [
                    CircularProgressIndicator(value: zipState.progress),
                    const SizedBox(height: 12),
                    Text(
                      "Menambahkan file ${(zipState.progress * 100).toStringAsFixed(0)}%",
                    ),
                  ],
                ),
                ZipStatus.compressing => const Text("Mengompres..."),
                ZipStatus.saving => const Text("Menyimpan..."),
                ZipStatus.done => Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Selesai!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: AppColors.primaryFont,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (zipState.filePath != null)
                      Text(
                        "Aplikasi ini hanya bisa nyimpen data via share saja, belum bisa secara lokal karena developernya skill issue. :'D",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryFont,
                        ),
                      ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                          icon: const Icon(Icons.close, color: Colors.white),
                          label: const Text(
                            "Tutup",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // warna teks
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent, // warna background tombol
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // sudut melengkung
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            ref.read(zipProvider.notifier).shareExistingZip();
                          },
                          icon: const Icon(Icons.share, color: Colors.white),
                           label: const Text(
                            "Bagikan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent, // misalnya warna biru
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
                ZipStatus.error => Text("Error: ${zipState.message}"),
                _ => const SizedBox.shrink(),
              },
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
