import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 🔑 WAJIB

  try {
    final dir = await getApplicationDocumentsDirectory();
    final f = File('${dir.path}/data/card_image_storage.json');

    if (await f.exists()) {
      final content = await f.readAsString();
      if (content.isEmpty) {
        print("⚠️ File ada, tapi masih kosong.");
      } else {
        print("✅ File ada, isi:");
        print(content);
      }
    } else {
      print("❌ File tidak ditemukan: ${f.path}");
    }
  } catch (e) {
    print("🔥 Error membaca file: $e");
  }
}
