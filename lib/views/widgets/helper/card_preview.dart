import 'package:flutter/material.dart';
import 'dart:io';
import 'package:talkie_helpie/core/models/word.dart';
import 'package:talkie_helpie/core/helper/card_color_picker.dart';
import '../../../core/style/app_colors.dart';

// Fungsi untuk membangun Container Word
Widget cardPreview(BuildContext context, Word word) {
  final double screenHeight = MediaQuery.of(context).size.height;

  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
          color: getCardBgColor(word.type), // ambil warna sesuai tipe
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: getCardBorderColor(word.type),
            width: screenHeight * 0.01,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (word.imgPath.startsWith("assets/"))
                // Kalau path dari assets
                Image.asset(
                  word.imgPath,
                  fit: BoxFit.cover,
                  width: screenHeight * 0.075,
                  height: screenHeight * 0.075,
                )
              else
                // Kalau path dari file lokal
                Builder(
                  builder: (context) {
                    final file = File(word.imgPath);

                    if (file.existsSync()) {
                      return Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            file,
                            fit: BoxFit.cover,
                            width: screenHeight * 0.075,
                            height: screenHeight * 0.075,
                          ),
                        ),
                      );
                    } else {
                      return const Text("File tidak ditemukan");
                    }
                  },
                ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                word.word,
                style: TextStyle(
                  fontSize: screenHeight * 0.03,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryFont,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}
