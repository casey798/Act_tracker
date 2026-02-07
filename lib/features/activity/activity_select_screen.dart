import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_pwa/data/constants/activities.dart';
import 'package:heroicons/heroicons.dart';

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
    final List<String> activities = _getActivitiesForCategory(category);

    return Scaffold(
      body: Hero(
        tag: 'quadrant-$category',
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [startColor, endColor],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const HeroIcon(HeroIcons.arrowLeft, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      return _ActivityCard(
                        label: activities[index],
                        onTap: () {
                          // TODO: Navigate to Details Screen (Phase 3)
                        },
                      ).animate().fade(duration: 400.ms, delay: (50 * index).ms).scale();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getActivitiesForCategory(String category) {
    if (category == Activities.catHighSocial) return Activities.highSocial;
    if (category == Activities.catHighPersonal) return Activities.highPersonal;
    if (category == Activities.catLowSocial) return Activities.lowSocial;
    if (category == Activities.catLowPersonal) return Activities.lowPersonal;
    return [];
  }
}

class _ActivityCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(51), // 0.2 * 255
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withAlpha(77)), // 0.3 * 255
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
