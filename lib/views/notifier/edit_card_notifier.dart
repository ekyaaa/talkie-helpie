import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkie_helpie/core/models/word.dart';

class PreviewWordNotifier extends Notifier<Word> {
  PreviewWordNotifier(this.word);

  final Word? word;

  @override
  Word build() {
    return word == null
        ? Word(
            word: '...',
            type: WordType.placeholder,
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            imgPath: 'assets/icons/default_card.png',
          )
        : word!;
  }

  void updateWord(String word) {
    state = state.copyWith(word: word);
  }

  void updateImage(String imgPath) {
    state = state.copyWith(imgPath: imgPath);
  }

  void updateWordType(WordType wordType) {
    state = state.copyWith(type: wordType);
  }
}

final previewWordProvider = NotifierProvider.family
    .autoDispose<PreviewWordNotifier, Word, Word?>(PreviewWordNotifier.new);
