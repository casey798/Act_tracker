Implementation Plan - Phase 1: Foundation & "App Shell"
Goal
Establish the technical foundation for the Campus Activity Tracker PWA. This includes initializing the Flutter Web project, setting up the "Black OLED" aesthetic, and implementing the strict PWA install enforcement flow.

User Review Required
NOTE

PWA Strategy: As requested, we will recommend installation via a banner or prompt but allow web usage for easier testing. Auth: We will use a "Guest/Anonymous" login for now using a generated UUID stored locally.

Proposed Changes
Project Initialization
Command: flutter create . --platforms web --project-name tracker_pwa
Git: Initialize repo and commit after every major step.
Dependencies:
flutter_riverpod: State management.
go_router: Navigation.
shared_preferences: For persisting the random User ID.
uuid: For generating the random User ID.
google_fonts: For Space Grotesk.
flutter_svg: For rendering the map and icons.
Directory Structure
lib/
├── core/
│   ├── theme/          # AppTheme, Colors, Type
│   └── utils/          # PWA detection logic
├── data/               # Repositories (Placeholders for now)
├── features/
│   ├── auth/           # Login / ID Generation
│   ├── onboarding/     # PWA Install Banner
│   └── home/           # Placeholder Home Screen
└── main.dart           # App Entry & Routing
[Core]
[NEW] lib/core/theme/app_theme.dart
Colors: "Black OLED" palette (Reference Phase 1 details).
Typography: SpaceGrotesk.
[Features]
[NEW] lib/features/auth/login_screen.dart
Logic:
Check for existing user_id in SharedPreferences.
If null, show "Get Started" button.
On click: Generate UUID, save to Prefs, navigate to Home.
Display the generated ID somewhere (e.g., bottom corner) for debugging.
[NEW] lib/features/onboarding/pwa_install_banner.dart
Logic: Check kIsWeb and display mode.
UI: A subtle dismissible banner or modal that suggests "Add to Home Screen" for the best experience, but does not block interaction.
[NEW] lib/main.dart
Setup ProviderScope, GoRouter.
Route Guard: If no user ID, redirect to /login.
Verification Plan
Automated Tests
flutter test for basic logic.
Manual Verification
Browser: Run flutter run -d chrome. Should see "Install App" screen.
PWA: Use Chrome DevTools > Application > Manifest to simulate "Add to Home Screen" or manually install.
Navigation: Verify redirection logic.