import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkie_helpie/core/services/selected_cards_service.dart';
import 'package:talkie_helpie/core/style/app_colors.dart';
import 'package:talkie_helpie/core/helper/card_color_picker.dart';
import 'package:talkie_helpie/views/widgets/modals/swap_selected_card_modal.dart';
import '../core/helper/truncate_word.dart';
import 'notifier/content_widget_notifier.dart';
import 'notifier/full_text_provider.dart';
import 'notifier/is_card_edit_notifier.dart';

class CardsLayout extends ConsumerWidget {
  const CardsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final wordsAsync = ref.watch(selectedCardsAsyncProvider);
    final isCardEdit = ref.watch(isCardEditProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isCardEdit ? AppColors.thirdBg : AppColors.secondaryBg,
      ),
      child: wordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (words) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 11, // 11 kolom
              childAspectRatio: 79 / 70, // rasio w:h
            ),
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: screenHeight * 0.02),
            itemCount: 44,
            itemBuilder: (context, index) {
              if (index == words.length) {
                return GestureDetector(
                  onTap: () => ref.read(isCardEditProvider.notifier).toggle(),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black54, width: 4),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, size: screenHeight * 0.1),
                        Text(
                          'Edit',
                          style: TextStyle(fontSize: screenHeight * 0.03),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final word = words[index];

              return GestureDetector(
                onTap: isCardEdit
                    ? () {
                  swapSelectedCardModal(context, ref, word.id);
                }
                    : () {
                        ref
                            .read(fullTextProvider.notifier)
                            .addWord(word.word, WordSeparator.space);
                        ref.read(contentProvider.notifier).addWord(word);
                      },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: getCardBgColor(word.type),
                    // nanti bisa ganti sesuai WordType
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: getCardBorderColor(word.type),
                      width: 4,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (word.imgPath.isNotEmpty)
                        if (word.imgPath.startsWith("assets/"))
                          Image.asset(
                            word.imgPath,
                            fit: BoxFit.cover,
                            height: screenHeight * 0.1,
                          )
                        else
                          Builder(
                            builder: (context) {
                              final file = File(word.imgPath);

                              if (file.existsSync()) {
                                return Image.file(
                                  file,
                                  height: screenHeight * 0.1,
                                );
                              } else {
                                return const Text("File tidak ditemukan");
                              }
                            },
                          ),
                      Text(
                        truncateWord(word.word, 9),
                        style: TextStyle(fontSize: screenHeight * 0.03),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
