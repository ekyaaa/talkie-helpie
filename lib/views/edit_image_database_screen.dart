import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkie_helpie/core/style/app_colors.dart';
import 'package:talkie_helpie/views/widgets/modals/edit_card_modal.dart';
import '../core/helper/card_color_picker.dart';
import '../core/helper/truncate_word.dart';
import '../core/services/image_card_storage_service.dart';

class EditImageDatabaseScreen extends ConsumerWidget {
  const EditImageDatabaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final wordsAsync = ref.watch(imageStorageAsyncProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.thirdBg,
        foregroundColor: AppColors.bgSecondary,
        onPressed: () {
          editCardModal(context, null, ref, false);
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.primaryBg,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Edit Gambar Database',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBg,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Divider(color: AppColors.secondaryBg, thickness: 3),
            // Card generator
            Expanded(
              child: wordsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text("Error: $err")),
                data: (words) {
                  return GridView.builder(
                    cacheExtent: 500,
                    // Render only 500 pixels out of the screen
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 4 / 3, // w:h cards ratio
                        ),
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.02,
                      bottom: screenHeight * 0.02,
                    ),
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      final word = words[index];
                      return GestureDetector(
                        onTap: () {
                          editCardModal(context, word, ref, index >= 42);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: getCardBgColor(word.type),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: getCardBorderColor(word.type),
                              width: 3,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (word.imgPath.startsWith("assets/"))
                                // Kalau path dari assets
                                Image.asset(
                                  word.imgPath,
                                  fit: BoxFit.cover,
                                  width: screenHeight * 0.125,
                                  height: screenHeight * 0.125,
                                )
                              else
                                // Kalau path dari file lokal
                                Builder(
                                  builder: (context) {
                                    final file = File(word.imgPath);

                                    if (file.existsSync()) {
                                      return Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          child: Image.file(
                                            file,
                                            width: screenHeight * 0.125,
                                            height: screenHeight * 0.125,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const Text("File tidak ditemukan");
                                    }
                                  },
                                ),
                              const SizedBox(height: 6),
                              Text(
                                truncateWord(word.word, 12),
                                style: TextStyle(
                                  fontSize: screenHeight * 0.04,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
