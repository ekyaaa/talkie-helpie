import 'package:flutter/material.dart';

import '../../core/style/app_colors.dart';

void showSettingsModal(BuildContext context) {
  final double screenHeight = MediaQuery.of(context).size.height;
  final double screenWidth = MediaQuery.of(context).size.width;

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
                  Icon(Icons.settings, size: screenHeight * 0.09, color: AppColors.secondaryBg,),
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
                debugPrint("Option 1 ditekan");
              }),
              SizedBox(height: screenHeight * 0.03),
              _buildOptionButton(context, "Export Database", () {
                debugPrint("Option 2 ditekan");
              }),
              SizedBox(height: screenHeight * 0.03),
              _buildOptionButton(context, "Keluar Aplikasi", () {
                debugPrint("Option 3 ditekan");
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
  final double screenHeight = MediaQuery.of(context).size.height;
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
