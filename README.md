# Whacha Doin? (Campus Edition)

**Version:** 1.0 (Refined for Flutter Web PWA)
**Target Platform:** Cross-platform Mobile PWA (iOS/Android) via Flutter Web (CanvasKit).

## 1. Executive Summary

**"Whacha Doin?"** is a high-fidelity, periodic activity tracker for students, inspired by the emotional granularity and fluid UI of *How We Feel*.

Unlike standard trackers, it uses **"Energy Quadrants"** and **"Morphing Geometry"** to lower input friction. It is strictly **Web-Hosted (PWA)** but designed to feel native (no page reloads, 60fps animations).

## 2. Core Tech Stack

* **Frontend:** Flutter (Web Target only).
* **Renderer:** `CanvasKit` (Strict requirement for pixel-perfect morphs).
* **Backend:** Firebase (Auth, Firestore, Functions).
* **State Management:** Riverpod.
* **Routing:** GoRouter (handling browser history/deep links).
* **Animation:** `flutter_animate`, `Rive` (for complex morphs), or Custom `ShaderMasks`.

## 3. Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/casey798/Act_tracker.git
   cd Act_tracker
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run -d chrome --web-renderer canvaskit
   ```

## 4. Project Structure

- `lib/`: Contains the main source code.
- `assets/`: Contains images, SVGs, and other static assets.
- `Implementation_plan_phase1.md`: Detailed plan for the initial UI scaffolding.
- `Implementation_plan_phase2.md`: Plan for the "Check-In" input flow.
- `WHACHA_DOIN_MASTER_SPEC.md`: The master specification document for the project.

## 5. Development

**Verification:**
To verify the current implementation, refer to `walkthrough.md` and `walkthrough_phase2.md`.

**Deployment:**
To build for production:
```bash
flutter build web --web-renderer canvaskit --release
```
