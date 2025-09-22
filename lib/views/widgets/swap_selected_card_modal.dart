import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:talkie_helpie/core/style/app_colors.dart';
import '../../core/helper/truncate_word.dart';
import '../../core/helper/card_color_picker.dart';
import '../../core/services/image_card_storage_service.dart';
import '../../core/services/selected_cards_service.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

void swapSelectedCardModal(BuildContext context, WidgetRef ref, String wordId) {
  final screenHeight = MediaQuery.of(context).size.height;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: AppColors.secondaryBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: const EdgeInsets.all(24), // biar gak mepet tepi layar
        child: Consumer(
          builder: (context, ref, _) {
            final searchQuery = ref.watch(searchQueryProvider);
            final filteredWords = ref.watch(filteredWordsProvider(searchQuery));

            return Container(
              width: MediaQuery.of(context).size.width * 0.6,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search bar
                  TextField(
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryBg, // warna border ketika focus
                          width: 2,
                        ),
                      ),
                      hintText: "Search...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // GridView for cards
                  SizedBox(
                    height: screenHeight * 0.4,
                    child: GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 5 / 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: filteredWords.length,
                      itemBuilder: (context, index) {
                        final word = filteredWords[index];

                        return GestureDetector(
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Konfirmasi"),
                                  content: const Text("Apakah kamu yakin ingin mengganti kartu ini?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text("Batal"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text("Ya, Ganti"),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              await ref
                                  .read(selectedCardsAsyncProvider.notifier)
                                  .replaceWordById(word, wordId);

                              Navigator.pop(context); // tutup modal utama setelah ganti
                            }
                          },

                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: getCardBgColor(word.type),
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
                                          return const Text(
                                              "File tidak ditemukan");
                                        }
                                      },
                                    ),
                                Text(
                                  truncateWord(word.word, 9),
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.03),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
