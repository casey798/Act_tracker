import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_pwa/core/theme/app_theme.dart';
import 'package:tracker_pwa/data/constants/activities.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _Quadrant(
                  label: Activities.catHighSocial,
                  startColor: AppTheme.q1Start,
                  endColor: AppTheme.q1End,
                  onTap: () => _navigateToActivity(context, Activities.catHighSocial, AppTheme.q1Start, AppTheme.q1End),
                ),
                _Quadrant(
                  label: Activities.catHighPersonal,
                  startColor: AppTheme.q2Start,
                  endColor: AppTheme.q2End,
                  onTap: () => _navigateToActivity(context, Activities.catHighPersonal, AppTheme.q2Start, AppTheme.q2End),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _Quadrant(
                  label: Activities.catLowSocial,
                  startColor: AppTheme.q3Start,
                  endColor: AppTheme.q3End,
                  onTap: () => _navigateToActivity(context, Activities.catLowSocial, AppTheme.q3Start, AppTheme.q3End),
                ),
                _Quadrant(
                  label: Activities.catLowPersonal,
                  startColor: AppTheme.q4Start,
                  endColor: AppTheme.q4End,
                  onTap: () => _navigateToActivity(context, Activities.catLowPersonal, AppTheme.q4Start, AppTheme.q4End),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToActivity(BuildContext context, String category, Color startColor, Color endColor) {
    context.push(
      '/activity-select',
      extra: {
        'category': category,
        'startColor': startColor,
        'endColor': endColor,
      },
    );
  }
}

class _Quadrant extends StatelessWidget {
  final String label;
  final Color startColor;
  final Color endColor;
  final VoidCallback onTap;

  const _Quadrant({
    required this.label,
    required this.startColor,
    required this.endColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: 'quadrant-$label',
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [startColor, endColor],
              ),
            ),
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1.05, 1.05),
              duration: 2000.ms,
              curve: Curves.easeInOut,
            ),
          ),
        ),
      ),
    );
  }
}
