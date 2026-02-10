import 'package:tracker_pwa/core/widgets/common_app_bar.dart';
import 'package:tracker_pwa/core/widgets/bottom_hint_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_pwa/features/auth/auth_provider.dart';
import 'package:tracker_pwa/features/map/presentation/widgets/location_target_pin.dart';
import 'package:tracker_pwa/features/map/presentation/widgets/segmented_progress_bar.dart';
import 'dart:async';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TransformationController _transformationController = TransformationController();
  Offset? _touchPosition;
  Timer? _longPressTimer;

  // Track if we are currently long pressing
  bool _isLongPressing = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onMeterComplete();
      }
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    _transformationController.dispose();
    _longPressTimer?.cancel();
    super.dispose();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() {
      _touchPosition = details.localPosition;
      _isLongPressing = true;
    });
    _controller.forward(from: 0.0);
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _resetMeter();
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    setState(() {
       _touchPosition = details.localPosition;
    });
  }

  void _resetMeter() {
    if (_controller.status != AnimationStatus.completed) {
      _controller.reset();
      setState(() {
        _isLongPressing = false;
        _touchPosition = null;
      });
    }
  }

  void _onMeterComplete() {
    if (_touchPosition != null) {
      final scenePoint = _transformationController.toScene(_touchPosition!);
      
      // Calculate dimensions to normalize coordinates
      // NOTE: Must match the layout logic in build()
      final screenSize = MediaQuery.of(context).size;
      final topPadding = MediaQuery.of(context).padding.top;
      final appBarHeight = kToolbarHeight;
      final availableHeight = screenSize.height - topPadding - appBarHeight;
      
      // Prevent division by zero
      if (availableHeight <= 0) return;

      // Normalize: 0.0 to 1.0 based on the square map size (height = width for the SVG content)
      final normX = scenePoint.dx / availableHeight;
      final normY = scenePoint.dy / availableHeight;

      context.push(
        '/category-select',
        extra: {
          'mapX': normX,
          'mapY': normY,
          'mapMatrix': _transformationController.value.clone(),
        },
      );
      
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
           _controller.reset();
           setState(() {
             _isLongPressing = false;
             _touchPosition = null;
           });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    final appBarHeight = kToolbarHeight;
    final availableHeight = screenSize.height - topPadding - appBarHeight;

    if (!_isInitialized) {
      // Map is square, width = height = availableHeight
      final double mapWidth = availableHeight;
      final double offsetX = (screenSize.width - mapWidth) / 2;
      _transformationController.value = Matrix4.identity()..setTranslationRaw(offsetX, 0, 0);
      _isInitialized = true;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // 1. Black Band at Top (Custom App Bar)
          CommonAppBar(
            onBack: () => ref.read(authProvider.notifier).logout(),
            middleContent: _isLongPressing 
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  // Wrap in AnimatedBuilder to rebuild as controller changes
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      // Map 0.0-1.0 to 0-3 steps
                      final int currentStep = (_controller.value * 4).floor().clamp(0, 3);
                      return SegmentedProgressBar(
                        currentStep: currentStep,
                      );
                    },
                  ),
                )
              : null,
          ),
          
          // 3. Map Area (Expanded to take remaining vertical space)
          Expanded(
            child: ClipRect(
              child: Stack(
                children: [
                   GestureDetector(
                     behavior: HitTestBehavior.opaque,
                     onLongPressStart: _onLongPressStart,
                     onLongPressEnd: _onLongPressEnd,
                     onLongPressMoveUpdate: _onLongPressMoveUpdate,
                     child: InteractiveViewer(
                        transformationController: _transformationController,
                        minScale: 1.0,
                        maxScale: 10.0,
                        constrained: false,
                        // Removed boundary margin to ensure no extra borders
                        boundaryMargin: EdgeInsets.zero,
                        child: SvgPicture.asset(
                          'assets/map/Reworked_map_1.svg',
                          fit: BoxFit.fitHeight, // Ensures it fits vertically
                          height: availableHeight, 
                          placeholderBuilder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                   ),
                    
                    // Precision Target Location Pin
                    if (_touchPosition != null)
                      Positioned(
                        // Centered on the touch position (24x24 widget -> -12 offset)
                        left: _touchPosition!.dx - 12, 
                        top: _touchPosition!.dy - 12,  
                        child: IgnorePointer(
                          child: const LocationTargetPin()
                          .animate()
                          .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), duration: 200.ms, curve: Curves.easeOut)
                          .fadeIn(duration: 200.ms),
                        ),
                      ),
                    
                    // Bottom Hint
                    const BottomHintArrow(text: 'Long press to select location'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
