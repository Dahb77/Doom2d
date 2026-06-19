import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Game over and victory screens
class GameOverScreen extends StatelessWidget {
  final int score;
  final int level;
  final int kills;
  final bool isVictory;
  final VoidCallback onRestart;
  final VoidCallback onMenu;

  const GameOverScreen({
    super.key,
    required this.score,
    required this.level,
    required this.kills,
    required this.isVictory,
    required this.onRestart,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              isVictory ? 'VICTORY!' : 'GAME OVER',
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w900,
                color: isVictory ? DoomColors.exitColor : DoomColors.menuTitle,
                letterSpacing: 8,
                fontFamily: 'monospace',
                shadows: [
                  Shadow(
                    color: isVictory
                        ? DoomColors.exitColor.withOpacity(0.6)
                        : DoomColors.menuTitle.withOpacity(0.6),
                    blurRadius: 30,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Stats
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: DoomColors.hudBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: DoomColors.hudBorder, width: 2),
              ),
              child: Column(
                children: [
                  _buildStatRow('SCORE', '$score', DoomColors.scoreColor),
                  const SizedBox(height: 12),
                  _buildStatRow('LEVEL', '${level + 1}', DoomColors.textWhite),
                  const SizedBox(height: 12),
                  _buildStatRow('KILLS', '$kills', DoomColors.healthRed),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // Buttons
            _buildButton('PLAY AGAIN', onRestart, DoomColors.menuButton),
            const SizedBox(height: 16),
            _buildButton('MAIN MENU', onMenu, const Color(0xFF333333)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              color: DoomColors.textGray,
              fontSize: 16,
              fontFamily: 'monospace',
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, Color color) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 220,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color.withOpacity(0.8), width: 1),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 3,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ),
    );
  }
}

/// Level complete overlay shown between levels
class LevelCompleteScreen extends StatelessWidget {
  final int level;
  final int kills;
  final int score;
  final VoidCallback onNextLevel;

  const LevelCompleteScreen({
    super.key,
    required this.level,
    required this.kills,
    required this.score,
    required this.onNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'LEVEL COMPLETE!',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: DoomColors.exitColor,
                letterSpacing: 6,
                fontFamily: 'monospace',
                shadows: [
                  Shadow(
                    color: DoomColors.exitColor,
                    blurRadius: 20,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: DoomColors.hudBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: DoomColors.hudBorder, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    'LEVEL ${level + 1} CLEARED',
                    style: const TextStyle(
                      color: DoomColors.textWhite,
                      fontSize: 18,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kills: $kills  •  Score: $score',
                    style: const TextStyle(
                      color: DoomColors.scoreColor,
                      fontSize: 16,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            GestureDetector(
              onTap: onNextLevel,
              child: Container(
                width: 220,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF006600), Color(0xFF00AA00), Color(0xFF006600)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: DoomColors.exitColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: DoomColors.exitColor.withOpacity(0.4),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'NEXT LEVEL',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
