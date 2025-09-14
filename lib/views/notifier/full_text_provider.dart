import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkie_helpie/core/services/tts_provider.dart';

enum WordSeparator { space, comma, dot }

class FullTextNotifier extends Notifier<String> {

  @override
  String build() {
    return '';
  }

  void addWord(String newWord, WordSeparator separator) {
    final String sep = switch (separator) {
      WordSeparator.space => ' ',
      WordSeparator.comma => ', ',
      WordSeparator.dot => '. ',
    };

    state += newWord + sep;
  }

  void deleteWord() {
    if (state.isEmpty) return;

    int index = state.length - 1;

    // Hapus trailing spasi dan koma/titik
    while (index >= 0 &&
        (state[index] == ' ' || state[index] == ',' || state[index] == '.')) {
      index--;
    }

    // Sekarang cari awal kata terakhir
    while (index >= 0 && state[index] != ' ') {
      index--;
    }

    // Ambil substring sampai sebelum kata terakhir
    state = state.substring(0, index + 1);
  }

  /// Menghapus semua isi string
  void reset() {
    state = '';
  }

  // For using TTS for this.state String
  Future<void> speak() async {
    final tts = await ref.read(ttsProvider.future);
    await tts.stop();

    ref.read(isSpeakingProvider.notifier).state = true;

    await tts.speak(state);

    tts.setCompletionHandler(() {
      ref.read(isSpeakingProvider.notifier).state = false;
    });

    tts.setCancelHandler(() {
      ref.read(isSpeakingProvider.notifier).state = false;
    });
  }
}

final fullTextProvider = NotifierProvider<FullTextNotifier, String>(FullTextNotifier.new);
