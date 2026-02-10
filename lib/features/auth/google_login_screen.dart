import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_pwa/core/theme/app_theme.dart';
import 'package:tracker_pwa/features/auth/auth_provider.dart';

class GoogleLoginScreen extends ConsumerWidget {
  const GoogleLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                'Sign in to track your campus activities',
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
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref.read(authProvider.notifier).signInWithGoogle();
                    },
                    icon: const Icon(Icons.login), // Replace with Google Logo if available or use generic
                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black, // Standard Google Auth colors
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (!authState.isLoading)
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.read(authProvider.notifier).signInAnonymously();
                  },
                  child: Text(
                    'Developer Skip',
                    style: TextStyle(
                      color: AppTheme.textSecondary.withValues(alpha: 0.5),
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
