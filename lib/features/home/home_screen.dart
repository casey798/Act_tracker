import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_pwa/core/widgets/app_background.dart';
import 'package:tracker_pwa/features/home/widgets/glass_blob.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Screen size for relative positioning
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    
    // Cluster container size
    final clusterWidth = isMobile ? size.width * 0.9 : 400.0;
    // Calculate blob size based on grid
    final blobSize = clusterWidth * 0.44; 

    return AppBackground(
      child: Stack(
        children: [
          // Main Header
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.white, size: 28),
                    const SizedBox(width: 8),
                    const Text(
                      'Whacha Doin?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    // Open drawer or settings
                  },
                ),
              ],
            ),
          ),

          // Glass Blobs Cluster - "Organic Grid"
          // We use a Stack within a Centered SizedBox to position distinct 2x2 blobs
          // but with slight random offsets for the "organic" feel.
          Center(
            child: SizedBox(
                width: clusterWidth,
                height: clusterWidth, // Square aspect for the cluster
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // TOP LEFT: FOCUS
                    Positioned(
                      top: 10,
                      left: 10,
                      child: GlassBlob(
                        label: 'Focus',
                        width: blobSize,
                        height: blobSize,
                        rotation: 0.05, // Slight tilt
                        colors: const [Color(0xFFFF4B4B), Color(0xFFFF9E9E)],
                        borderRadius: BorderRadius.circular(blobSize * 0.45).copyWith(
                          topLeft: Radius.elliptical(blobSize * 0.4, blobSize * 0.5),
                          bottomRight: Radius.elliptical(blobSize * 0.5, blobSize * 0.4),
                        ),
                        onTap: () => _navigateToActivity(
                          context,
                          'Focus',
                          const Color(0xFFFF4B4B),
                          const Color(0xFFFF9E9E),
                        ),
                      ),
                    ),

                    // TOP RIGHT: SOCIAL
                    Positioned(
                      top: 0,
                      right: 15, // Slight irregularity
                      child: GlassBlob(
                        label: 'Social',
                        width: blobSize * 0.95, // Slight size variation
                        height: blobSize * 0.95,
                        rotation: -0.05,
                        delay: const Duration(milliseconds: 200),
                        colors: const [Color(0xFFFFD05C), Color(0xFFFF6B35)],
                        borderRadius: BorderRadius.circular(blobSize * 0.42).copyWith(
                          topRight: Radius.elliptical(blobSize * 0.35, blobSize * 0.55),
                          bottomLeft: Radius.elliptical(blobSize * 0.55, blobSize * 0.35),
                        ),
                        onTap: () => _navigateToActivity(
                          context,
                          'Social',
                          const Color(0xFFFFD05C),
                          const Color(0xFFFF6B35),
                        ),
                      ),
                    ),

                    // BOTTOM LEFT: REST
                    Positioned(
                      bottom: 20, // Organic offset
                      left: 5,
                      child: GlassBlob(
                        label: 'Rest',
                        width: blobSize * 0.98,
                        height: blobSize * 0.98,
                        rotation: 0.03,
                        delay: const Duration(milliseconds: 400),
                        colors: const [Color(0xFF4ADE80), Color(0xFF2DD4BF)],
                        borderRadius: BorderRadius.circular(blobSize * 0.44).copyWith(
                          bottomLeft: Radius.elliptical(blobSize * 0.4, blobSize * 0.48),
                          topRight: Radius.elliptical(blobSize * 0.48, blobSize * 0.4),
                        ),
                        onTap: () => _navigateToActivity(
                          context,
                          'Rest',
                          const Color(0xFF4ADE80),
                          const Color(0xFF2DD4BF),
                        ),
                      ),
                    ),

                    // BOTTOM RIGHT: IDLE
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GlassBlob(
                        label: 'Idle',
                        width: blobSize * 1.02,
                        height: blobSize * 1.02,
                        rotation: -0.08,
                        delay: const Duration(milliseconds: 600),
                        colors: const [Color(0xFF60A5FA), Color(0xFF818CF8)],
                        borderRadius: BorderRadius.circular(blobSize * 0.48).copyWith(
                          bottomRight: Radius.elliptical(blobSize * 0.45, blobSize * 0.55),
                          topLeft: Radius.elliptical(blobSize * 0.55, blobSize * 0.45),
                        ),
                        onTap: () => _navigateToActivity(
                          context,
                          'Idle',
                          const Color(0xFF60A5FA),
                          const Color(0xFF818CF8),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          

          // Bottom Prompt
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'Tap an energy to check in',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white54.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToActivity(
      BuildContext context, String category, Color start, Color end) {
    context.push(
      '/activity-select',
      extra: {
        'category': category,
        'startColor': start,
        'endColor': end,
      },
    );
  }
}
