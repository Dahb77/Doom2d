import 'dart:ui';

/// Global constants for the DOOM 2D game
class GameConstants {
  // Tile & Map
  static const double tileSize = 48.0;
  static const int mapWidth = 30;
  static const int mapHeight = 20;

  // Player
  static const double playerSpeed = 160.0;
  static const double playerRadius = 10.0;
  static const int playerMaxHealth = 100;
  static const double playerInvulnerabilityTime = 0.8;

  // Enemies
  static const double enemyDetectionRange = 250.0;
  static const double enemyAttackRange = 40.0;

  // Projectiles
  static const double bulletSpeed = 350.0;
  static const double bulletRadius = 4.0;

  // Game
  static const double gameTickRate = 1.0 / 60.0;
  static const int totalLevels = 3;
}

/// DOOM-inspired color palette
class DoomColors {
  // Background & Walls
  static const Color darkGray = Color(0xFF1A1A2E);
  static const Color wallBrown = Color(0xFF6B3A2A);
  static const Color wallDark = Color(0xFF4A2518);
  static const Color wallLight = Color(0xFF8B5E3C);
  static const Color floor = Color(0xFF2D2D3D);
  static const Color floorAlt = Color(0xFF252535);
  static const Color ceiling = Color(0xFF0F0F1A);

  // Player
  static const Color playerBody = Color(0xFF4CAF50);
  static const Color playerGun = Color(0xFFBDBDBD);

  // Enemies
  static const Color impBody = Color(0xFFD84315);
  static const Color impEyes = Color(0xFFFFEB3B);
  static const Color demonBody = Color(0xFF8B0000);
  static const Color demonHorns = Color(0xFFFF5722);
  static const Color cacodemonBody = Color(0xFF6A1B9A);
  static const Color cacodemonEye = Color(0xFF00FF00);

  // Projectiles
  static const Color bulletPlayer = Color(0xFFFFEB3B);
  static const Color bulletEnemy = Color(0xFFFF5722);
  static const Color plasma = Color(0xFF00E5FF);

  // UI / HUD
  static const Color hudBackground = Color(0xCC1A1A2E);
  static const Color hudBorder = Color(0xFF8B5E3C);
  static const Color healthGreen = Color(0xFF4CAF50);
  static const Color healthYellow = Color(0xFFFFEB3B);
  static const Color healthRed = Color(0xFFF44336);
  static const Color ammoColor = Color(0xFF90CAF9);
  static const Color scoreColor = Color(0xFFFFD54F);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGray = Color(0xFF9E9E9E);

  // Effects
  static const Color muzzleFlash = Color(0xFFFFEB3B);
  static const Color explosion = Color(0xFFFF6F00);
  static const Color damageFlash = Color(0x66FF0000);
  static const Color pickupGlow = Color(0xFF76FF03);

  // Menu
  static const Color menuBg = Color(0xFF0D0D1A);
  static const Color menuTitle = Color(0xFFD32F2F);
  static const Color menuButton = Color(0xFF8B0000);
  static const Color menuButtonHover = Color(0xFFB71C1C);

  // Pickups
  static const Color healthPickup = Color(0xFF4CAF50);
  static const Color ammoPickup = Color(0xFF2196F3);
  static const Color weaponPickup = Color(0xFFFF9800);
  static const Color keyPickup = Color(0xFFFFEB3B);

  // Doors
  static const Color doorColor = Color(0xFF5D4037);
  static const Color doorLocked = Color(0xFFB71C1C);
  static const Color exitColor = Color(0xFF00C853);
}

/// Tile types for the game map
enum TileType {
  empty,
  wall,
  door,
  lockedDoor,
  exitTile,
  playerSpawn,
  enemySpawnImp,
  enemySpawnDemon,
  enemySpawnCacodemon,
  healthPickup,
  ammoPickup,
  weaponPickup,
}

/// Game states
enum GameState {
  menu,
  playing,
  paused,
  levelComplete,
  gameOver,
  victory,
}

/// Enemy states
enum EnemyState {
  idle,
  chasing,
  attacking,
  hurt,
  dying,
  dead,
}

/// Weapon types
enum WeaponType {
  pistol,
  shotgun,
  plasmaRifle,
}

/// Pickup types
enum PickupType {
  health,
  ammo,
  shotgunPickup,
  plasmaRiflePickup,
}
