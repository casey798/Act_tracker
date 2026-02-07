import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_pwa/core/theme/app_theme.dart';
import 'package:tracker_pwa/features/auth/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to auth state to handle errors or loading if needed
    // The actual redirection happens in the router
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                'WHACHA\nDOIN?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.5,
                      height: 0.9,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Campus Activity Tracker',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
              const Spacer(),
              if (authState.isLoading)
                const CircularProgressIndicator(color: AppTheme.textPrimary)
              else
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(authProvider.notifier).login();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.textPrimary,
                      foregroundColor: AppTheme.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Start Tracking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
