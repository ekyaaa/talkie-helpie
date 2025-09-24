import 'package:flutter/material.dart';
import 'package:talkie_helpie/core/style/app_colors.dart';
import '../../../core/models/word.dart';
import '../../notifier/edit_card_notifier.dart';
import '../helper/card_preview.dart';
import '../helper/edit_word_input.dart';
import '../helper/edit_wordtype_dropdown.dart';
import '../helper/input_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helper/pick_and_crop_image_helper.dart';
import '../helper/save_update_helper.dart';

// Helper for create or edit card modal
void editCardModal(
  BuildContext context,
  Word? word,
  WidgetRef ref,
  bool canDelete,
) {
  final double screenHeight = MediaQuery.of(context).size.height;
  final double screenWidth = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.thirdBg,
        child: SizedBox(
          width: screenWidth * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Title
                  const Text(
                    'Edit Gambar',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryBg,
                    ),
                  ),
                  const SizedBox(height: 16),
              
                  /// Content
                  Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          rowInput(context, 'Kata:', EditWordInput(word: word)),
                          rowInput(
                            context,
                            'Gambar:',
                            imagePickerButton(
                              text: 'Masukkan Gambar',
                              onPressed: () async {
                                String? imagePath = await pickAndCropImage();
                                if (imagePath != null) {
                                  ref
                                      .read(previewWordProvider(word).notifier)
                                      .updateImage(imagePath);
                                }
                              },
                              icon: Icons.image_outlined,
                            ),
                          ),
                          rowInput(
                            context,
                            'Warna:',
                            EditWordTypeDropdown(word: word),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Consumer(
                              builder: (context, ref, _) {
                                final previewWord = ref.watch(
                                  previewWordProvider(word),
                                );
                                return SizedBox(
                                  width: screenWidth * 0.15,
                                  height: screenHeight * 0.21,
                                  child: cardPreview(context, previewWord),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: screenHeight * 0.06,
                              width: screenWidth * 0.2,
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Get newest created/edited word
                                  final newWord = ref.read(
                                    previewWordProvider(word),
                                  );
              
                                  // Create/Update Word
                                  if (word == null) {
                                    await createCard(ref, newWord);
                                  } else {
                                    await updateCard(ref, newWord);
                                  }
              
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBg,
                                  foregroundColor: AppColors.secondaryBg,
                                ),
                                child: Text(
                                  "Konfirmasi",
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.03,
                                    color: AppColors.secondaryBg,
                                    fontWeight: FontWeight
                                        .w600, // opsional, biar sedikit tebal
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: screenHeight * 0.06,
                              width: screenWidth * 0.2,
                              child: ElevatedButton(
                                onPressed: canDelete
                                    ? () async {
                                        // Tampilkan dialog konfirmasi sebelum delete
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Konfirmasi Hapus',
                                              ),
                                              content: const Text(
                                                'Apakah kamu yakin ingin menghapus kartu ini? Tindakan ini tidak bisa dibatalkan.',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(false),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(true),
                                                  child: const Text('Hapus'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
              
                                        // Jika user konfirmasi, baru hapus
                                        if (confirm == true) {
                                          await deleteCard(ref, word!);
                                          Navigator.of(
                                            context,
                                          ).pop(); // tutup modal edit
                                        }
                                      }
                                    : () {
                                        // Tampilkan peringatan
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Informasi'),
                                              content: const Text(
                                                'Kartu default tidak bisa dihapus. Kamu hanya bisa mengeditnya.',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context).pop(),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: canDelete
                                      ? Colors.redAccent
                                      : Colors.red.shade200,
                                ),
                                child: Text(
                                  "Hapus",
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.03,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // jarak antar tombol
                            SizedBox(
                              height: screenHeight * 0.06,
                              width: screenWidth * 0.2,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondaryBg,
                                ),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.03,
                                    color: AppColors.primaryBg,
                                    fontWeight: FontWeight
                                        .w600, // opsional, biar sedikit tebal
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
