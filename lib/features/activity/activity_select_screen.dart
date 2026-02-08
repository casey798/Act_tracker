import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_pwa/data/constants/activities.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tracker_pwa/core/widgets/app_background.dart';
import 'package:tracker_pwa/features/home/widgets/glass_blob.dart';
import 'package:tracker_pwa/core/constants/app_constants.dart';

class ActivitySelectScreen extends StatelessWidget {
  final String category;
  final Color startColor;
  final Color endColor;

  const ActivitySelectScreen({
    super.key,
    required this.category,
    required this.startColor,
    required this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> allActivities = _getActivitiesForCategory(category);
    final List<String> activities = allActivities.take(15).toList();
    
    // Calculate blob size for 4x4 grid based on constrained width
    final size = MediaQuery.of(context).size;
    final padding = 24.0;
    final spacing = 30.0; // Increased spacing to allow for organic offsets
    
    // Constrain grid width: 4 columns * ~140px + spacing approx 700px max width
    final maxGridWidth = 700.0;
    

    return AppBackground(
      child: Stack(
        children: [
          // Exploding Grid of GlassBlobs (Bottom Layer)
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: activities.isEmpty
                  ? const Center(
                      child: Text('No activities found',
                          style: TextStyle(color: Colors.white54)))
                  : Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxGridWidth),
                        child: GridView.builder(
                          padding: EdgeInsets.fromLTRB(
                              16, 80, 16, 16), // Top padding for header
                          clipBehavior: Clip.none,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16, // Reduced spacing for larger blobs
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.0,
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
                                  padding: const EdgeInsets.all(8.0), // Reduced size to prevent overlap
                                  child: GlassBlob(
                                    label: activities[index],
                                    width: double.infinity,
                                    height: double.infinity,
                                    colors: [startColor, endColor],
                                    borderRadius: organicBorder,
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

          // Custom Header with Category Badge (Top Layer)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const HeroIcon(HeroIcons.arrowLeft,
                          color: Colors.white),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.pop();
                      },
                    ),
                    const SizedBox(width: 8),
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient:
                            LinearGradient(colors: [startColor, endColor]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
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
