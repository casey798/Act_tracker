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
                color: Colors.white, // Increased from white54 for better visibility
                fontSize: 14,
                fontWeight: FontWeight.w500, // Added slight weight
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 1),
                    blurRadius: 3.0,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  Shadow(
                    offset: const Offset(0, 2),
                    blurRadius: 6.0,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  Shadow(
                    offset: const Offset(0, 0),
                    blurRadius: 10.0,
                    color: Colors.black,
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
                    color: Colors.black.withOpacity(0.8),
                    size: 24,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white.withOpacity(0.7),
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
