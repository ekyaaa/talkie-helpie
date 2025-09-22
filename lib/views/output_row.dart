import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkie_helpie/views/notifier/full_text_provider.dart';
import 'package:talkie_helpie/views/widgets/settings_modal.dart';
import '../core/style/app_colors.dart';
import 'notifier/content_widget_notifier.dart';
import 'notifier/type_notifier.dart';

class OutputRow extends ConsumerWidget {
  const OutputRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final List<ContentItem> contents = ref.watch(contentProvider);

    return SizedBox(
      height: screenHeight * 0.228,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
        child: Row(
          spacing: 10,
          children: [
            // "Bicara" button
            SizedBox(
              height: screenHeight * 0.15,
              width: screenHeight * 0.15,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(fullTextProvider.notifier).speak();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(screenHeight * 0.12, screenHeight * 0.12),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/bicara.png',
                      height: screenHeight * 0.05,
                    ),
                    SizedBox(height: screenHeight * 0.0125),
                    Text(
                      'Bicara',
                      style: TextStyle(fontSize: screenHeight * 0.02),
                    ),
                  ],
                ),
              ),
            ),

            // Container abu-abu
            Expanded(
              child: Container(
                height: screenHeight * 0.15,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: contents.map((item) {
                            if (item.type == WidgetType.word &&
                                item.word != null) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (item.word!.imgPath.isEmpty)
                                      const SizedBox.shrink()
                                    else if (item.word!.imgPath.startsWith("assets/"))
                                      Image.asset(
                                        item.word!.imgPath,
                                        fit: BoxFit.cover,
                                        height: screenHeight * 0.065,
                                      )
                                    else
                                      Builder(
                                        builder: (context) {
                                          final file = File(item.word!.imgPath);
                                          debugPrint("imgPath: ${item.word!.imgPath}");
                                          debugPrint("File exists? ${file.existsSync()}");

                                          if (file.existsSync()) {
                                            return Image.file(
                                              file,
                                              height: screenHeight * 0.065,
                                            );
                                          } else {
                                            return const Text("File tidak ditemukan");
                                          }
                                        },
                                      ),

                                    Text(
                                      item.word!.word,
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.025,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (item.type == WidgetType.separator &&
                                item.text != null) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  item.text!,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.black87,
                                  ),
                                ),
                              );
                            } else if (item.type == WidgetType.unknownWord &&
                                item.text != null) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Text(
                                  item.text!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink(); // fallback untuk null data
                            }
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.15,
              width: screenHeight * 0.15,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(contentProvider.notifier).reset();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(screenHeight * 0.12, screenHeight * 0.12),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/bersihkan.png',
                      height: screenHeight * 0.05,
                    ),
                    SizedBox(height: screenHeight * 0.0125),
                    Text(
                      'Bersihkan',
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        color: AppColors.primaryFont,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.15,
              width: screenHeight * 0.15,
              child: ElevatedButton(
                onPressed: () {
                  /// Swap mode
                  ref.read(typeNotifierProvider.notifier).toggle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(screenHeight * 0.12, screenHeight * 0.12),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: ref.watch(typeNotifierProvider) == false
                          ? Icon(
                              Icons.keyboard,
                              color: AppColors.primaryBg,
                              key: const ValueKey('keyboard'),
                              size: screenHeight * 0.05,
                            )
                          : Image.asset(
                              'assets/icons/kartu.png',
                              key: const ValueKey('kartu'),
                              height: screenHeight * 0.05,
                            ),
                    ),
                    SizedBox(height: screenHeight * 0.0125),
                    Text(
                      ref.watch(typeNotifierProvider) == false
                          ? 'Keyboard'
                          : 'Kartu',
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        color: AppColors.primaryFont,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.15,
              width: screenHeight * 0.15,
              child: ElevatedButton(
                onPressed: () => showSettingsModal(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(screenHeight * 0.12, screenHeight * 0.12),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/pengaturan.png',
                      height: screenHeight * 0.05,
                    ),
                    SizedBox(height: screenHeight * 0.0125),
                    Text(
                      'Pengaturan',
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        color: AppColors.primaryFont,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum KeyboardMode { letter, symbol }
