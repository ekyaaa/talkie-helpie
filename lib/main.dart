import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talkie_helpie/core/style/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkie_helpie/views/home_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Set the orientations to landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'ComicSans',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.primaryFont),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.primaryFont,
          selectionColor: AppColors.primaryFont,
          selectionHandleColor: AppColors.primaryFont,
        ),
      ),
      home: const HomeLayout(),
    );
  }
}
