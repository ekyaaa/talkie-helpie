import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/helper/image_card_filter.dart';
import '../../../core/style/app_colors.dart';
import '../../notifier/current_text_provider.dart';

class RecommendationRow extends ConsumerWidget {
  const RecommendationRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final recommendationsAsync = ref.watch(wordRecommendationProvider);
    final double keyWidth = screenWidth * 0.085;

    return recommendationsAsync.when(
      data: (recommendations) {
        return SizedBox(
          height: screenHeight * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: recommendations.map((recommendation) {
              return Padding(
                padding: EdgeInsets.all(screenHeight * 0.005),
                child: SizedBox(
                  width: screenWidth * 0.23,
                  height: screenHeight * 0.1,
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(editorProvider.notifier)
                          .addFromRecommendation(recommendation.word);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: recommendation.imgPath.isEmpty
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.center,
                      children: [
                        if (recommendation.imgPath.isEmpty)
                          const SizedBox.shrink()
                        else if (recommendation.imgPath.startsWith("assets/"))
                          Image.asset(
                            recommendation.imgPath,
                            fit: BoxFit.cover,
                            height: screenHeight * 0.05,
                          )
                        else
                          Builder(
                            builder: (context) {
                              final file = File(recommendation.imgPath);
                              debugPrint("imgPath: ${recommendation.imgPath}");
                              debugPrint("File exists? ${file.existsSync()}");

                              if (file.existsSync()) {
                                return Image.file(
                                  file,
                                  height: screenHeight * 0.05,
                                );
                              } else {
                                return const Text("File tidak ditemukan");
                              }
                            },
                          ),

                        if (recommendation.imgPath.isNotEmpty)
                          SizedBox(width: screenWidth * 0.017),

                        Text(
                          truncateWord(recommendation.word, 9),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: keyWidth * 0.25,
                            color: AppColors.primaryFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
      loading: () => SizedBox(
        height: screenHeight * 0.1,
        child: const CircularProgressIndicator(),
      ),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}

String truncateWord(String word, int maxLength) {
  if (word.length <= maxLength) return word;
  return '${word.substring(0, maxLength)}...';
}
