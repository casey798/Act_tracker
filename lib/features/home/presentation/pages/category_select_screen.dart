import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_pwa/core/widgets/app_background.dart';
import 'package:tracker_pwa/features/home/widgets/glass_blob.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tracker_pwa/core/constants/app_constants.dart';
import 'package:tracker_pwa/core/widgets/common_app_bar.dart';
import 'package:tracker_pwa/core/widgets/bottom_hint_arrow.dart';
import 'package:tracker_pwa/features/home/widgets/blurred_map_background.dart';

class CategorySelectScreen extends StatelessWidget {
  final double? mapX;
  final double? mapY;
  final Matrix4? mapMatrix;

  const CategorySelectScreen({
    super.key,
    this.mapX,
    this.mapY,
    this.mapMatrix,
  });

  @override
  Widget build(BuildContext context) {
    // Screen size for relative positioning
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    
    // Cluster container size
    final clusterWidth = isMobile ? size.width * 0.9 : 400.0;
    // Calculate blob size based on grid
    final blobSize = clusterWidth * 0.44; 



    return Scaffold(
      backgroundColor: Colors.black, // Match MapScreen background
      body: Column(
            children: [
                CommonAppBar(
                  // title removed
                ),
              
              Expanded(
                child: Stack(
                  children: [
                    // Blurred Map Background
                    BlurredMapBackground(mapMatrix: mapMatrix),
                    
                    // Glass Blobs Cluster - "Organic Grid"
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
                                  label: AppCategories.focus,
                                  width: blobSize,
                                  height: blobSize,
                                  rotation: 0.05, // Slight tilt
                                  scaleDuration: const Duration(seconds: 5),
                                  colors: const [AppColors.focusStart, AppColors.focusEnd], // Vibrant Red
                                  borderRadius: BorderRadius.circular(blobSize * 0.5).copyWith(
                                    topLeft: Radius.elliptical(blobSize * 0.55, blobSize * 0.45),
                                    bottomRight: Radius.elliptical(blobSize * 0.45, blobSize * 0.55),
                                    // Overwrite standard corners to be more organic
                                    topRight: Radius.elliptical(blobSize * 0.52, blobSize * 0.48),
                                    bottomLeft: Radius.elliptical(blobSize * 0.48, blobSize * 0.52),
                                  ),
                                  onTap: () => _navigateToActivity(
                                    context,
                                    AppCategories.focus,
                                    AppColors.focusStart,
                                    AppColors.focusEnd,
                                  ),
                                  heroTag: AppCategories.focus,
                                ),
                              ),

                              // TOP RIGHT: SOCIAL
                              Positioned(
                                top: 0,
                                right: 15, // Slight irregularity
                                child: GlassBlob(
                                  label: AppCategories.social,
                                  width: blobSize * 0.95, // Slight size variation
                                  height: blobSize * 0.95,
                                  rotation: -0.05,
                                  delay: const Duration(milliseconds: 200),
                                  scaleDuration: const Duration(milliseconds: 6500),
                                  colors: const [AppColors.socialStart, AppColors.socialEnd], // Gold to OrangeRed
                                  borderRadius: BorderRadius.circular(blobSize * 0.5).copyWith(
                                    topRight: Radius.elliptical(blobSize * 0.45, blobSize * 0.6),
                                    bottomLeft: Radius.elliptical(blobSize * 0.6, blobSize * 0.45),
                                    topLeft: Radius.elliptical(blobSize * 0.55, blobSize * 0.5),
                                    bottomRight: Radius.elliptical(blobSize * 0.5, blobSize * 0.55),
                                  ),
                                  onTap: () => _navigateToActivity(
                                    context,
                                    AppCategories.social,
                                    AppColors.socialStart,
                                    AppColors.socialEnd,
                                  ),
                                  heroTag: AppCategories.social,
                                ),
                              ),

                              // BOTTOM LEFT: REST
                              Positioned(
                                bottom: 20, // Organic offset
                                left: 5,
                                child: GlassBlob(
                                  label: AppCategories.rest,
                                  width: blobSize * 0.98,
                                  height: blobSize * 0.98,
                                  rotation: 0.03,
                                  delay: const Duration(milliseconds: 400),
                                  scaleDuration: const Duration(seconds: 8),
                                  colors: const [AppColors.restStart, AppColors.restEnd], // SpringGreen to DarkTurquoise
                                  borderRadius: BorderRadius.circular(blobSize * 0.5).copyWith(
                                    bottomLeft: Radius.elliptical(blobSize * 0.55, blobSize * 0.45),
                                    topRight: Radius.elliptical(blobSize * 0.45, blobSize * 0.55),
                                    topLeft: Radius.elliptical(blobSize * 0.48, blobSize * 0.52),
                                    bottomRight: Radius.elliptical(blobSize * 0.52, blobSize * 0.48),
                                  ),
                                  onTap: () => _navigateToActivity(
                                    context,
                                    AppCategories.rest,
                                    AppColors.restStart,
                                    AppColors.restEnd,
                                  ),
                                  heroTag: AppCategories.rest,
                                ),
                              ),

                              // BOTTOM RIGHT: IDLE
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GlassBlob(
                                  label: AppCategories.idle,
                                  width: blobSize * 1.02,
                                  height: blobSize * 1.02,
                                  rotation: -0.08,
                                  delay: const Duration(milliseconds: 600),
                                  scaleDuration: const Duration(milliseconds: 7200),
                                  colors: const [AppColors.idleStart, AppColors.idleEnd], // DodgerBlue to MediumPurple
                                  borderRadius: BorderRadius.circular(blobSize * 0.5).copyWith(
                                    bottomRight: Radius.elliptical(blobSize * 0.55, blobSize * 0.6),
                                    topLeft: Radius.elliptical(blobSize * 0.6, blobSize * 0.55),
                                    topRight: Radius.elliptical(blobSize * 0.5, blobSize * 0.45),
                                    bottomLeft: Radius.elliptical(blobSize * 0.45, blobSize * 0.5),
                                  ),
                                  onTap: () => _navigateToActivity(
                                    context,
                                    AppCategories.idle,
                                    AppColors.idleStart,
                                    AppColors.idleEnd,
                                  ),
                                  heroTag: AppCategories.idle,
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                    
                    // Bottom Prompt
                    BottomHintArrow(text: 'Tap an energy to check in'),
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
        'mapX': mapX,
        'mapY': mapY,
        'mapMatrix': mapMatrix,
      },
    );
  }
}
