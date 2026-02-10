
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_pwa/core/widgets/app_background.dart';
import 'package:tracker_pwa/features/auth/auth_provider.dart';

import 'package:heroicons/heroicons.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    
    // Cluster container size

    // Calculate blob size based on grid
 

    return AppBackground(
      child: Stack(
        children: [
          // Main Header
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const HeroIcon(HeroIcons.arrowLeft,
                          color: Colors.white),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        ref.read(authProvider.notifier).logout();
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Whacha Doin?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    // Open drawer or settings
                  },
                ),
              ],
            ),
          ),

          // Main Action
          Center(
            child: GestureDetector(
               onTap: () {
                  HapticFeedback.mediumImpact();
                  context.push('/map');
               },
               child: Container(
                 width: 200,
                 height: 200,
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   gradient: LinearGradient(
                     colors: [
                       Colors.white.withValues(alpha: 0.2),
                       Colors.white.withValues(alpha: 0.05),
                     ],
                     begin: Alignment.topLeft,
                     end: Alignment.bottomRight,
                   ),
                   border: Border.all(
                     color: Colors.white.withValues(alpha: 0.3),
                     width: 1,
                   ),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black.withValues(alpha: 0.2),
                       blurRadius: 20,
                       spreadRadius: 5,
                     ),
                   ],
                 ),
                 child: const Center(
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       HeroIcon(
                         HeroIcons.mapPin,
                         size: 48,
                         color: Colors.white,
                       ),
                       SizedBox(height: 16),
                       Text(
                         'Check In',
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 24,
                           fontWeight: FontWeight.bold,
                           letterSpacing: 1.0,
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
            ),
          ),
          
          // Bottom Prompt
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Tap to start',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
