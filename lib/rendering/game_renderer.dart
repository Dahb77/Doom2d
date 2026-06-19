import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../game/game_engine.dart';
import '../game/game_map.dart';
import '../game/player.dart';
import '../game/enemy.dart';
import '../game/enemy_types.dart';
import '../game/projectile.dart';
import 'sprite_painter.dart';
import 'effects.dart';

/// Main game renderer using CustomPainter
class GameRenderer extends CustomPainter {
  final GameEngine engine;
  final double time;

  GameRenderer({required this.engine, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final player = engine.player;
    final map = engine.currentMap;

    // Calculate camera offset to center player on screen
    double camX = player.x - size.width / 2;
    double camY = player.y - size.height / 2;

    // Clamp camera to map bounds
    camX = camX.clamp(0, (map.pixelWidth - size.width).clamp(0, double.infinity));
    camY = camY.clamp(0, (map.pixelHeight - size.height).clamp(0, double.infinity));

    canvas.save();

    // Draw background
    final bgPaint = Paint()..color = DoomColors.floor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Apply camera transform
    canvas.translate(-camX, -camY);

    // Determine visible tile range
    int startCol = (camX / GameConstants.tileSize).floor() - 1;
    int endCol = ((camX + size.width) / GameConstants.tileSize).floor() + 1;
    int startRow = (camY / GameConstants.tileSize).floor() - 1;
    int endRow = ((camY + size.height) / GameConstants.tileSize).floor() + 1;

    startCol = startCol.clamp(0, map.width - 1);
    endCol = endCol.clamp(0, map.width - 1);
    startRow = startRow.clamp(0, map.height - 1);
    endRow = endRow.clamp(0, map.height - 1);

    // Draw floor tiles
    _drawFloor(canvas, startCol, endCol, startRow, endRow);

    // Draw exit tile
    bool allEnemiesDead = engine.enemiesRemaining == 0;
    EffectsRenderer.drawExitTile(canvas, map.exitX, map.exitY, time, allEnemiesDead);

    // Draw walls
    _drawWalls(canvas, map, startCol, endCol, startRow, endRow);

    // Draw pickups
    for (var pickup in map.pickups) {
      if (!pickup.isActive) continue;
      SpritePainter.drawPickup(canvas, pickup.x, pickup.y, pickup.type, pickup.bobTimer);
    }

    // Draw enemies
    for (var enemy in map.enemies) {
      if (!enemy.isActive) continue;
      if (enemy is Imp) {
        SpritePainter.drawImp(canvas, enemy.x, enemy.y, enemy.angle, enemy.healthPercent, enemy.state);
      } else if (enemy is Demon) {
        SpritePainter.drawDemon(canvas, enemy.x, enemy.y, enemy.angle, enemy.healthPercent, enemy.state);
      } else if (enemy is Cacodemon) {
        SpritePainter.drawCacodemon(canvas, enemy.x, enemy.y, enemy.angle, enemy.healthPercent, enemy.state, time);
      }
    }

    // Draw projectiles
    for (var proj in engine.projectiles) {
      if (!proj.isActive) continue;
      SpritePainter.drawProjectile(canvas, proj.x, proj.y, proj.isPlayerBullet, proj.weaponType);
    }

    // Draw particles
    EffectsRenderer.drawParticles(canvas, engine.particles);

    // Draw player
    SpritePainter.drawPlayer(
      canvas,
      player.x,
      player.y,
      player.angle,
      player.isInvulnerable,
      time,
    );

    canvas.restore();

    // Draw damage flash over the whole screen (not affected by camera)
    EffectsRenderer.drawDamageFlash(canvas, size, player.damageFlashTimer);

    // Draw minimap
    _drawMinimap(canvas, size, map, player);
  }

  void _drawFloor(Canvas canvas, int startCol, int endCol, int startRow, int endRow) {
    final ts = GameConstants.tileSize;
    final floorPaint1 = Paint()..color = DoomColors.floor;
    final floorPaint2 = Paint()..color = DoomColors.floorAlt;

    for (int row = startRow; row <= endRow; row++) {
      for (int col = startCol; col <= endCol; col++) {
        Paint paint = (row + col) % 2 == 0 ? floorPaint1 : floorPaint2;
        canvas.drawRect(Rect.fromLTWH(col * ts, row * ts, ts, ts), paint);
      }
    }
  }

  void _drawWalls(Canvas canvas, GameMap map, int startCol, int endCol, int startRow, int endRow) {
    final ts = GameConstants.tileSize;

    for (int row = startRow; row <= endRow; row++) {
      for (int col = startCol; col <= endCol; col++) {
        TileType tile = map.getTile(col, row);
        if (tile == TileType.wall) {
          _drawWallTile(canvas, col * ts, row * ts, ts, col, row);
        } else if (tile == TileType.door) {
          _drawDoorTile(canvas, col * ts, row * ts, ts, false);
        } else if (tile == TileType.lockedDoor) {
          _drawDoorTile(canvas, col * ts, row * ts, ts, true);
        }
      }
    }
  }

  void _drawWallTile(Canvas canvas, double x, double y, double size, int col, int row) {
    // Main wall color
    final wallPaint = Paint()..color = DoomColors.wallBrown;
    canvas.drawRect(Rect.fromLTWH(x, y, size, size), wallPaint);

    // Wall detail - brick pattern
    final detailPaint = Paint()
      ..color = DoomColors.wallDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Horizontal lines
    canvas.drawLine(Offset(x, y + size / 2), Offset(x + size, y + size / 2), detailPaint);

    // Vertical lines (offset for brick pattern)
    double offset = (row % 2 == 0) ? size / 2 : 0;
    canvas.drawLine(Offset(x + (size / 4) + offset, y), Offset(x + (size / 4) + offset, y + size / 2), detailPaint);
    canvas.drawLine(Offset(x + (3 * size / 4) + offset, y), Offset(x + (3 * size / 4) + offset, y + size / 2), detailPaint);

    // Top highlight
    final highlightPaint = Paint()
      ..color = DoomColors.wallLight.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(Offset(x, y + 1), Offset(x + size, y + 1), highlightPaint);

    // Bottom shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(Offset(x, y + size - 1), Offset(x + size, y + size - 1), shadowPaint);
  }

  void _drawDoorTile(Canvas canvas, double x, double y, double size, bool locked) {
    Color color = locked ? DoomColors.doorLocked : DoomColors.doorColor;

    final doorPaint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(x + 4, y + 2, size - 8, size - 4), doorPaint);

    // Door frame
    final framePaint = Paint()
      ..color = DoomColors.wallLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(x + 4, y + 2, size - 8, size - 4), framePaint);

    // Door handle
    final handlePaint = Paint()
      ..color = Colors.yellow.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x + size * 0.7, y + size / 2), 3, handlePaint);

    if (locked) {
      // Lock indicator
      final lockPaint = Paint()
        ..color = DoomColors.keyPickup
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x + size / 2, y + size / 2), 4, lockPaint);
    }
  }

  void _drawMinimap(Canvas canvas, Size size, GameMap map, Player player) {
    double mmScale = 3.0;
    double mmWidth = map.width * mmScale;
    double mmHeight = map.height * mmScale;
    double mmX = size.width - mmWidth - 10;
    double mmY = 10;

    // Background
    final bgPaint = Paint()..color = Colors.black.withOpacity(0.6);
    canvas.drawRect(Rect.fromLTWH(mmX - 2, mmY - 2, mmWidth + 4, mmHeight + 4), bgPaint);

    // Border
    final borderPaint = Paint()
      ..color = DoomColors.hudBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(Rect.fromLTWH(mmX - 2, mmY - 2, mmWidth + 4, mmHeight + 4), borderPaint);

    // Walls
    final wallPaint = Paint()..color = DoomColors.wallBrown.withOpacity(0.8);
    final doorPaint = Paint()..color = DoomColors.doorColor.withOpacity(0.8);

    for (int row = 0; row < map.height; row++) {
      for (int col = 0; col < map.width; col++) {
        TileType tile = map.getTile(col, row);
        if (tile == TileType.wall) {
          canvas.drawRect(Rect.fromLTWH(mmX + col * mmScale, mmY + row * mmScale, mmScale, mmScale), wallPaint);
        } else if (tile == TileType.door || tile == TileType.lockedDoor) {
          canvas.drawRect(Rect.fromLTWH(mmX + col * mmScale, mmY + row * mmScale, mmScale, mmScale), doorPaint);
        }
      }
    }

    // Exit
    final exitPaint = Paint()..color = DoomColors.exitColor;
    double exitCol = map.exitX / GameConstants.tileSize;
    double exitRow = map.exitY / GameConstants.tileSize;
    canvas.drawCircle(Offset(mmX + exitCol * mmScale, mmY + exitRow * mmScale), 2, exitPaint);

    // Enemies
    final enemyPaint = Paint()..color = DoomColors.healthRed;
    for (var enemy in map.enemies) {
      if (!enemy.isActive) continue;
      double ex = enemy.x / GameConstants.tileSize * mmScale;
      double ey = enemy.y / GameConstants.tileSize * mmScale;
      canvas.drawCircle(Offset(mmX + ex, mmY + ey), 1.5, enemyPaint);
    }

    // Player
    final playerPaint = Paint()..color = DoomColors.playerBody;
    double px = player.x / GameConstants.tileSize * mmScale;
    double py = player.y / GameConstants.tileSize * mmScale;
    canvas.drawCircle(Offset(mmX + px, mmY + py), 2, playerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
