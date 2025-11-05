import 'package:flutter/material.dart';
import 'package:memory_game/theme/app_colors.dart';
import 'package:memory_game/widgets/animated_bg.dart';

/// Hauptscreen des Memory-Games (nach dem Startscreen)
/// - nutzt denselben animierten Hintergrund wie der SplashScreen
/// - mit Auswahloptionen für Spieler, Schwierigkeit & Kategorien
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool vsComputer = true;
  int difficulty = 4;
  String category = 'Instrumente';

  final List<String> categories = [
    'Instrumente',
    'Tiere',
    'Fahrzeuge',
    'Natur',
    'Küche',
    'Stadt',
    'Emotionen',
    'Retro',
    'Glocken',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Memory – Auswahl'),
        backgroundColor: AppColors.dunkelbraun.withValues(alpha: 0.9),
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ListView(
              children: [
                const SizedBox(height: 16),

                // Abschnitt 1: Spielmodus
                Text(
                  'Wie möchtest du spielen?',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.dunkelbraun,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _ModeButton(
                      icon: Icons.computer,
                      label: 'vs. Computer',
                      active: vsComputer,
                      onTap: () => setState(() => vsComputer = true),
                    ),
                    const SizedBox(width: 10),
                    _ModeButton(
                      icon: Icons.people,
                      label: '2 Spieler',
                      active: !vsComputer,
                      onTap: () => setState(() => vsComputer = false),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Abschnitt 2: Schwierigkeit
                Text(
                  'Schwierigkeit',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.dunkelbraun,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  children: [4, 6, 8, 10, 12, 24].map((level) {
                    return ChoiceChip(
                      label: Text('$level'),
                      selected: difficulty == level,
                      selectedColor: AppColors.goldbraun,
                      labelStyle: TextStyle(
                        color: difficulty == level
                            ? Colors.white
                            : AppColors.dunkelbraun,
                      ),
                      onSelected: (_) => setState(() => difficulty = level),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                // Abschnitt 3: Kategorien
                Text(
                  'Kategorie wählen',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.dunkelbraun,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final selected = category == cat;
                    return GestureDetector(
                      onTap: () => setState(() => category = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.giftgruen.withValues(alpha: 0.8)
                              : Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected
                                ? AppColors.dunkelbraun
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 6,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            cat,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : AppColors.dunkelbraun,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Abschnitt 4: Start-Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.dunkelbraun,
                          content: Text(
                            'Starte Spiel: $category, Schwierigkeit: $difficulty',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Spiel starten'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dunkelbraun,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Modus-Button für "vs. Computer" / "2 Spieler"
class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active
                ? AppColors.goldbraun
                : AppColors.goldbraun.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 6,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  color: active ? Colors.white : AppColors.dunkelbraun,
                  size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: active ? Colors.white : AppColors.dunkelbraun,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
