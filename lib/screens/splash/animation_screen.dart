import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../home/home_screen.dart';

/// Animations-Splashscreen:
/// - Weicher Farbverlaufs-Background, der zwischen 2 Gradients hin- und herblendet
/// - Schwebende "Karten" (runde Quadrate) als Partikel
/// - Zentrum: animiertes Memory-Logo (Flip-Card-Feeling)
/// - CTA-Button "Los geht's" erscheint nach kurzer Zeit
class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _logoFlipController;
  late final AnimationController _particlesController;
  bool _showCta = false;

  @override
  void initState() {
    super.initState();

    // Hintergrund-Gradient pendelt
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    // Logo "Flip"
    _logoFlipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Partikel schweben
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // CTA etwas später einblenden
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _showCta = true);
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoFlipController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  void _goNext() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge(
            [_bgController, _logoFlipController, _particlesController]),
        builder: (context, _) {
          return Stack(
            children: [
              // 1) Verlauf-Background
              _AnimatedGradientBackground(progress: _bgController.value),

              // 2) Schwebende Partikel (Memory-Karten-Deko)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _CardsParticlePainter(
                      t: _particlesController.value,
                    ),
                  ),
                ),
              ),

              // 3) Zentraler Inhalt (Logo + Subtitle + CTA)
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _AnimatedLogo(progress: _logoFlipController.value),
                      const SizedBox(height: 10),
                      Text(
                        'Hören • Sehen • Merken',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 28),
                      AnimatedOpacity(
                        opacity: _showCta ? 1 : 0,
                        duration: const Duration(milliseconds: 600),
                        child: ElevatedButton.icon(
                          onPressed: _showCta ? _goNext : null,
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text("Los geht's"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Weich animierter linearer Gradient zwischen zwei Paletten.
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

/// Flip-Card-artiges Logo (nur mit Transform – ohne Assets)
class _AnimatedLogo extends StatelessWidget {
  final double progress;
  const _AnimatedLogo({required this.progress});

  @override
  Widget build(BuildContext context) {
    final angle = pi * progress; // 0 → pi (hin), dann reverse
    final isBack = progress > 0.5;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(angle),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        decoration: BoxDecoration(
          color: isBack ? AppColors.secondary : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16,
              offset: Offset(0, 8),
            )
          ],
          border: Border.all(
            color: isBack
                ? Colors.white.withOpacity(0.25)
                : AppColors.secondary.withOpacity(0.25),
            width: 2,
          ),
        ),
        child: Text(
          isBack ? 'Sound Memory' : 'Memory Game',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: isBack ? Colors.white : AppColors.textPrimary,
              ),
        ),
      ),
    );
  }
}

/// Maler für „schwebende Karten“-Partikel
class _CardsParticlePainter extends CustomPainter {
  final double t;
  _CardsParticlePainter({required this.t});

  final _rng = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    // deterministische Pseudo-Positionen, abgeleitet aus t
    const count = 14;
    for (int i = 0; i < count; i++) {
      final seed = i * 997;
      final p = _noise2D(seed, t);
      final x =
          (0.1 + (i % 5) * 0.2) * size.width + sin((t * 2 * pi) + i) * 20.0;
      final y = size.height * (1 - ((t + (i * 0.07)) % 1.0));
      final w = 18.0 + (p * 18.0) + (i % 3) * 6.0;
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(x, y), width: w * 1.4, height: w),
        const Radius.circular(10),
      );

      paint.color = Color.lerp(
        AppColors.accentBlue.withOpacity(0.25),
        AppColors.accentYellow.withOpacity(0.25),
        (i % 2 == 0) ? (0.35 + 0.4 * (p)) : (0.25 + 0.5 * (1 - p)),
      )!;
      canvas.drawRRect(rect, paint);

      // kleine „Kartenkante“
      final border = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = Colors.white.withOpacity(0.35);
      canvas.drawRRect(rect, border);
    }
  }

  // sehr einfache Rausch-Funktion
  double _noise2D(int seed, double t) {
    final v = sin(t * 2 * pi + seed) * 0.5 + 0.5;
    return v.clamp(0.0, 1.0);
  }

  @override
  bool shouldRepaint(covariant _CardsParticlePainter oldDelegate) {
    return oldDelegate.t != t;
  }
}
