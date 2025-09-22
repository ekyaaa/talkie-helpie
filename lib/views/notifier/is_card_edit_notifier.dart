import 'package:flutter_riverpod/flutter_riverpod.dart';

// Notifier untuk boolean
class IsCardEdit extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

// Provider
final isCardEditProvider =
NotifierProvider.autoDispose<IsCardEdit, bool>(IsCardEdit.new);
