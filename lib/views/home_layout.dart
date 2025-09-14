import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkie_helpie/views/widgets/cards_layout.dart';
import 'package:talkie_helpie/views/widgets/keyboard_layout.dart';
import 'package:talkie_helpie/views/widgets/output_row.dart';
import 'notifier/type_notifier.dart';

class HomeLayout extends ConsumerWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKeyboard = ref.watch(typeNotifierProvider);

    return Scaffold(
      body: Column(
        children: [
          OutputRow(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1), // dari atas
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              child: isKeyboard ? const KeyboardLayout() : const CardsLayout(),
            ),
          ),
        ],
      ),
    );
  }
}
