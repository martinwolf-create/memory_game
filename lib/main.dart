import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash/animation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MemoryGameApp());
}

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const AnimationScreen(),
    );
  }
}
