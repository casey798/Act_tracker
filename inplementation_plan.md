# Implementation Plan: Campus Activity Tracker PWA

## Project Goal
Create a PWA for tracking student activities in the architecture department to analyze campus space usage ("Dead Spaces").
**Key Features:** Coordinate-based map tracking, 4-Quadrant Emotion/Energy input, minimal aesthetic (Space Grotesk), Admin Heatmap.

## User Review Required
> [!IMPORTANT]
> **Map Coordinates:** We are using relative (percentage-based) coordinates on the SVG map to ensure pins stay in place across different screen sizes. The map aspect ratio must be locked.

> [!WARNING]
> **PWA Limitations:** "Add to Home Screen" is required for full screen and notifications. We will block the main app usage until this is done (or strongly encourage it).

## Tech Stack
*   **Framework:** Flutter (Web Target)
*   **Language:** Dart
*   **Backend:** Firebase (Firestore, Auth, Hosting)
*   **State Management:** Riverpod
*   **Routing:** GoRouter
*   **Fonts:** Space Grotesk (Local Asset)
*   **Map:** `flutter_svg` + `InteractiveViewer`

---

## Phase 1: Foundation & "App Shell"
**Goal:** strict PWA setup and basic navigation.

### [Foundation]
#### [NEW] `lib/main.dart`
*   Setup `ProviderScope`, `GoRouter`.
*   Initialize Firebase.

#### [NEW] `lib/core/theme/app_theme.dart`
*   Define the "Black OLED" theme.
*   Setup `SpaceGrotesk` text styles.
*   Define the 4 Quadrant Colors as constants.

#### [NEW] `lib/features/onboarding/pwa_install_screen.dart`
*   Detect if running in browser vs standalone.
*   Show distinct instructions for iOS (Share -> Add to Home) and Android.

---

## Phase 2: The Input Flow (Quadrants & Selection)
**Goal:** The "Feel" of the app. Smooth animations and selection.

### [UI Components]
#### [NEW] `lib/features/home/home_screen.dart`
*   The 4-Quadrant layout.
*   Simple gradient containers with `AnimatedScale` for "breathing" effect.

#### [NEW] `lib/features/activity/activity_select_screen.dart`
*   Grid of 16 activities.
*   Hero transition from the selected Quadrant color.

#### [NEW] `lib/data/constants/activities.dart`
*   **Source:** [assets/activities/arch_student_activities.md](file:///d:/Sem%208/DesRes/Antigravity/tracker%201/assets/activities/arch_student_activities.md)
*   Populate the 4 lists (High Social, High Personal, Low Social, Low Personal) with the 16 items each from the markdown file.
*   **Icons:** Use `heroicons` package or simple text labels if specific SVG icons are missing.

---

## Phase 3: Map & Data Entry
**Goal:** Precise spatial tracking.

### [Map System]
#### [NEW] `lib/features/map/interactive_map_widget.dart`
*   Wrap SVG ([assets/map/campus_map_interactive_place.svg](file:///d:/Sem%208/DesRes/Antigravity/tracker%201/assets/map/campus_map_interactive_place.svg)) in `InteractiveViewer` (minScale: 1.0, maxScale: 4.0).
*   `GestureDetector` onTapUp: Calculate `dx/width` and `dy/height` to store relative coordinates.
*   Overlay `Stack`: Render the SVG, then render a "Pin" widget ([assets/map/pin_active.svg](file:///d:/Sem%208/DesRes/Antigravity/tracker%201/assets/map/pin_active.svg)) at the stored relative coordinates.

### [Input Forms]
#### [NEW] `lib/features/activity/details_screen.dart`
*   Satisfaction Slider (Custom UI).
*   Duration Picker.
*   "Submit" Button.

---

## Phase 4: Backend & User Analytics
**Goal:** Data persistence.

### [Data Layer]
#### [NEW] `lib/data/models/activity_log.dart`
*   Fields: `id`, `userId`, `activityType`, `quadrant`, `x_percent`, `y_percent`, `timestamp`, `duration`, `satisfaction`.

#### [NEW] `lib/data/repositories/firestore_repository.dart`
*   Methods: `submitLog`, `getUserLogs`.

---

## Phase 5: Admin Dashboard
**Goal:** Researcher view.

### [Admin]
#### [NEW] `lib/features/admin/heatmap_screen.dart`
*   Fetch all logs (filtered by date).
*   Overlay semi-transparent "heat blobs" at `x,y` coordinates on the map.
*   This screen should be guarded by an Admin Password or specific User ID.

---

## Verification Plan

### Manual Verification
1.  **PWA Install:** Open in Safari (iOS) and Chrome (Android). Verify "Add to Home Screen" prompt appears. Verify app launches standalone.
2.  **Map Pinning:** Tap a specific corner of a room on the map. Rotate/Resize screen. Verify pin stays in that corner (relative positioning).
3.  **Data Flow:** Submit a log. Check Firestore console. Verify data appears.
4.  **Heatmap:** Submit 5 logs in the same spot. Check Admin view. Verify "Hot spot" intensity.

