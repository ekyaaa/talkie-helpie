import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:talkie_helpie/core/services/export_database.dart';
import '../../../core/style/app_colors.dart';

class ZipDialog extends ConsumerWidget {
  const ZipDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zipState = ref.watch(zipProvider);

    // Tutup dialog otomatis kalau selesai atau error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (zipState.status == ZipStatus.done ||
          zipState.status == ZipStatus.error) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });

    return Dialog(
      backgroundColor: AppColors.thirdBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Export Database",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Konten sesuai state
              switch (zipState.status) {
                ZipStatus.preparing =>
                const Text("Menyiapkan..."),
                ZipStatus.addingFiles => Column(
                  children: [
                    CircularProgressIndicator(value: zipState.progress),
                    const SizedBox(height: 12),
                    Text("Menambahkan file ${(zipState.progress * 100).toStringAsFixed(0)}%"),
                  ],
                ),
                ZipStatus.compressing =>
                const Text("Mengompres..."),
                ZipStatus.saving =>
                const Text("Menyimpan..."),
                ZipStatus.done =>
                const Text("Selesai!"),
                ZipStatus.error =>
                    Text("Error: ${zipState.message}"),
                _ =>
                const SizedBox.shrink(),
              },
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
