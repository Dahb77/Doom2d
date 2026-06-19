import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../game/enemy.dart';

/// Procedural sprite drawing for all game entities
class SpritePainter {
  /// Draw the player character
  static void drawPlayer(Canvas canvas, double x, double y, double angle, bool invulnerable, double time) {
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle);

    // Invulnerability blink effect
    if (invulnerable && (time * 10).floor() % 2 == 0) {
      canvas.restore();
      return;
    }

    // Body (circle)
    final bodyPaint = Paint()
      ..color = DoomColors.playerBody
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, 10, bodyPaint);

    // Body outline
    final outlinePaint = Paint()
      ..color = DoomColors.playerBody.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset.zero, 11, outlinePaint);

    // Visor / face direction indicator
    final visorPaint = Paint()
      ..color = const Color(0xFF1B5E20)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(4, -3, 6, 6), visorPaint);

    // Gun barrel
    final gunPaint = Paint()
      ..color = DoomColors.playerGun
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(8, -2, 10, 4), gunPaint);

    // Gun tip (muzzle)
    final muzzlePaint = Paint()
      ..color = const Color(0xFF424242)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(16, -3, 3, 6), muzzlePaint);

    canvas.restore();
  }

  /// Draw an Imp enemy
  static void drawImp(Canvas canvas, double x, double y, double angle, double healthPercent, EnemyState state) {
    canvas.save();
    canvas.translate(x, y);

    if (state == EnemyState.dying) {
      // Death animation - shrink and fade
      final dyingPaint = Paint()
        ..color = DoomColors.impBody.withOpacity(0.5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, 8, dyingPaint);
      canvas.restore();
      return;
    }

    if (state == EnemyState.hurt) {
      // Flash white when hurt
      final hurtPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, 11, hurtPaint);
      canvas.restore();
      return;
    }

    // Body
    final bodyPaint = Paint()
      ..color = DoomColors.impBody
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, 11, bodyPaint);

    // Dark center
    final centerPaint = Paint()
      ..color = DoomColors.impBody.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, 7, centerPaint);

    // Eyes - positioned based on angle
    canvas.save();
    canvas.rotate(angle);
    final eyePaint = Paint()
      ..color = DoomColors.impEyes
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(5, -3), 2.5, eyePaint);
    canvas.drawCircle(const Offset(5, 3), 2.5, eyePaint);
    canvas.restore();

    // Health bar (if damaged)
    if (healthPercent < 1.0) {
      _drawHealthBar(canvas, healthPercent, 11);
    }

    canvas.restore();
  }

  /// Draw a Demon enemy
  static void drawDemon(Canvas canvas, double x, double y, double angle, double healthPercent, EnemyState state) {
    canvas.save();
    canvas.translate(x, y);

    if (state == EnemyState.dying) {
      final dyingPaint = Paint()
        ..color = DoomColors.demonBody.withOpacity(0.5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, 12, dyingPaint);
      canvas.restore();
      return;
    }

    if (state == EnemyState.hurt) {
      final hurtPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, 16, hurtPaint);
      canvas.restore();
      return;
    }

    // Body (larger circle)
    final bodyPaint = Paint()
      ..color = DoomColors.demonBody
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, 16, bodyPaint);

    // Inner body
    final innerPaint = Paint()
      ..color = const Color(0xFF5D0000)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, 12, innerPaint);

    // Horns
    canvas.save();
    canvas.rotate(angle);
    final hornPaint = Paint()
      ..color = DoomColors.demonHorns
      ..style = PaintingStyle.fill;
    Path hornLeft = Path()
      ..moveTo(8, -12)
      ..lineTo(16, -20)
      ..lineTo(12, -10)
      ..close();
    Path hornRight = Path()
      ..moveTo(8, 12)
      ..lineTo(16, 20)
      ..lineTo(12, 10)
      ..close();
    canvas.drawPath(hornLeft, hornPaint);
    canvas.drawPath(hornRight, hornPaint);

    // Eyes
    final eyePaint = Paint()
      ..color = DoomColors.impEyes
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(8, -5), 3, eyePaint);
    canvas.drawCircle(const Offset(8, 5), 3, eyePaint);

    // Mouth
    final mouthPaint = Paint()
      ..color = const Color(0xFF2D0000)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(10, -4, 6, 8), mouthPaint);
    canvas.restore();

    if (healthPercent < 1.0) {
      _drawHealthBar(canvas, healthPercent, 16);
    }

    canvas.restore();
  }

  /// Draw a Cacodemon enemy
  static void drawCacodemon(Canvas canvas, double x, double y, double angle, double healthPercent, EnemyState state, double time) {
    canvas.save();
    canvas.translate(x, y);

    // Floating bob effect
    double bobY = sin(time * 3) * 3;
    canvas.translate(0, bobY);

    if (state == EnemyState.dying) {
      final dyingPaint = Paint()
        ..color = DoomColors.cacodemonBody.withOpacity(0.5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, 14, dyingPaint);
      canvas.restore();
      return;
    }

    if (state == EnemyState.hurt) {
      final hurtPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, 18, hurtPaint);
      canvas.restore();
      return;
    }

    // Outer glow
    final glowPaint = Paint()
      ..color = DoomColors.cacodemonBody.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset.zero, 22, glowPaint);

    // Body
    final bodyPaint = Paint()
      ..color = DoomColors.cacodemonBody
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, 18, bodyPaint);

    // Face
    canvas.save();
    canvas.rotate(angle);

    // Big central eye
    final eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(8, 0), 7, eyeWhitePaint);

    final eyePupil = Paint()
      ..color = DoomColors.cacodemonEye
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(11, 0), 4, eyePupil);

    final pupilCenter = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(12, 0), 2, pupilCenter);

    // Mouth
    final mouthPaint = Paint()
      ..color = const Color(0xFF2D002D)
      ..style = PaintingStyle.fill;
    Path mouth = Path()
      ..moveTo(10, 8)
      ..lineTo(18, 6)
      ..lineTo(18, 12)
      ..lineTo(10, 14)
      ..close();
    canvas.drawPath(mouth, mouthPaint);
    canvas.restore();

    if (healthPercent < 1.0) {
      _drawHealthBar(canvas, healthPercent, 18);
    }

    canvas.restore();
  }

  /// Draw health bar above entity
  static void _drawHealthBar(Canvas canvas, double percent, double entityRadius) {
    double barWidth = entityRadius * 2;
    double barHeight = 3;
    double barY = -(entityRadius + 8);

    // Background
    final bgPaint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(-barWidth / 2, barY, barWidth, barHeight), bgPaint);

    // Health fill
    Color healthColor;
    if (percent > 0.6) {
      healthColor = DoomColors.healthGreen;
    } else if (percent > 0.3) {
      healthColor = DoomColors.healthYellow;
    } else {
      healthColor = DoomColors.healthRed;
    }

    final fillPaint = Paint()
      ..color = healthColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(-barWidth / 2, barY, barWidth * percent, barHeight), fillPaint);
  }

  /// Draw a projectile
  static void drawProjectile(Canvas canvas, double x, double y, bool isPlayerBullet, WeaponType weaponType) {
    Color color;
    double size;

    if (!isPlayerBullet) {
      color = DoomColors.bulletEnemy;
      size = 5;
    } else {
      switch (weaponType) {
        case WeaponType.pistol:
          color = DoomColors.bulletPlayer;
          size = 4;
          break;
        case WeaponType.shotgun:
          color = DoomColors.bulletPlayer;
          size = 3;
          break;
        case WeaponType.plasmaRifle:
          color = DoomColors.plasma;
          size = 6;
          break;
      }
    }

    // Glow effect
    final glowPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(x, y), size + 3, glowPaint);

    // Core
    final corePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), size, corePaint);

    // Bright center
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), size * 0.4, centerPaint);
  }

  /// Draw a pickup item
  static void drawPickup(Canvas canvas, double x, double y, PickupType type, double bobOffset) {
    double drawY = y + sin(bobOffset) * 3;

    Color color;
    String letter;

    switch (type) {
      case PickupType.health:
        color = DoomColors.healthPickup;
        letter = '+';
        break;
      case PickupType.ammo:
        color = DoomColors.ammoPickup;
        letter = 'A';
        break;
      case PickupType.shotgunPickup:
        color = DoomColors.weaponPickup;
        letter = 'S';
        break;
      case PickupType.plasmaRiflePickup:
        color = DoomColors.weaponPickup;
        letter = 'P';
        break;
    }

    // Glow
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(x, drawY), 14, glowPaint);

    // Border
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(x, drawY), 10, borderPaint);

    // Background
    final bgPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, drawY), 10, bgPaint);

    // Letter
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, drawY - textPainter.height / 2));
  }
}
