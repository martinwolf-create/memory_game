import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/animated_bg.dart';
import '../../data/sound_catalog.dart'; // <- deine Kategorien/Assets-Liste
import '../../services/sound_player.dart'; // <- dein Player (play(path))

import 'widgets/memory_card.dart';

class GameScreen extends StatefulWidget {
  final String category; // z.B. "Tiere"
  final int pairs; // 2,3,4,5,6,12 -> ergibt 4..24 Karten

  const GameScreen({
    super.key,
    required this.category,
    required this.pairs,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _rand = Random();
  final _player = SoundPlayer();

  late List<_CardModel> _deck;
  _CardModel? _firstOpen;
  _CardModel? _secondOpen;

  int _moves = 0;
  int _matches = 0;
  bool _lock = false;

  @override
  void initState() {
    super.initState();
    _buildDeck();
  }

  void _buildDeck() {
    // 1) Kategorieliste holen (SoundCatalog liefert Pfade+Labels)
    final entries = SoundCatalog.byCategory(widget.category);

    // Sicherstellen, dass genug Items da sind
    final needed = widget.pairs;
    final list = entries.length >= needed
        ? entries.sublist(0, needed)
        : List.generate(needed, (i) => entries[i % entries.length]);

    // 2) Deck bauen (jede Karte doppelt)
    int id = 0;
    final tmp = <_CardModel>[];
    for (final e in list) {
      tmp.add(_CardModel(id: id++, label: e.label, sound: e.soundPath));
      tmp.add(_CardModel(id: id++, label: e.label, sound: e.soundPath));
    }

    tmp.shuffle(_rand);
    _deck = tmp;
  }

  Future<void> _onCardTap(_CardModel card) async {
    if (_lock || card.isFaceUp || card.isMatched) return;

    setState(() => card.isFaceUp = true);
    _player.play(card.sound); // Karte aufdecken -> Sound abspielen

    if (_firstOpen == null) {
      _firstOpen = card;
      return;
    }

    if (_secondOpen == null && card != _firstOpen) {
      _secondOpen = card;
      _moves++;
      _lock = true;

      // Match prüfen
      await Future.delayed(const Duration(milliseconds: 650));
      final isMatch = _firstOpen!.label == _secondOpen!.label;

      if (isMatch) {
        _player.play('assets/sfx/success.mp3');
        setState(() {
          _firstOpen!.isMatched = true;
          _secondOpen!.isMatched = true;
          _matches++;
        });
      } else {
        _player.play('assets/sfx/fail.mp3');
        setState(() {
          _firstOpen!.isFaceUp = false;
          _secondOpen!.isFaceUp = false;
        });
      }

      _firstOpen = null;
      _secondOpen = null;
      _lock = false;

      if (_matches == widget.pairs) {
        _showWinDialog();
      }
    }
  }

  void _showWinDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.rosebeige,
        title: const Text('🎉 Super!'),
        content: Text('Du hast alle Paare in $_moves Zügen gefunden.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _moves = 0;
                _matches = 0;
                _firstOpen = null;
                _secondOpen = null;
                _buildDeck();
              });
            },
            child: const Text('Nochmal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zurück'),
          ),
        ],
      ),
    );
  }

  int _crossAxisForCount(int count) {
    // simple responsive Heuristik
    if (count <= 8) return 3;
    if (count <= 12) return 4;
    if (count <= 16) return 4;
    return 4; // 20/24
  }

  @override
  Widget build(BuildContext context) {
    final totalCards = widget.pairs * 2;
    final cross = _crossAxisForCount(totalCards);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.dunkelbraun.withOpacity(0.9),
        title: Text('Kategorie: ${widget.category}'),
        centerTitle: true,
      ),
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header / Stats
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    _StatChip(
                        icon: Icons.touch_app, label: 'Züge', value: '$_moves'),
                    const SizedBox(width: 8),
                    _StatChip(
                        icon: Icons.check_circle,
                        label: 'Paare',
                        value: '$_matches/${widget.pairs}'),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _moves = 0;
                          _matches = 0;
                          _firstOpen = null;
                          _secondOpen = null;
                          _buildDeck();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dunkelbraun,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                      ),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Neu'),
                    )
                  ],
                ),
              ),

              // Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    itemCount: _deck.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cross,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (_, i) {
                      final card = _deck[i];
                      return MemoryCard(
                        label: card.label,
                        faceUp: card.isFaceUp || card.isMatched,
                        matched: card.isMatched,
                        onTap: () => _onCardTap(card),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatChip(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.dunkelbraun),
          const SizedBox(width: 6),
          Text('$label: ', style: TextStyle(color: AppColors.dunkelbraun)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: AppColors.dunkelbraun)),
        ],
      ),
    );
  }
}

class _CardModel {
  final int id;
  final String label;
  final String sound;
  bool isFaceUp = false;
  bool isMatched = false;

  _CardModel({
    required this.id,
    required this.label,
    required this.sound,
  });
}
