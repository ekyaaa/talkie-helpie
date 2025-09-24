import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/style/app_colors.dart';
import 'notifier/keyboard_state.dart';
import 'widgets/keyboard/current_text_review.dart';
import 'widgets/keyboard/key_button.dart';
import 'widgets/keyboard/recommendation_row.dart';

class KeyboardLayout extends ConsumerWidget {
  const KeyboardLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyboardState = ref.watch(keyboardProvider);
    final mode = keyboardState.mode;
    final double screenHeight = MediaQuery.of(context).size.height;

    void toggleMode() {
      ref.read(keyboardProvider.notifier).toggleMode();
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.secondaryBg,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Current Input
          const CurrentTextReview(),
          SizedBox(height: screenHeight * 0.02),
          // Words recomendation
          const RecommendationRow(),
          SizedBox(height: screenHeight * 0.02),
          // Key Buttons
          KeyButton(mode, toggleMode: toggleMode),
          SizedBox(height: screenHeight * 0.075),
        ],
      ),
    );
  }
}
