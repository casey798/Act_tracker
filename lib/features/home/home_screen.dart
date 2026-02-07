import 'package:flutter/material.dart';
import 'package:tracker_pwa/core/theme/app_theme.dart';
import 'package:tracker_pwa/features/onboarding/pwa_install_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          Center(
            child: Text(
              'Home Screen\n(Phase 2 Placeholder)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: PwaInstallBanner(),
          ),
        ],
      ),
    );
  }
}
