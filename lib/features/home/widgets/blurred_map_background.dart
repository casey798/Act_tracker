import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BlurredMapBackground extends StatelessWidget {
  final Matrix4? mapMatrix;

  const BlurredMapBackground({
    super.key,
    this.mapMatrix,
  });

  @override
  Widget build(BuildContext context) {
    if (mapMatrix == null) return const SizedBox.shrink();

    final screenSize = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    final appBarHeight = kToolbarHeight;
    final availableHeight = screenSize.height - topPadding - appBarHeight;

    return ClipRect(
      child: Stack(
        children: [
          // The Map with the same transformation and blur
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: InteractiveViewer(
                transformationController: TransformationController(mapMatrix),
                panEnabled: false,
                scaleEnabled: false,
                constrained: false,
                boundaryMargin: EdgeInsets.zero,
                child: Opacity(
                  opacity: 0.5, // Translucent
                  child: SvgPicture.asset(
                    'assets/map/Reworked_map_1.svg',
                    fit: BoxFit.fitHeight,
                    height: availableHeight,
                  ),
                ),
              ),
            ),
          ),
          // Darken layer to help text/blobs pop
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
