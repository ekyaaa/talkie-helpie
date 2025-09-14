import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Provider TTS (sudah kamu punya)
final ttsProvider = FutureProvider<FlutterTts>((ref) async {
  final flutterTts = FlutterTts();
  await flutterTts.setLanguage('id-ID');
  await flutterTts.setVolume(1.0);
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.setPitch(1.0);

  final voices = await flutterTts.getVoices;
  if (voices != null && voices.isNotEmpty) {
    final idVoice = voices.firstWhere(
      (voice) => voice['locale']?.toString().contains('id-ID') ?? false,
      orElse: () => voices.first,
    );
    await flutterTts.setVoice({
      'name': idVoice['name']?.toString() ?? 'default',
      'locale': idVoice['locale']?.toString() ?? 'id-ID',
    });
  }

  return flutterTts;
});

class IsSpeaking extends Notifier<bool> {
  @override
  bool build() {
    // this.ref is available anywhere inside notifiers
    return false;
  }

  void toggle() => state = !state;
}
final isSpeakingProvider = NotifierProvider<IsSpeaking, bool>(IsSpeaking.new);