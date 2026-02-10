
import 'package:flutter/material.dart';


class BlurredMapBackground extends StatelessWidget {
  final Matrix4? mapMatrix;
  final double opacity;

  const BlurredMapBackground({
    super.key,
    this.mapMatrix,
    this.opacity = 0.5,
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
          // The Static Blurred Map
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: TransformationController(mapMatrix),
              panEnabled: false,
              scaleEnabled: false,
              constrained: false,
              boundaryMargin: EdgeInsets.zero,
              child: Opacity(
                opacity: opacity,
                child: Image.asset(
                  'assets/map/map_blurred.png',
                  fit: BoxFit.fitHeight,
                  height: availableHeight,
                  width: availableHeight, // Ensure it remains square like the SVG
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if asset is missing (during dev)
                    return Container(
                      height: availableHeight,
                      width: availableHeight,
                      color: Colors.grey.withValues(alpha: 0.1),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
