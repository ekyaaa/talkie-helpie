import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkie_helpie/core/style/app_colors.dart';
import 'package:talkie_helpie/views/edit_image_database_screen.dart';
import 'package:talkie_helpie/views/widgets/modals/zip_dialog.dart';

import '../../../core/services/export_database.dart';

void showSettingsModal(BuildContext context) {
  final double screenHeight = MediaQuery.of(context).size.height;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.thirdBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // tinggi mengikuti isi
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Icon(
                    Icons.settings,
                    size: screenHeight * 0.09,
                    color: AppColors.secondaryBg,
                  ),
                  Text(
                    'Pengaturan',
                    style: TextStyle(
                      fontSize: screenHeight * 0.07,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryBg,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              _buildOptionButton(context, "Edit Database Gambar", () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditImageDatabaseScreen()),
                );
              }),
              SizedBox(height: screenHeight * 0.03),
              _buildOptionButton(context, "Export Database", () {
                Navigator.pop(context); // tutup settings modal dulu

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const ZipDialog(),
                );

                // Trigger proses export lewat provider
                final container = ProviderScope.containerOf(context, listen: false);
                container.read(zipProvider.notifier).exportFolderAsZip();
              }),
              SizedBox(height: screenHeight * 0.03),
              _buildOptionButton(context, "Import Database", () {
                debugPrint("Option 3 ditekan");
              }),
              SizedBox(height: screenHeight * 0.03),
              _buildOptionButton(context, "Keluar Aplikasi", () {
                debugPrint("Option 4 ditekan");
              }),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      );
    },
  );
}

// Fungsi helper untuk membuat tombol option
Widget _buildOptionButton(
  BuildContext context,
  String title,
  VoidCallback onTap,
) {
  final double screenWidth = MediaQuery.of(context).size.width;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      // memanjang penuh modal
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
      decoration: BoxDecoration(
        color: AppColors.secondaryBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: const TextStyle(color: AppColors.primaryBg, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
