import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../game/game_engine.dart';

/// Visual effects: particles, damage flash, muzzle flash
class EffectsRenderer {
  /// Draw all active particles
  static void drawParticles(Canvas canvas, List<ParticleEffect> particles) {
    for (var p in particles) {
      if (!p.isActive) continue;

      double opacity = (1.0 - p.progress).clamp(0.0, 1.0);
      double currentSize = p.size * (1.0 - p.progress * 0.5);

      Color color;
      switch (p.type) {
        case ParticleType.impact:
          color = DoomColors.muzzleFlash.withOpacity(opacity);
          break;
        case ParticleType.death:
          color = Color.lerp(DoomColors.explosion, DoomColors.healthRed, p.progress)!.withOpacity(opacity);
          break;
        case ParticleType.muzzle:
          color = DoomColors.muzzleFlash.withOpacity(opacity);
          break;
      }

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(p.x, p.y), currentSize, paint);

      // Glow for larger particles
      if (currentSize > 3) {
        final glowPaint = Paint()
          ..color = color.withOpacity(opacity * 0.3)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(Offset(p.x, p.y), currentSize * 1.5, glowPaint);
      }
    }
  }

  /// Draw damage flash overlay on the entire screen
  static void drawDamageFlash(Canvas canvas, Size size, double timer) {
    if (timer <= 0) return;
    double opacity = (timer / 0.3).clamp(0.0, 0.5);
    final paint = Paint()
      ..color = DoomColors.damageFlash.withOpacity(opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  /// Draw exit tile indicator
  static void drawExitTile(Canvas canvas, double x, double y, double time, bool allEnemiesDead) {
    if (!allEnemiesDead) {
      // Locked exit - pulsing red
      double pulse = 0.5 + 0.5 * sin(time * 2);
      final paint = Paint()
        ..color = DoomColors.healthRed.withOpacity(0.3 + pulse * 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromCenter(center: Offset(x, y), width: GameConstants.tileSize, height: GameConstants.tileSize),
        paint,
      );

      // Lock icon
      final lockPaint = Paint()
        ..color = DoomColors.healthRed.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(x, y - 4), 6, lockPaint);
      canvas.drawRect(Rect.fromCenter(center: Offset(x, y + 4), width: 14, height: 10), lockPaint);
    } else {
      // Open exit - pulsing green
      double pulse = 0.5 + 0.5 * sin(time * 4);
      final glowPaint = Paint()
        ..color = DoomColors.exitColor.withOpacity(0.2 + pulse * 0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawRect(
        Rect.fromCenter(center: Offset(x, y), width: GameConstants.tileSize + 8, height: GameConstants.tileSize + 8),
        glowPaint,
      );

      final paint = Paint()
        ..color = DoomColors.exitColor.withOpacity(0.5 + pulse * 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromCenter(center: Offset(x, y), width: GameConstants.tileSize, height: GameConstants.tileSize),
        paint,
      );

      // Arrow icon pointing down
      final arrowPaint = Paint()
        ..color = Colors.white.withOpacity(0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(x, y - 10), Offset(x, y + 6), arrowPaint);
      canvas.drawLine(Offset(x - 6, y), Offset(x, y + 6), arrowPaint);
      canvas.drawLine(Offset(x + 6, y), Offset(x, y + 6), arrowPaint);
    }
  }
}
