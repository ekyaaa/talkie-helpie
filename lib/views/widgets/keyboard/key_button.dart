import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../core/style/app_colors.dart';
import '../../notifier/current_text_provider.dart';
import '../../notifier/full_text_provider.dart';
import '../../notifier/keyboard_state.dart';

class KeyButton extends ConsumerWidget {
  final KeyboardMode mode;
  final VoidCallback toggleMode;
  final Color textColor; // <-- tambahkan

  const KeyButton(this.mode, {required this.toggleMode, this.textColor = AppColors.primaryFont, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyHeight = screenHeight * 0.09;
    final double keyWidth = screenWidth * 0.085;

    // Ambil list berdasarkan mode
    final List<String> row1 = mode == KeyboardMode.letter
        ? keyLetter1
        : keySymbol1;
    final List<String> row2 = mode == KeyboardMode.letter
        ? keyLetter2
        : keySymbol2;
    final List<String> row3 = mode == KeyboardMode.letter
        ? keyLetter3
        : keySymbol3;

    // Row generator for keyboard per column
    Widget buildRow(
      List<String> keys, {
      Widget? leftWidget,
      Widget? rightWidget,
      Widget? rightWidget2,
      Widget? rightWidget3,
    }) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leftWidget != null) leftWidget,
          ...keys.map(
            (key) => Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                width: keyWidth,
                height: keyHeight,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(editorProvider.notifier).insertCharacter(key);
                  },
                  style: ElevatedButton.styleFrom(
                    iconColor: AppColors.primaryFont,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // sudut tumpul
                    ),
                  ),
                  child: Text(key, style: TextStyle(fontSize: keyWidth * 0.25, color: textColor)),
                ),
              ),
            ),
          ),
          if (rightWidget != null) rightWidget,
          if (rightWidget2 != null) rightWidget2,
          if (rightWidget3 != null) rightWidget3,
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min, // agar height-nya pas dengan konten
      children: [
        // First Row
        buildRow(
          row1,
          rightWidget: Padding(
            padding: const EdgeInsets.all(2.0),
            child: SizedBox(
              width: keyWidth,
              height: keyHeight,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(editorProvider.notifier).deleteBackward();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  iconColor: AppColors.primaryFont,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // sudut tumpul
                  ),
                ),
                child: const Icon(Icons.backspace, size: 16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Second Row
        buildRow(
          row2,
          rightWidget: Padding(
            padding: const EdgeInsets.all(2.0),
            child: SizedBox(
              width: keyWidth,
              height: keyHeight,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(editorProvider.notifier).resetCurrentWord();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // sudut tumpul
                  ),
                ),
                child: Icon(Icons.restart_alt, size: keyWidth * 0.3, color: AppColors.primaryFont),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Third Row
        buildRow(
          row3,
          // Comma button
          rightWidget: Padding(
            padding: const EdgeInsets.all(2.0),
            child: SizedBox(
              width: keyWidth * 0.7,
              height: keyHeight,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(editorProvider.notifier)
                      .addWordWithSeparator(WordSeparator.comma);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // sudut tumpul
                  ),
                ),
                child: Center(
                  child: Text(
                    ',',
                    style: TextStyle(
                      fontSize: keyWidth * 0.25,
                      color: AppColors.primaryFont,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // dot button
          rightWidget2: Padding(
            padding: const EdgeInsets.all(2.0),
            child: SizedBox(
              width: keyWidth * 0.7,
              height: keyHeight,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(editorProvider.notifier)
                      .addWordWithSeparator(WordSeparator.dot);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // sudut tumpul
                  ),
                ),
                child: Center(
                  child: Text(
                    '.',
                    style: TextStyle(
                      fontSize: keyWidth * 0.25,
                      color: AppColors.primaryFont,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Fourth Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                width: keyWidth,
                height: keyHeight,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(editorProvider.notifier).moveCursor(-1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // sudut tumpul
                    ),
                  ),
                  child: Icon(Icons.arrow_back, size: keyWidth * 0.3, color: AppColors.primaryFont),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                width: keyWidth * 5,
                height: keyHeight,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(editorProvider.notifier).addWordWithSpace();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // sudut tumpul
                    ),
                  ),
                  child: const Text(
                    '',
                    style: TextStyle(
                      fontSize: 30,
                      color: AppColors.primaryFont,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                width: keyWidth,
                height: keyHeight,
                child: ElevatedButton(
                  onPressed: () {
                    // cursor
                    ref.read(editorProvider.notifier).moveCursor(1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // sudut tumpul
                    ),
                  ),
                  child: Icon(Icons.arrow_forward, size: keyWidth * 0.3, color: AppColors.primaryFont),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                width: keyWidth * 1.3,
                height: keyHeight,
                child: ElevatedButton(
                  onPressed: () {
                    toggleMode();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // sudut tumpul
                    ),
                  ),
                  child: Text(
                    '123?',
                    style: TextStyle(
                      fontSize: keyWidth * 0.23,
                      color: AppColors.primaryFont,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

const List<String> keyLetter1 = [
  'q',
  'w',
  'e',
  'r',
  't',
  'y',
  'u',
  'i',
  'o',
  'p',
];
const List<String> keyLetter2 = ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'];
const List<String> keyLetter3 = ['z', 'x', 'c', 'v', 'b', 'n', 'm'];

const List<String> keyCapsLetter1 = [
  'Q',
  'W',
  'E',
  'R',
  'T',
  'Y',
  'U',
  'I',
  'O',
  'P',
];
const List<String> keyCapsLetter2 = [
  'A',
  'S',
  'D',
  'F',
  'G',
  'H',
  'J',
  'K',
  'L',
];
const List<String> keyCapsLetter3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

const List<String> keySymbol1 = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '0',
];
const List<String> keySymbol2 = [
  '@',
  '#',
  '\$',
  '%',
  '*',
  '(',
  ')',
  "'",
  '"',
  '^',
];
const List<String> keySymbol3 = ['&', '-', '+', '=', '/', ';', ':', '!', '?'];
