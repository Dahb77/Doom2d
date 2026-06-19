import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Main menu screen with DOOM-styled title
class MainMenuScreen extends StatefulWidget {
  final VoidCallback onStartGame;

  const MainMenuScreen({super.key, required this.onStartGame});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D0D1A),
            Color(0xFF1A0A0A),
            Color(0xFF0D0D1A),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFFF0000),
                          Color.fromRGBO(139, 0, 0, _glowAnimation.value + 0.2),
                          const Color(0xFFFF4444),
                        ],
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'DOOM',
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 16,
                        fontFamily: 'monospace',
                        shadows: [
                          Shadow(
                            color: Color(0xFFFF0000),
                            blurRadius: 30,
                          ),
                          Shadow(
                            color: Color(0xFF8B0000),
                            blurRadius: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 4),

            // Subtitle
            const Text(
              '2D',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF666666),
                letterSpacing: 20,
                fontFamily: 'monospace',
              ),
            ),

            const SizedBox(height: 60),

            // Start button
            _buildMenuButton('NEW GAME', widget.onStartGame),

            const SizedBox(height: 100),

            // Credits
            const Text(
              'BUILT WITH FLUTTER',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF444444),
                letterSpacing: 4,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, VoidCallback onPressed) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, _) {
        return GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 250,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF8B0000),
                  Color(0xFFB71C1C),
                  Color(0xFF8B0000),
                ],
              ),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Color.fromRGBO(255, 68, 68, _glowAnimation.value),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(255, 0, 0, _glowAnimation.value * 0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
