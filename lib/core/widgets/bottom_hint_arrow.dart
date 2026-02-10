import 'package:flutter/material.dart';

class BottomHintArrow extends StatelessWidget {
  final String text;

  const BottomHintArrow({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: IgnorePointer( // Ensure it doesn't block touches on map if distinct from text
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16, // Increased size
                fontWeight: FontWeight.w600, // Semi-bold for better readability
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 2),
                    blurRadius: 4.0,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                  Shadow(
                    offset: const Offset(0, 0),
                    blurRadius: 10.0,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Shadowed Icon using Stack
            Stack(
              children: [
                Positioned(
                  top: 2,
                  left: 0,
                  right: 0,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black.withValues(alpha: 0.8),
                    size: 24,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

