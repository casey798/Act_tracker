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
  final String? heroTag;

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
    this.heroTag,
  });

  @override
  State<GlassBlob> createState() => _GlassBlobState();
}

class _GlassBlobState extends State<GlassBlob> with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _clickController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _clickController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _clickController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _clickController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget blob = RepaintBoundary(
      child: Transform.rotate(
        angle: widget.rotation,
        child: Animate(
          onPlay: (controller) => controller.repeat(reverse: true),
          effects: [
            MoveEffect(
              begin: const Offset(0, -2), 
              end: const Offset(0, 2),
              duration: 4.seconds,
              curve: Curves.easeInOutSine,
              delay: widget.delay + (widget.rotation.abs() * 1000).ms,
            ),
            ScaleEffect(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.02, 1.02), 
              duration: widget.scaleDuration,
              curve: Curves.easeInOutQuad,
              delay: widget.delay + (widget.rotation.abs() * 500).ms,
            ),
          ],
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTap: () async {
                HapticFeedback.lightImpact();
                await _clickController.forward();
                _clickController.reset();
                widget.onTap();
              },
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: AnimatedContainer(
                  duration: 300.ms,
                  curve: Curves.easeOutBack,
                  transform: Matrix4.identity()
                    ..scale(_isHovered ? 1.05 : 1.0),
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius: widget.borderRadius,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.colors.first.withOpacity(_isHovered ? 0.4 : 0.1),
                        blurRadius: _isHovered ? 25 : 15,
                        spreadRadius: _isHovered ? 2 : 0,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: widget.borderRadius,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(-0.2, -0.2),
                            radius: 1.3,
                            colors: [
                              widget.colors.first.withOpacity(0.06),
                              widget.colors.first.withOpacity(0.01),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.04),
                                      Colors.transparent,
                                      Colors.white.withOpacity(0.01),
                                    ],
                                    stops: const [0.0, 0.4, 1.0],
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Transform.rotate(
                                angle: -widget.rotation,
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.label,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: widget.fontSize ?? 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                        height: 1.1,
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
      ),
    );

    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag!,
        child: blob,
      );
    }
    return blob;
  }
}

