import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/style/app_colors.dart';
import '../../../core/helper/card_color_picker.dart';
import '../../../core/models/word.dart';
import '../../notifier/edit_card_notifier.dart';

class EditWordTypeDropdown extends ConsumerStatefulWidget {
  final List<WordType> items;
  final Word? word;
  final String hintText;

  const EditWordTypeDropdown({
    super.key,
    this.items = WordType.values,
    this.word,
    this.hintText = "Pilih opsi",
  });

  @override
  ConsumerState<EditWordTypeDropdown> createState() => _EditWordTypeDropdownState();
}

class _EditWordTypeDropdownState extends ConsumerState<EditWordTypeDropdown> {
  late WordType _selected;

  @override
  void initState() {
    super.initState();
    final state = ref.read(previewWordProvider(widget.word));
    _selected = state.type;
  }

  @override
  Widget build(BuildContext context) {
    // listen perubahan dari provider
    ref.listen<Word>(previewWordProvider(widget.word), (prev, next) {
      if (_selected != next.type) {
        setState(() {
          _selected = next.type;
        });
      }
    });

    return DropdownButtonFormField<WordType>(
      value: _selected,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: AppColors.secondaryBg,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
      dropdownColor: AppColors.secondaryBg,
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade500),
      items: widget.items.map((e) {
        return DropdownMenuItem<WordType>(
          value: e,
          child: Text(
            getCardNameColor(e),
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: (selected) {
        if (selected != null) {
          setState(() {
            _selected = selected;
          });
          ref
              .read(previewWordProvider(widget.word).notifier)
              .updateWordType(selected);
        }
      },
    );
  }
}
