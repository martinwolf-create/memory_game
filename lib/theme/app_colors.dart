import 'package:flutter/material.dart';

/// Zentrale Farbpalette – freundlich & kontrastreich für Kinder.
class AppColors {
  // Brand
  static const Color primary = Color(0xFF4A90E2); // Blau
  static const Color secondary = Color(0xFFFFB74D); // Orange

  // Status
  static const Color success = Color(0xFF4AD480);
  static const Color error = Color(0xFFE53935);

  // Surfaces
  static const Color background = Color(0xFFFFF9F3);
  static const Color surface = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF30241B);
  static const Color textSecondary = Color(0xFF5B4A3E);

  // Deko
  static const Color accentBlue = Color(0xFF1976D2);
  static const Color accentYellow = Color(0xFFFFD54F);
  static const Color accentPink = Color(0xFFF06292);
  static const Color accentMint = Color(0xFF80CBC4);

  // Gradient-Paletten für Splash (blendet zwischen A und B)
  static const List<Color> gradientA = [
    Color(0xFF4A90E2), // blau
    Color(0xFF81D4FA), // hellblau
  ];
  static const List<Color> gradientB = [
    Color(0xFFFFB74D), // orange
    Color(0xFFFFF176), // gelb
  ];
}
