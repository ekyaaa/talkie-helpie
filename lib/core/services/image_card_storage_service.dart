import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talkie_helpie/core/models/word.dart';
import 'package:talkie_helpie/core/data/word_object_list.dart';

import '../helper/image_card_filter.dart';

class ImageStorageNotifier extends AsyncNotifier<List<Word>> {
  File? _file;

  // Getter async
  // ignore: avoid_public_notifier_properties
  Future<File> get file async {
    if (_file != null) return _file!;

    final dir = await getApplicationDocumentsDirectory();
    final f = File('${dir.path}/data/card_image_storage.json');

    // Buat folder jika belum ada
    if (!await f.parent.exists()) {
      await f.parent.create(recursive: true);
    }

    // Buat file kosong jika belum ada
    if (!await f.exists()) {
      await f.writeAsString('');
    }

    _file = f;
    return _file!;
  }

  @override
  Future<List<Word>> build() async {
    final f = await file;
    final content = await f.readAsString();

    if (content.isEmpty) {
      final defaultWords = _defaultWords();
      await _saveJson(defaultWords);
      return defaultWords;
    }

    final List<dynamic> jsonData = jsonDecode(content);
    return jsonData.map((e) => Word.fromJson(e)).toList();
  }

  Future<void> _saveJson(List<Word> words) async {
    final f = await file;
    final jsonString = jsonEncode(words.map((e) => e.toJson()).toList());
    await f.writeAsString(jsonString);
  }

  List<Word> _defaultWords() => defaultWordList;

  Future<void> addWord(Word word) async {
    final current = state.value ?? [];
    final newList = [...current, word];
    state = AsyncValue.data(newList);
    await _saveJson(newList);
  }

  Future<void> replaceWordInJson(Word newWord) async {
    final f = await file;
    final content = await f.readAsString();
    List<dynamic> jsonList = content.isEmpty ? [] : jsonDecode(content);
    List<Word> wordList = jsonList.map((e) => Word.fromJson(e)).toList();

    final index = wordList.indexWhere((w) => w.id == newWord.id);
    if (index != -1) {
      wordList[index] = newWord;
    } else {
      wordList.add(newWord);
    }

    await f.writeAsString(jsonEncode(wordList.map((w) => w.toJson()).toList()));
  }

  Future<bool> wordExists(String query) async {
    final words = state.value ?? [];

    return words.any((w) => w.word.toLowerCase() == query.toLowerCase());
  }

  Future<Word> findWordExactOrFallback(String query) async {
    final words = state.value ?? [];

    return words.firstWhere(
          (w) => w.word.toLowerCase() == query.toLowerCase(),
      orElse: () => Word(word: query, imgPath: '', id: '', type: WordType.emotion),
    );
  }

  final wordRecommendationProvider = FutureProvider<List<Word>>((ref) async {
    final keyword = ref.watch(searchKeywordProvider).toLowerCase();
    final wordsAsync = await ref.watch(imageStorageAsyncProvider.future);

    if (keyword.isEmpty) {
      // Ambil 4 pertama
      return wordsAsync.take(4).toList();
    }

    // Filter yang mengandung keyword
    final matches = wordsAsync
        .where((w) => w.word.toLowerCase().contains(keyword))
        .take(4)
        .toList();

    if (matches.isEmpty) {
      // Fallback → bikin Word dummy dengan keyword
      return [
        Word(
          word: keyword,
          imgPath: '',
          id: '', // bisa juga pakai DateTime.now().millisecondsSinceEpoch.toString()
          type: WordType.emotion,
        )
      ];
    }

    return matches;
  });
}

final imageStorageAsyncProvider =
AsyncNotifierProvider<ImageStorageNotifier, List<Word>>(ImageStorageNotifier.new);
