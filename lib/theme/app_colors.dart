import 'package:flutter/material.dart';

/// Zentrale Farbpalette – kindgerecht, warm & kontrastreich.
/// Tipp: Wenn du später CI-Farben festlegst, passe NUR hier an.
class AppColors {
  // Grundfarben
  static const Color primary = Color(0xFF4A90E2); // Blau
  static const Color secondary = Color(0xFFFFB74D); // Orange
  static const Color success = Color(0xFF4AD480); // Giftgrün (aus NOTEkey)
  static const Color error = Color(0xFFE53935); // Rot

  // Hintergrund & Oberflächen
  static const Color background = Color(0xFFFFF9F3); // Warmes Hellbeige
  static const Color surface = Colors.white;

  // Textfarben
  static const Color textPrimary =
      Color(0xFF30241B); // Dunkelbraun (Kontinuität)
  static const Color textSecondary = Color(0xFF5B4A3E);

  // Deko/Fokus
  static const Color accentBlue = Color(0xFF1976D2);
  static const Color accentYellow = Color(0xFFFFD54F);

  // Verlauf (Animation-Screen)
  static const List<Color> gradientA = [
    Color(0xFF4A90E2), // blau
    Color(0xFF81D4FA), // hellblau
  ];
  static const List<Color> gradientB = [
    Color(0xFFFFB74D), // orange
    Color(0xFFFFF176), // gelb
  ];
}
