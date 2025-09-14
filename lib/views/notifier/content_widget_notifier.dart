import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkie_helpie/core/models/word.dart';
import 'package:talkie_helpie/views/notifier/full_text_provider.dart';

enum WidgetType { word, separator, unknownWord }

class ContentItem {
  final WidgetType type;
  final Word? word;
  final String? text;

  ContentItem.word(this.word) : type = WidgetType.word, text = null;

  ContentItem.separator(this.text)
      : type = WidgetType.separator,
        word = null;

  ContentItem.unknownWord(this.text)
      : type = WidgetType.unknownWord,
        word = null;
}

class ContentWidgetNotifier extends Notifier<List<ContentItem>> {
  @override
  List<ContentItem> build() {
    return [];
  }

  void addWord(Word word) {
    state = [...state, ContentItem.word(word)];
  }

  void addSeparator(String separator) {
    state = [...state, ContentItem.separator(separator)];
  }

  void addUnknownWord(String rawWord) {
    state = [...state, ContentItem.unknownWord(rawWord)];
  }

  void backspace() {
    if (state.isNotEmpty) {
      state = state.sublist(0, state.length - 1);
      ref.read(fullTextProvider.notifier).deleteWord(); // ← sinkronkan teks
    }
  }

  void reset() {
    state = [];
    ref.read(fullTextProvider.notifier).reset(); // ← sinkronkan teks
  }
}

final contentProvider = NotifierProvider<ContentWidgetNotifier, List<ContentItem>>(ContentWidgetNotifier.new);