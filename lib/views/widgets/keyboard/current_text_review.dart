import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/style/app_colors.dart';
import '../../notifier/current_text_provider.dart';

class CurrentTextReview extends ConsumerWidget {
  const CurrentTextReview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double keyWidth = screenWidth * 0.085;

    final editorState = ref.watch(editorProvider);
    final controller = editorState.controller;
    final focusNode = editorState.focusNode;

    return SizedBox(
      height: screenHeight * 0.12,
      width: screenWidth * 0.25,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        readOnly: true,
        showCursor: true,
        // Cursor tetap terlihat
        textAlign: TextAlign.center,
        // Tengah secara horizontal
        style: TextStyle(
          fontSize: keyWidth * 0.22,
          color: AppColors.primaryFont,
        ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryFont),
          ),
        ),
      ),
    );
  }
}
