import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:talkie_helpie/core/data/word_object_list.dart';

void main() {
  // Simulasi list default
  TestWidgetsFlutterBinding.ensureInitialized();

  // Tes apakah asset bisa di-load
  test('All word images exist in assets', () async {
    for (var word in defaultWordList) {
      bool exists = true;
      try {
        await rootBundle.load(word.imgPath);
      } catch (e) {
        exists = false;
      }
      print('${word.word} -> exists? $exists'); // <-- print status
      expect(exists, true, reason: 'Asset not found: ${word.imgPath}');
    }
  });

}

