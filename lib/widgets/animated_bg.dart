import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Wiederverwendbarer animierter Hintergrund mit:
/// - weichem Farbverlauf (pendelnd zwischen 2 Paletten)
/// - schwebenden Memory-Karten-Partikeln
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final Duration gradientDuration;
  final Duration particleDuration;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.gradientDuration = const Duration(seconds: 6),
    this.particleDuration = const Duration(seconds: 8),
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _particleController;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: widget.gradientDuration,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: widget.particleDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bgController, _particleController]),
      builder: (_, __) => Stack(
        children: [
          _AnimatedGradientBackground(progress: _bgController.value),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _CardsParticlePainter(t: _particleController.value),
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

/// Linearer Gradient, der sanft zwischen zwei Farbpaletten wechselt.
class _AnimatedGradientBackground extends StatelessWidget {
  final double progress;
  const _AnimatedGradientBackground({required this.progress});

  @override
  Widget build(BuildContext context) {
    final colors = List<Color>.generate(
      min(AppColors.gradientA.length, AppColors.gradientB.length),
      (i) => Color.lerp(
        AppColors.gradientA[i],
        AppColors.gradientB[i],
        Curves.easeInOut.transform(progress),
      )!,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

/// Schwebende Partikel (runde Memory-Karten)
class _CardsParticlePainter extends CustomPainter {
  final double t;
  const _CardsParticlePainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    const count = 14;
    for (int i = 0; i < count; i++) {
      final x =
          (0.1 + (i % 5) * 0.2) * size.width + sin((t * 2 * pi) + i) * 20.0;
      final y = size.height * (1 - ((t + (i * 0.07)) % 1.0));
      final w = 18.0 + (sin(i * 13.3 + t * 2 * pi) * 9.0) + (i % 3) * 6.0;

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(x, y), width: w * 1.4, height: w),
        const Radius.circular(10),
      );

      paint.color = Color.lerp(
        AppColors.accentBlue.withValues(alpha: 0.25),
        AppColors.accentYellow.withValues(alpha: 0.25),
        (i % 2 == 0)
            ? (0.35 + 0.4 * sin(t * pi + i))
            : (0.25 + 0.5 * cos(t * pi + i)),
      )!;
      canvas.drawRRect(rect, paint);

      final border = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = Colors.white.withValues(alpha: 0.35);
      canvas.drawRRect(rect, border);
    }
  }

  @override
  bool shouldRepaint(covariant _CardsParticlePainter oldDelegate) =>
      oldDelegate.t != t;
}
