import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../game/game_engine.dart';
import '../game/player.dart';

/// HUD overlay showing health, ammo, score, level info
class HudOverlay extends StatelessWidget {
  final GameEngine engine;

  const HudOverlay({super.key, required this.engine});

  @override
  Widget build(BuildContext context) {
    final player = engine.player;

    return Positioned.fill(
      child: IgnorePointer(
        child: SafeArea(
          child: Stack(
            children: [
              // Bottom HUD bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                    color: DoomColors.hudBackground,
                    border: Border(
                      top: BorderSide(color: DoomColors.hudBorder, width: 2),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      children: [
                        // Health
                        _buildHealthSection(player),
                        const Spacer(),
                        // Weapon & Ammo
                        _buildWeaponSection(player),
                        const Spacer(),
                        // Score
                        _buildScoreSection(player),
                        const SizedBox(width: 16),
                        // Level info
                        _buildLevelInfo(),
                      ],
                    ),
                  ),
                ),
              ),

              // Enemies remaining (top left)
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: DoomColors.hudBackground,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: DoomColors.hudBorder, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.dangerous, color: DoomColors.healthRed, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${engine.enemiesRemaining}',
                        style: const TextStyle(
                          color: DoomColors.textWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthSection(Player player) {
    Color healthColor;
    double healthPercent = player.health / player.maxHealth;
    if (healthPercent > 0.6) {
      healthColor = DoomColors.healthGreen;
    } else if (healthPercent > 0.3) {
      healthColor = DoomColors.healthYellow;
    } else {
      healthColor = DoomColors.healthRed;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(Icons.favorite, color: healthColor, size: 18),
            const SizedBox(width: 6),
            Text(
              '${player.health}',
              style: TextStyle(
                color: healthColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 100,
          height: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: healthPercent,
              backgroundColor: Colors.black54,
              valueColor: AlwaysStoppedAnimation(healthColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeaponSection(Player player) {
    String weaponName;
    Color weaponColor;
    int ammo;

    switch (player.currentWeapon) {
      case WeaponType.pistol:
        weaponName = 'PISTOL';
        weaponColor = DoomColors.bulletPlayer;
        ammo = -1; // infinite
        break;
      case WeaponType.shotgun:
        weaponName = 'SHOTGUN';
        weaponColor = DoomColors.bulletPlayer;
        ammo = player.ammo[WeaponType.shotgun] ?? 0;
        break;
      case WeaponType.plasmaRifle:
        weaponName = 'PLASMA';
        weaponColor = DoomColors.plasma;
        ammo = player.ammo[WeaponType.plasmaRifle] ?? 0;
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          weaponName,
          style: TextStyle(
            color: weaponColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_fire_department, color: DoomColors.ammoColor, size: 16),
            const SizedBox(width: 4),
            Text(
              ammo == -1 ? '∞' : '$ammo',
              style: const TextStyle(
                color: DoomColors.ammoColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreSection(Player player) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'SCORE',
          style: TextStyle(
            color: DoomColors.textGray,
            fontSize: 10,
            fontFamily: 'monospace',
          ),
        ),
        Text(
          '${player.score}',
          style: const TextStyle(
            color: DoomColors.scoreColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildLevelInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: DoomColors.hudBorder),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'LEVEL',
            style: TextStyle(
              color: DoomColors.textGray,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            '${engine.currentLevel + 1}',
            style: const TextStyle(
              color: DoomColors.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
