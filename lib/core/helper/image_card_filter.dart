import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkie_helpie/core/models/word.dart';
import '../services/image_card_storage_service.dart';

// Helper for searching words with keyboard
class SearchKeywordNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setKeyword(String keyword) {
    state = keyword;
  }
}

final searchKeywordProvider = NotifierProvider<SearchKeywordNotifier, String>(
  SearchKeywordNotifier.new,
);

// Helper for provide 4 recommendation on keyboard
final wordRecommendationProvider = FutureProvider<List<Word>>((ref) async {
  final keyword = ref.watch(searchKeywordProvider).toLowerCase();
  final wordsAsync = await ref.watch(imageStorageAsyncProvider.future);

  if (keyword.isEmpty) {
    return wordsAsync.take(4).toList();
  }

  final matches = wordsAsync
      .where((w) => w.word.toLowerCase().contains(keyword))
      .take(4)
      .toList();

  if (matches.isEmpty) {
    return [
      Word(
        word: keyword,
        imgPath: '',
        id: '',
        type: WordType.emotion,
      ),
    ];
  }

  return matches;
});
