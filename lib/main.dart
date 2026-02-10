import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_pwa/core/theme/app_theme.dart';
import 'package:tracker_pwa/features/auth/auth_provider.dart';
import 'package:tracker_pwa/features/auth/presentation/pages/check_in_screen.dart';

import 'package:tracker_pwa/features/activity/activity_select_screen.dart';
import 'package:tracker_pwa/features/auth/google_login_screen.dart';
import 'package:tracker_pwa/features/map/presentation/pages/map_screen.dart';
import 'package:tracker_pwa/features/home/presentation/pages/category_select_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracker_pwa/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check for anonymous user and sign out if found
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null && currentUser.isAnonymous) {
    await FirebaseAuth.instance.signOut();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache the heavy blurred map image for smoother transitions
    precacheImage(const AssetImage('assets/map/map_blurred.png'), context);
  }

  @override
  Widget build(BuildContext context) {
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
    initialLocation: '/map',
    redirect: (context, state) {
      if (authState.isLoading || userState.isLoading) return null;

      final isLoggedInFirebase = userState.value != null;
      final hasStartedTracking = authState.value != null;
      
      final isLoginRoute = state.uri.path == '/google_login';
      final isCheckInRoute = state.uri.path == '/check_in';

      // 1. If not logged in to Firebase, go to Google Login
      if (!isLoggedInFirebase) {
        return isLoginRoute ? null : '/google_login';
      }

      // 2. If logged in to Firebase but hasn't started tracking, go to Check In
      if (!hasStartedTracking) {
         return isCheckInRoute ? null : '/check_in';
      }

      // 3. If everything is good, and we are trying to access auth pages, go to map
      if (isLoginRoute || isCheckInRoute) {
        return '/map';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/google_login',
        builder: (context, state) => const GoogleLoginScreen(),
      ),
      GoRoute(
        path: '/check_in', // Renamed route path for clarity
        builder: (context, state) => const CheckInScreen(), // This is the "Check In" screen
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: '/category-select',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>? ?? {};
          return CategorySelectScreen(
            mapX: extras['mapX'] as double?,
            mapY: extras['mapY'] as double?,
            mapMatrix: extras['mapMatrix'] as Matrix4?,
          );
        },
      ),
      GoRoute(
        path: '/activity-select',
        pageBuilder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 800),
            reverseTransitionDuration: const Duration(milliseconds: 800),
            child: ActivitySelectScreen(
              category: extras['category'],
              startColor: extras['startColor'],
              endColor: extras['endColor'],
              mapX: extras['mapX'] as double?,
              mapY: extras['mapY'] as double?,
              mapMatrix: extras['mapMatrix'] as Matrix4?,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
    ],
  );
});
