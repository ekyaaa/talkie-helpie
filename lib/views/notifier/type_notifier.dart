import 'package:flutter_riverpod/flutter_riverpod.dart';

class TypeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

// Provider
final typeNotifierProvider =
NotifierProvider<TypeNotifier, bool>(TypeNotifier.new);
