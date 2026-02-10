import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracker_pwa/features/map/presentation/pages/map_screen.dart';
import 'package:tracker_pwa/features/map/presentation/widgets/location_target_pin.dart';
import 'package:tracker_pwa/features/map/presentation/widgets/segmented_progress_bar.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('MapScreen renders and handles interaction', (WidgetTester tester) async {
    // Defines routes to support context.push
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const MapScreen(),
        ),
        GoRoute(
          path: '/category-select',
          builder: (context, state) => const Scaffold(body: Text('Category Select')),
        ),
      ],
    );

    // Build the MapScreen wrapped in MaterialApp.router
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    // Verify InteractiveViewer is present
    expect(find.byType(InteractiveViewer), findsOneWidget);

    // Initial state: No LocationTargetPin
    expect(find.byType(LocationTargetPin), findsNothing);

    // Perform Long Press on the map (center of screen)
    // We target the center of the screen since the map fills it
    // Start a gesture on the InteractiveViewer to simulate a long press
    final gesture = await tester.startGesture(tester.getCenter(find.byType(InteractiveViewer)));
    
    // Wait for long press timeout to trigger the callback
    await tester.pump(const Duration(milliseconds: 500)); 
    await tester.pump(); // Trigger frame

    // Verify LocationTargetPin appears while pressing
    expect(find.byType(LocationTargetPin), findsOneWidget);
    
    // Verify SegmentedProgressBar appears
    expect(find.byType(SegmentedProgressBar), findsOneWidget);

    // Release the gesture
    await gesture.up();
    await tester.pumpAndSettle(); // Wait for reset animation

    // Verify LocationTargetPin disappears after release (if meter didn't complete)
    expect(find.byType(LocationTargetPin), findsNothing);
  });
}
