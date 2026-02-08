import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GlassBlob extends StatefulWidget {
  final String label;
  final List<Color> colors;
  final BorderRadius borderRadius;
  final VoidCallback onTap;
  final double width;
  final double height;
  final Duration delay;
  final Duration scaleDuration;
  final double rotation;
  final double? fontSize;

  const GlassBlob({
    super.key,
    required this.label,
    required this.colors,
    required this.borderRadius,
    required this.onTap,
    required this.width,
    required this.height,
    this.delay = Duration.zero,
    this.scaleDuration = const Duration(seconds: 6),
    this.rotation = 0,
    this.fontSize,
  });

  @override
  State<GlassBlob> createState() => _GlassBlobState();
}

class _GlassBlobState extends State<GlassBlob> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Idle animation: Gentle float/wobble
    // Using RepaintBoundary for performance during animation
    return RepaintBoundary(
      child: Transform.rotate(
        angle: widget.rotation,
        child: Animate(
          // Keep idle animation running regardless of hover
          // to prevent stutter/reset on state change
          onPlay: (controller) => controller.repeat(reverse: true),
          effects: [
            MoveEffect(
              begin: const Offset(0, -5), 
              end: const Offset(0, 5),
              duration: 5.seconds,
              curve: Curves.easeInOutSine,
              delay: widget.delay + (widget.rotation.abs() * 1000).ms, // Randomize phase based on rotation seed
            ),
            ScaleEffect(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.05, 1.05), 
              duration: widget.scaleDuration,
              curve: Curves.easeInOutQuad,
              delay: widget.delay + (widget.rotation.abs() * 500).ms,
            ),
          ],
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onTap();
              },
              child: AnimatedContainer(
                duration: 300.ms,
                curve: Curves.easeOutBack,
                transform: Matrix4.identity()
                  ..scale(_isHovered ? 1.05 : 1.0), // Reduced hover scale
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius,
                  // Subtle gradient border
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1,
                  ),
                  boxShadow: [
                    // Outer Halo Glow
                    BoxShadow(
                      color: widget.colors.first.withOpacity(_isHovered ? 0.6 : 0.2), // Brighter halo
                      blurRadius: _isHovered ? 30 : 20,
                      spreadRadius: _isHovered ? 4 : 0,
                      offset: const Offset(0, 0), // Centered halo
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: widget.borderRadius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(-0.2, -0.2),
                          radius: 1.3,
                          colors: [
                            widget.colors.first.withOpacity(0.25),
                            widget.colors.first.withOpacity(0.05),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Inner highlight/shimmer
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.12),
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.02),
                                  ],
                                  stops: const [0.0, 0.4, 1.0],
                                ),
                              ),
                            ),
                          ),
                          // Text Label
                          Center(
                            child: Transform.rotate(
                              angle: -widget.rotation, // Counter-rotate text
                              child: Material(
                                type: MaterialType.transparency,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.label,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: widget.fontSize ?? 24, // Use custom size
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0, // Reduced slightly
                                      height: 1.1, // Tighter fitting lines
                                      shadows: [
                                        Shadow(
                                          color: Colors.black38,
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
