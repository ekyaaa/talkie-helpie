import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkie_helpie/views/cards_layout.dart';
import 'package:talkie_helpie/views/keyboard_layout.dart';
import 'package:talkie_helpie/views/output_row.dart';
import 'notifier/is_card_edit_notifier.dart';
import 'notifier/type_notifier.dart';

class HomeLayout extends ConsumerWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKeyboard = ref.watch(typeNotifierProvider);
    final isCardEdit = ref.watch(isCardEditProvider);

    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // Output sentence
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -1), // dari atas
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            child: isCardEdit
                ? SizedBox(
                    height: screenHeight * 0.228,
                    child: Center(child: Text('Mode Edit', style: TextStyle(fontSize: screenHeight * 0.1),)),
                  )
                : OutputRow(),
          ),

          // Keyboard or Cards input
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
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
