import 'dart:math';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class MemoryCard extends StatelessWidget {
  final String label;
  final bool faceUp;
  final bool matched;
  final VoidCallback onTap;

  const MemoryCard({
    super.key,
    required this.label,
    required this.faceUp,
    required this.matched,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = matched
        ? AppColors.giftgruen
        : (faceUp ? Colors.white : Colors.white.withOpacity(0.85));

    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: faceUp ? 1 : 0, end: faceUp ? 1 : 0),
        duration: const Duration(milliseconds: 250),
        builder: (context, value, child) {
          // einfacher "Flip": 0..1 -> 0..pi
          final angle = value * pi;
          final isBack = angle > pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: Container(
              decoration: BoxDecoration(
                color: isBack ? bg : bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: matched
                      ? AppColors.dunkelbraun
                      : Colors.white.withOpacity(0.6),
                  width: matched ? 2 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: faceUp ? 1 : 0,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: matched ? Colors.white : AppColors.dunkelbraun,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
