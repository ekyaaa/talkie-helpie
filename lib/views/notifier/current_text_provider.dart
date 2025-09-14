import 'package:talkie_helpie/views/notifier/full_text_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkie_helpie/views/notifier/content_widget_notifier.dart';
import '../../core/helper/image_card_filter.dart';
import '../../core/services/image_card_storage_service.dart';

/// State yang menyimpan controller dan focus node
class EditorState {
  final TextEditingController controller;
  final FocusNode focusNode;

  EditorState({
    required this.controller,
    required this.focusNode,
  });
}

/// Notifier untuk menangani logika kursor & teks
class EditorController extends Notifier<EditorState> {
  late final imageStorage = ref.watch(imageStorageAsyncProvider.notifier);
  @override
  EditorState build() {
    // Inisialisasi state
    final controller = TextEditingController();
    final focusNode = FocusNode();

    // Tambahkan listener
    controller.addListener(_onTextChanged);

    // Kembalikan state awal
    return EditorState(controller: controller, focusNode: focusNode);
  }

  void _onTextChanged() {
    // Trigger rebuild agar provider tahu text berubah
    state = EditorState(
      controller: state.controller,
      focusNode: state.focusNode,
    );
  }

  void _ensureFocus() {
    if (!state.focusNode.hasFocus) {
      state.focusNode.requestFocus();
    }
  }

  void moveCursor(int offsetDelta) {
    _ensureFocus();
    final offset = state.controller.selection.baseOffset;
    final newOffset = (offset + offsetDelta).clamp(0, state.controller.text.length);
    state.controller.selection = TextSelection.collapsed(offset: newOffset);
  }

  void insertCharacter(String char) {
    _ensureFocus();

    final text = state.controller.text;
    final selection = state.controller.selection;

    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;

    final newText = text.replaceRange(start, end, char);
    final newOffset = start + char.length;
    
    ref.read(searchKeywordProvider.notifier).setKeyword(newText);
    
    state.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }


  void resetCurrentWord() {
    _ensureFocus();
    state.controller.value = const TextEditingValue(
      text: '',
      selection: TextSelection.collapsed(offset: 0),
    );
  }

  void deleteBackward() {
    _ensureFocus();

    final text = state.controller.text;
    final selection = state.controller.selection;
    final offset = selection.baseOffset;

    if (offset <= 0) return;

    final newText = text.replaceRange(offset - 1, offset, '');
    final newOffset = offset - 1;

    state.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }

  Future<void> addWordWithSpace() async {
    if(await imageStorage.wordExists(state.controller.text)){
      ref.read(fullTextProvider.notifier).addWord(state.controller.text, WordSeparator.space);
      ref.read(contentProvider.notifier).addWord(await imageStorage.findWordExactOrFallback(state.controller.text));
    } else {
      ref.read(fullTextProvider.notifier).addWord(state.controller.text, WordSeparator.space);
      ref.read(contentProvider.notifier).addUnknownWord(state.controller.text);
    }
    resetCurrentWord();
  }

  Future<void> addFromRecommendation(String word) async {
    if(await imageStorage.wordExists(word)){
      ref.read(fullTextProvider.notifier).addWord(word, WordSeparator.space);
      ref.read(contentProvider.notifier).addWord(await imageStorage.findWordExactOrFallback(word));
    } else {
      ref.read(fullTextProvider.notifier).addWord(word, WordSeparator.space);
      ref.read(contentProvider.notifier).addUnknownWord(word);
    }
    resetCurrentWord();
  }

  Future<void> addWordWithSeparator(WordSeparator separator) async {
    if(await imageStorage.wordExists(state.controller.text)){
      ref.read(fullTextProvider.notifier).addWord(state.controller.text, separator);
      ref.read(contentProvider.notifier).addWord(await imageStorage.findWordExactOrFallback(state.controller.text));
    } else {
      ref.read(fullTextProvider.notifier).addWord(state.controller.text, separator);
      ref.read(contentProvider.notifier).addUnknownWord(state.controller.text);
    }
    // For adding the widget separator
    switch(separator) {
      case WordSeparator.space:
        ref.read(contentProvider.notifier).addSeparator(' ');
      case WordSeparator.comma:
        ref.read(contentProvider.notifier).addSeparator(', ');
      case WordSeparator.dot:
        ref.read(contentProvider.notifier).addSeparator('. ');
    }
    resetCurrentWord();
  }
}

/// Provider utama untuk editor
final editorProvider = NotifierProvider<EditorController, EditorState>(EditorController.new);
