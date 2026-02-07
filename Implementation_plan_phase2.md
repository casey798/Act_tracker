# Implementation Plan - Phase 2: The Input Flow (Quadrants & Selection)

## Goal
Implement the core "Feel" of the app: the 4-Quadrant Home Screen with breathing animations and the fluid transition to the Activity Selection Grid.

## User Review Required
> [!NOTE]
> **Animations:** We will use `flutter_animate` for the breathing effects.
> **Navigation:** We will use `GoRouter` with custom transitions or default, relying on the "Exploding" grid animation for fluid feel.

## Proposed Changes

### [Data Layer]

#### [NEW] `lib/data/constants/activities.dart`
*   Define the static lists of activities based on [assets/activities/arch_student_activities.md](file:///d:/app1/tracker1/assets/activities/arch_student_activities.md).
*   Structure:
    ```dart
    class ActivityConstants {
      static const List<String> highSocial = [...]; // 16 items
      static const List<String> highPersonal = [...]; // 16 items
      static const List<String> lowSocial = [...]; // 16 items
      static const List<String> lowPersonal = [...]; // 16 items
    }
    ```

### [UI Components]

#### [NEW] `lib/features/home/presentation/widgets/quadrant_container.dart`
*   A reusable widget for a single quadrant.
*   **Props:** `color1`, `color2`, `label`, `onTap`.
*   **Animation:** Uses `Animate` to scale continuously (breathing).

#### [NEW] `lib/features/home/presentation/pages/home_screen.dart`
*   **Layout:** A `Column` with 2 `Expanded` rows (or a `GridView` prevented from scrolling) to create the 2x2 grid.
*   **Logic:** Tapping a quadrant navigates to `/activity/:quadrantId`.

#### [NEW] `lib/features/activity/presentation/pages/activity_select_screen.dart`
*   **Route:** `/activity/:quadrantId` (e.g., `high_social`).
*   **UI:**
    *   Background: The gradient of the selected quadrant.
    *   Body: A `GridView` of the 16 activities.
    *   Item: A simple bubble/chip with the activity text.
*   **Interaction:** Tapping an activity will ideally proceed to Phase 3 (Map), but for this phase, it will just `pop` or show a placeholder "Selected: [Activity]" snackbar.

### [Routing]

#### [MODIFY] `lib/config/routes/app_router.dart` (or [lib/main.dart](file:///d:/app1/tracker1/lib/main.dart) if router is there)
*   Add the new route for `ActivitySelectScreen`.

## Verification Plan

### Automated Tests
*   **Unit Test:** Verify `ActivityConstants` lists have exactly 16 items each.
*   **Widget Test:** Verify `HomeScreen` renders 4 quadrants.

### Manual Verification
1.  **Launch App:** `flutter run -d chrome`.
2.  **Home Screen:** Observe the 4 quadrants "breathing".
3.  **Transition:** Tap the "High Energy / Social" quadrant.
4.  **Expectation:** The new screen should fade in, and the bubbles should "explode" (scale/fade in stagger) into position.
5.  **Activity Grid:** Verify 16 items (Charretting, Presenting, etc.) are visible.
6.  **Back Navigation:** Tap "Back" and ensure it shrinks back to the quadrant.
