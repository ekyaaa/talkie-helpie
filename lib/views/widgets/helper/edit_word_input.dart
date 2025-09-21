import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:talkie_helpie/core/models/word.dart';
import '../../../core/style/app_colors.dart';
import '../../notifier/edit_card_notifier.dart';


class EditWordInput extends ConsumerStatefulWidget {
  final Word? word;

  const EditWordInput({super.key, this.word});

  @override
  ConsumerState<EditWordInput> createState() => _EditWordInputState();
}

class _EditWordInputState extends ConsumerState<EditWordInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final state = ref.read(previewWordProvider(widget.word));
    _controller = TextEditingController(text: state.word);
  }

  @override
  Widget build(BuildContext context) {
    // sinkronkan kalau ada perubahan dari provider
    ref.listen<Word>(previewWordProvider(widget.word), (prev, next) {
      if (_controller.text != next.word) {
        _controller.text = next.word;
      }
    });

    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: "Masukkan teks",
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: AppColors.secondaryBg,
        contentPadding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.secondaryBg, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade500, width: 2),
        ),
      ),
      onChanged: (text) {
        ref.read(previewWordProvider(widget.word).notifier).updateWord(text);
      },
    );
  }
}
