import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/models/word.dart';
import '../../../core/services/image_card_storage_service.dart';
import '../../../core/services/selected_cards_service.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle, Uint8List;

Future<void> updateCard(WidgetRef ref, Word newWord) async {
  final cleanImgPath = await saveCroppedImageToProviderPath(newWord.imgPath, newWord.id);
  if (cleanImgPath == null) return;

  final storageProvider = ref.read(imageStorageAsyncProvider.notifier);
  final selectedProvider = ref.read(selectedCardsAsyncProvider.notifier);

  // Update storage
  await storageProvider.replaceWordInJson(newWord);

  // Update selected cards, tambahkan jika belum ada
  final exists = await selectedProvider.idExists(newWord.id);
  if (exists) {
    await selectedProvider.replaceWordInJson(newWord);
  }
}

Future<void> createCard(WidgetRef ref, Word newWord) async {
  final cleanImgPath = await saveCroppedImageToProviderPath(
    newWord.imgPath,
    newWord.id,
  );

  if (cleanImgPath == null) {
    return;
  }

  final storageProvider = ref.read(imageStorageAsyncProvider.notifier);

  await storageProvider.addWord(
    Word(
      id: newWord.id,
      word: newWord.word,
      imgPath: cleanImgPath,
      type: newWord.type,
    ),
  );
}

Future<void> deleteCard(WidgetRef ref, Word selectedWord) async {
  final storageProvider = ref.read(imageStorageAsyncProvider.notifier);
  final selectedProvider = ref.read(selectedCardsAsyncProvider.notifier);

  await storageProvider.deleteWordCompletely(selectedWord.id);
  await selectedProvider.deleteWordById(selectedWord.id);
}

// Function to save cropped image to provider path
Future<String?> saveCroppedImageToProviderPath(
    String sourcePath,
    String imgName,
    ) async {
  try {
    Uint8List bytes;

    if (sourcePath.startsWith('assets/')) {
      bytes = (await rootBundle.load(sourcePath)).buffer.asUint8List();
    } else {
      bytes = await File(sourcePath).readAsBytes();
    }

    final dir = await getApplicationDocumentsDirectory();
    final saveDir = Directory('${dir.path}/card_images');
    if (!await saveDir.exists()) {
      await saveDir.create(recursive: true);
    }

    final ext = p.extension(sourcePath);
    final fileName = "$imgName$ext";
    final newPath = p.join(saveDir.path, fileName);

    final savedFile = await File(newPath).writeAsBytes(bytes);
    return savedFile.path;
  } catch (e) {
    return null;
  }
}

