// lib/services/sound_player.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundPlayer {
  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String assetPath) async {
    try {
      await _player.play(AssetSource(assetPath.replaceFirst('assets/', '')));
      // Wichtig: AssetSource erwartet den Pfad relativ zum assets-Root in pubspec.
      // Beispiel: 'assets/sfx/click.mp3' -> AssetSource('sfx/click.mp3')
    } catch (e) {
      debugPrint('Sound error for $assetPath -> $e');
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
