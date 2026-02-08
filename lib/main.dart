import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_pwa/core/theme/app_theme.dart';
import 'package:tracker_pwa/features/auth/auth_provider.dart';
import 'package:tracker_pwa/features/auth/login_screen.dart';
import 'package:tracker_pwa/features/home/home_screen.dart';
import 'package:tracker_pwa/features/activity/activity_select_screen.dart';
import 'package:tracker_pwa/features/auth/google_login_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:tracker_pwa/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Whacha Doin?',
      theme: AppTheme.theme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final userState = ref.watch(userProvider); // Listen to Firebase User State

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      if (authState.isLoading || userState.isLoading) return null;

      final isLoggedInFirebase = userState.value != null;
      final hasStartedTracking = authState.value != null;
      
      final isLoginRoute = state.uri.path == '/google_login';
      final isStartTrackingRoute = state.uri.path == '/start_tracking';

      // 1. If not logged in to Firebase, go to Google Login
      if (!isLoggedInFirebase) {
        return isLoginRoute ? null : '/google_login';
      }

      // 2. If logged in to Firebase but hasn't started tracking, go to Start Tracking
      if (!hasStartedTracking) {
         return isStartTrackingRoute ? null : '/start_tracking';
      }

      // 3. If everything is good, and we are trying to access auth pages, go to home
      if (isLoginRoute || isStartTrackingRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/google_login',
        builder: (context, state) => const GoogleLoginScreen(),
      ),
      GoRoute(
        path: '/start_tracking', // Renamed route path for clarity
        builder: (context, state) => const LoginScreen(), // This is the "Start Tracking" screen
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/activity-select',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return ActivitySelectScreen(
            category: extras['category'],
            startColor: extras['startColor'],
            endColor: extras['endColor'],
          );
        },
      ),
    ],
  );
});
