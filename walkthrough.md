Walkthrough - Phase 1: Foundation & App Shell
Phase 1 is complete! We have established the core technical foundation, the "Black OLED" aesthetic, and the basic PWA/Auth flow.

🚀 Features Implemented
1. "Black OLED" Theme
True Black Background: Optimized for OLED screens (#000000).
Typography: Space Grotesk font family integrated via Google Fonts.
Quadrant Colors: Defined the 4 core gradient palettes for the tracker logic.
2. Guest Authentication
Mechanism: Generates a random UUID via uuid package.
Persistence: Stores the ID in SharedPreferences.
Flow:
New User: Sees "Start Tracking" -> Generates ID -> Redirects to Home.
Returning User: Auto-redirects to Home.
3. PWA Install Banner
Detection: Uses universal_html to check if the app is running in a browser tab vs standalone mode.
UI: Shows a non-blocking banner at the bottom of the Home screen if not installed.
Platform Specifics: Tailored instructions for iOS (Share -> Add to Home) vs Android.
4. Navigation & Architecture
Router: GoRouter manages navigation and auth redirection guards.
State: Riverpod manages global application state (Auth, Theme).
🛠️ How to Run
Development (Works Best)
Due to spaces in your file path, the production build command fails. Use the development command:

bash
flutter run -d chrome
Production Build (Known Issue)
Issue: flutter build web fails because the project path (D:\Sem 8\...) contains spaces, which confuses some internal Flutter Web build tools on Windows. Workaround: Move the project to a path without spaces (e.g., C:\Projects\tracker) if a production build is strictly necessary right now.

📸 Verification
 PWA Prompt: Verified in Chrome.
 Guest Login: Verified UUID generation and redirection.
 Routing: Verified Auth Guard protection for /home.
⏭️ Next Steps (Phase 2)
Implement the 4-Quadrant Home Screen UI.
Add the Activity Selection Grid.
Implement "Breathing" animations.