import 'dart:ui';
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black, // OLED Black
      body: Stack(
        children: [
          // Ambient Glows
          Positioned(
            top: -size.width * 0.2,
            left: -size.width * 0.2,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3030e8).withValues(alpha: 0.08), // Very subtle blue
              ),
            ),
          ),
          Positioned(
            bottom: -size.width * 0.2,
            right: -size.width * 0.2,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withValues(alpha: 0.04), // Very subtle purple
              ),
            ),
          ),
          // Blur filter to soften everything
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Content
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}
