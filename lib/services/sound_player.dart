import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SoundPlayer {
  SoundPlayer._();
  static final SoundPlayer instance = SoundPlayer._();
  final AudioPlayer _player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

  Future<void> playAsset(BuildContext context, String assetPath) async {
    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sound fehlt oder Fehler: $assetPath')),
      );
    }
  }

  Future<void> dispose() => _player.dispose();
}
