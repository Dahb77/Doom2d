import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Virtual joystick and action buttons for touch controls
class TouchControls extends StatefulWidget {
  final Function(double dx, double dy) onMove;
  final Function(bool shooting) onShoot;
  final VoidCallback onSwitchWeapon;

  const TouchControls({
    super.key,
    required this.onMove,
    required this.onShoot,
    required this.onSwitchWeapon,
  });

  @override
  State<TouchControls> createState() => _TouchControlsState();
}

class _TouchControlsState extends State<TouchControls> {
  // Joystick state
  Offset _joystickPos = Offset.zero;
  bool _joystickActive = false;
  int? _joystickPointer;

  // Shoot button state
  bool _isShooting = false;

  static const double joystickRadius = 55;
  static const double knobRadius = 22;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Left side: Joystick
          Positioned(
            left: 20,
            bottom: 85,
            child: _buildJoystick(),
          ),

          // Right side: Action buttons
          Positioned(
            right: 20,
            bottom: 85,
            child: _buildActionButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildJoystick() {
    return Listener(
      onPointerDown: (event) {
        _joystickPointer = event.pointer;
        _joystickActive = true;
        _updateJoystick(event.localPosition);
      },
      onPointerMove: (event) {
        if (event.pointer == _joystickPointer) {
          _updateJoystick(event.localPosition);
        }
      },
      onPointerUp: (event) {
        if (event.pointer == _joystickPointer) {
          _joystickActive = false;
          _joystickPointer = null;
          setState(() {
            _joystickPos = Offset.zero;
          });
          widget.onMove(0, 0);
        }
      },
      onPointerCancel: (event) {
        if (event.pointer == _joystickPointer) {
          _joystickActive = false;
          _joystickPointer = null;
          setState(() {
            _joystickPos = Offset.zero;
          });
          widget.onMove(0, 0);
        }
      },
      child: Container(
        width: joystickRadius * 2 + 10,
        height: joystickRadius * 2 + 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.3),
          border: Border.all(
            color: DoomColors.hudBorder.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Center(
          child: Transform.translate(
            offset: _joystickPos,
            child: Container(
              width: knobRadius * 2,
              height: knobRadius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DoomColors.playerBody.withOpacity(0.6),
                border: Border.all(
                  color: DoomColors.playerBody.withOpacity(0.8),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: DoomColors.playerBody.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateJoystick(Offset localPos) {
    double centerX = joystickRadius + 5;
    double centerY = joystickRadius + 5;

    double dx = localPos.dx - centerX;
    double dy = localPos.dy - centerY;
    double distance = sqrt(dx * dx + dy * dy);

    if (distance > joystickRadius) {
      dx = dx / distance * joystickRadius;
      dy = dy / distance * joystickRadius;
      distance = joystickRadius;
    }

    setState(() {
      _joystickPos = Offset(dx, dy);
    });

    // Normalize to -1..1
    double normalizedX = dx / joystickRadius;
    double normalizedY = dy / joystickRadius;

    // Apply deadzone
    if (distance < 8) {
      normalizedX = 0;
      normalizedY = 0;
    }

    widget.onMove(normalizedX, normalizedY);
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Switch weapon button
        GestureDetector(
          onTap: widget.onSwitchWeapon,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DoomColors.weaponPickup.withOpacity(0.3),
              border: Border.all(
                color: DoomColors.weaponPickup.withOpacity(0.6),
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.swap_horiz,
                color: DoomColors.weaponPickup,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Shoot button
        Listener(
          onPointerDown: (_) {
            setState(() => _isShooting = true);
            widget.onShoot(true);
          },
          onPointerUp: (_) {
            setState(() => _isShooting = false);
            widget.onShoot(false);
          },
          onPointerCancel: (_) {
            setState(() => _isShooting = false);
            widget.onShoot(false);
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isShooting
                  ? DoomColors.healthRed.withOpacity(0.6)
                  : DoomColors.healthRed.withOpacity(0.3),
              border: Border.all(
                color: _isShooting
                    ? DoomColors.healthRed
                    : DoomColors.healthRed.withOpacity(0.6),
                width: 3,
              ),
              boxShadow: _isShooting
                  ? [
                      BoxShadow(
                        color: DoomColors.healthRed.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Icon(
                Icons.gps_fixed,
                color: _isShooting ? Colors.white : DoomColors.healthRed,
                size: 36,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
