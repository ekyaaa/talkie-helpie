import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:talkie_helpie/core/style/app_colors.dart';
import '../../../core/helper/truncate_word.dart';
import '../../../core/helper/card_color_picker.dart';
import '../../../core/services/image_card_storage_service.dart';
import '../../../core/services/selected_cards_service.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

void swapSelectedCardModal(BuildContext context, WidgetRef ref, String wordId) {
  final screenHeight = MediaQuery.of(context).size.height;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // biar bisa tinggi lebih fleksibel
    backgroundColor: AppColors.secondaryBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16, // biar ga ketutup keyboard
        ),
        child: Consumer(
          builder: (context, ref, _) {
            final searchQuery = ref.watch(searchQueryProvider);
            final filteredWords = ref.watch(filteredWordsProvider(searchQuery));

            return SingleChildScrollView(
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
                          color: AppColors.primaryBg,
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
                    height: screenHeight * 0.5,
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
                                  content: const Text(
                                      "Apakah kamu yakin ingin mengganti kartu ini?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Batal"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
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

                              Navigator.pop(context); // tutup bottom sheet
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

