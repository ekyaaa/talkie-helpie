import 'package:flutter_riverpod/flutter_riverpod.dart';

enum KeyboardMode { letter, symbol }

class KeyboardState {
  final KeyboardMode mode;

  const KeyboardState({required this.mode});

  KeyboardState copyWith({
    KeyboardMode? mode,
  }) {
    return KeyboardState(
      mode: mode ?? this.mode,
    );
  }
}

// Gunakan Notifier<KeyboardState> untuk Riverpod 3
class KeyboardStateNotifier extends Notifier<KeyboardState> {
  @override
  KeyboardState build() {
    // initial state
    return const KeyboardState(mode: KeyboardMode.letter);
  }

  void toggleMode() {
    state = state.copyWith(
      mode: state.mode == KeyboardMode.letter
          ? KeyboardMode.symbol
          : KeyboardMode.letter,
    );
  }
}

final keyboardProvider = NotifierProvider<KeyboardStateNotifier, KeyboardState>(
      () => KeyboardStateNotifier(),
);
