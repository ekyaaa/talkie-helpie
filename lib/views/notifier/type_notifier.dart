import 'package:flutter_riverpod/flutter_riverpod.dart';

// Notifier untuk boolean
class TypeNotifier extends Notifier<bool> {
  @override
  bool build() => false; // default true (misal: keyboard)

  void toggle() => state = !state;
}

// Provider
final typeNotifierProvider =
NotifierProvider<TypeNotifier, bool>(TypeNotifier.new);
