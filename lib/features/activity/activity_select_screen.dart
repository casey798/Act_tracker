import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_pwa/data/constants/activities.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tracker_pwa/core/widgets/app_background.dart';
import 'package:tracker_pwa/features/home/widgets/glass_blob.dart';
import 'package:tracker_pwa/core/constants/app_constants.dart';
import 'package:tracker_pwa/core/widgets/common_app_bar.dart';
import 'package:tracker_pwa/core/widgets/bottom_hint_arrow.dart';

class ActivitySelectScreen extends StatelessWidget {
  final String category;
  final Color startColor;
  final Color endColor;
  final double? mapX;
  final double? mapY;

  const ActivitySelectScreen({
    super.key,
    required this.category,
    required this.startColor,
    required this.endColor,
    this.mapX,
    this.mapY,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> allActivities = _getActivitiesForCategory(category);
    final List<String> activities = allActivities.take(15).toList();

    return Scaffold(
      backgroundColor: Colors.black, // Match MapScreen background
      body: Column(
            children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 12,
                    left: 24,
                    right: 24,
                    bottom: 8,
                  ),
                  child: Hero(
                    tag: category,
                    child: Material(
                      type: MaterialType.transparency,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: startColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: startColor.withOpacity(0.1),
                                width: 1.5,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                                      onPressed: () => context.pop(),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ),
                                ),
                                Text(
                                  category,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.8,
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
               
               Expanded(
                 child: LayoutBuilder(
                   builder: (context, constraints) {
                     // Calculate available height for the grid
                     // Subtract padding and bottom hint space
                     final double availableHeight = constraints.maxHeight;
                     final double bottomPadding = 80.0; // Space for bottom hint
                     final double topPadding = 16.0;
                     final double gridHeight = availableHeight - bottomPadding - topPadding;
                     
                     // 15 items in 3 columns = 5 rows
                     // aspect ratio = width / height
                     final double gridWidth = constraints.maxWidth - 32; // 16 padding on each side
                     final double itemWidth = (gridWidth - (16 * 2)) / 3; // minus crossAxisSpacing * 2
                     final double itemHeight = (gridHeight - (16 * 4)) / 5; // minus mainAxisSpacing * 4
                     
                     final double childAspectRatio = itemWidth / itemHeight;

                     return Stack(
                      children: [
                        // Exploding Grid of GlassBlobs (Bottom Layer)
                        Positioned.fill(
                          child: SafeArea( // Keep SafeArea for content
                            top: false, // AppBar handles top padding
                            bottom: false,
                            child: activities.isEmpty
                                ? const Center(
                                    child: Text('No activities found',
                                        style: TextStyle(color: Colors.white54)))
                                : Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 700),
                                      child: GridView.builder(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 80), // Bottom padding for hint
                                        physics: const NeverScrollableScrollPhysics(), // Non-scrollable
                                        clipBehavior: Clip.none,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 16, 
                                          mainAxisSpacing: 16,
                                          childAspectRatio: childAspectRatio,
                                        ),
                                        itemCount: activities.length,
                                        itemBuilder: (context, index) {
                                          // Reduced random offsets: +/- 6px
                                          final double offsetX = ((index * 13) % 12) - 6.0;
                                          final double offsetY = ((index * 7) % 12) - 6.0;
              
                                          // Organic shape generation based on index
                                          // We create 4 slightly different blob shapes to break uniformity
                                          final double r = 110.0; // Increased radius for more circular shapes
                                          final int shapeType = index % 4;
              
                                          BorderRadius organicBorder;
                                          switch (shapeType) {
                                            case 0: // Top-left / Bottom-right skewed
                                              organicBorder =
                                                  BorderRadius.circular(r).copyWith(
                                                topLeft: Radius.elliptical(r * 1.2, r * 0.8),
                                                bottomRight:
                                                    Radius.elliptical(r * 0.9, r * 1.1),
                                              );
                                              break;
                                            case 1: // Top-right / Bottom-left skewed
                                              organicBorder =
                                                  BorderRadius.circular(r).copyWith(
                                                topRight: Radius.elliptical(r * 1.3, r * 0.8),
                                                bottomLeft:
                                                    Radius.elliptical(r * 0.8, r * 1.2),
                                              );
                                              break;
                                            case 2: // Squarish-circle (super-ellipse-ish)
                                              organicBorder = BorderRadius.all(
                                                  Radius.elliptical(r * 0.9, r * 0.95));
                                              break;
                                            default: // Irregular
                                              organicBorder =
                                                  BorderRadius.circular(r).copyWith(
                                                topLeft: Radius.elliptical(r * 0.8, r * 1.1),
                                                bottomLeft:
                                                    Radius.elliptical(r * 1.1, r * 0.9),
                                                topRight: Radius.elliptical(r * 0.9, r * 0.9),
                                              );
                                          }
              
                                          return Transform.translate(
                                            offset: Offset(offsetX, offsetY),
                                            child: RepaintBoundary(
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0), // Minimized padding to maximize size
                                                child: GlassBlob(
                                                  label: activities[index],
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  colors: [
                                                    Colors.white.withOpacity(0.08),
                                                    Colors.white.withOpacity(0.03),
                                                  ],
                                                  borderRadius: organicBorder,
                                                  heroTag: 'activity_${activities[index]}_$index', // Unique tag for pop/morph
                                                  // Idle rotation
                                                  rotation: (index % 2 == 0 ? 0.05 : -0.05) *
                                                      ((index % 3) + 1) *
                                                      0.3,
                                                  delay: Duration.zero,
                                                  scaleDuration: Duration(
                                                      milliseconds: 4000 +
                                                          (index * 500) % 3000), // Organic variation
                                                  fontSize: 15.0, // Smaller font for grid
                                                  onTap: () {
                                                    // print('Selected: ${activities[index]}');
                                                    // TODO: Navigate to Details
                                                  },
                                                )
                                                    .animate(
                                                      delay: (index * 40).ms, // Staggered
                                                    )
                                                    .scale(
                                                      duration: 400.ms,
                                                      curve: Curves.easeOutBack,
                                                      begin: const Offset(0.0, 0.0),
                                                    )
                                                    .fade(duration: 300.ms),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        // Bottom Prompt
                        const BottomHintArrow(text: 'Select an activity to start'),
                      ],
                     );
                   }
                 ),
               ),
            ],
      ),
    );
  }

  List<String> _getActivitiesForCategory(String category) {
    // Labels passed from HomeScreen are AppCategories values
    switch (category) {
      case AppCategories.focus:
        return Activities.highPersonal;
      case AppCategories.social:
        return Activities.highSocial;
      case AppCategories.rest:
        return Activities.lowPersonal;
      case AppCategories.idle:
        return Activities.lowSocial;
      default:
        // Fallback for full names if changed later
        if (category == Activities.catHighSocial) return Activities.highSocial;
        if (category == Activities.catHighPersonal) return Activities.highPersonal;
        if (category == Activities.catLowSocial) return Activities.lowSocial;
        if (category == Activities.catLowPersonal) return Activities.lowPersonal;
        return [];
    }
  }
}
