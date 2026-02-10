

---

# Project Specification: "Whacha Doin?" (Campus Edition)

**Version:** 1.0 (Refined for Flutter Web PWA)
**Target Platform:** Cross-platform Mobile PWA (iOS/Android) via Flutter Web (CanvasKit).

---

## 1. Executive Summary

**"Whacha Doin?"** is a high-fidelity, periodic activity tracker for students, inspired by the emotional granularity and fluid UI of *How We Feel*.

Unlike standard trackers, it uses **"Energy Quadrants"** and **"Morphing Geometry"** to lower input friction. It is strictly **Web-Hosted (PWA)** but must feel native (no page reloads, 60fps animations).

### Core Tech Stack

* **Frontend:** Flutter (Web Target only).
* **Renderer:** `CanvasKit` (Strict requirement for pixel-perfect morphs).
* **Backend:** Firebase (Auth, Firestore, Functions).
* **State Management:** Riverpod.
* **Routing:** GoRouter (handling browser history/deep links).
* **Animation:** `flutter_animate`, `Rive` (for complex morphs), or Custom `ShaderMasks`. **NO Three.js/WebGL raw contexts.**

---

## 2. Design System & UI "Vibe"

*Reference: `DESIGN_GUIDELINES.md*`

### A. Visual Identity

* **Theme:** Immersive OLED Black (`#000000`) background.
* **Typography:** **Inter** or **Outfit** (Tight tracking, geometric).
* **Interaction Physics:** Spring-based animations (`mass: 1, stiffness: 100`). **No linear eases.**

### B. The 4 Energy Quadrants (Home Screen)

The home screen consists of 4 large, breathing blobs/gradients.

1. **High Energy / Social ("The Hype")**
* **Colors:** Warm Yellow to Solar Orange (`#FFD05C` → `#FF6B35`).
* **Vibe:** Explosive, star-bursts.
* **Examples:** Parties, Sports, Dining Hall.


2. **High Energy / Focus ("The Grind")**
* **Colors:** Electric Red to Intense Pink (`#FF4B4B` → `#FF9E9E`).
* **Vibe:** Solid blocks, structural squares.
* **Examples:** Exams, Coding, Gym.


3. **Low Energy / Restoration ("The Recharge")**
* **Colors:** Mint Green to Teal (`#4ADE80` → `#2DD4BF`).
* **Vibe:** Soft blobs, organic curves.
* **Examples:** Sleep, Meditation, Nap pods.


4. **Low Energy / Passive ("The Idle")**
* **Colors:** Soft Blue to Periwinkle (`#60A5FA` → `#818CF8`).
* **Vibe:** Droplets, pill shapes.
* **Examples:** Commuting, Scrolling, Waiting.



---

## 3. User Experience (UX) Flow

**Constraint:** KISS (Keep It Simple, Stupid). Friction must be near zero.

### Phase 1: Onboarding (Critical for PWA)

1. **Splash Screen:** Custom HTML splash to hide Flutter initialization.
2. **PWA Enforcer:** Detect if running in browser vs. standalone mode.
* *If Browser:* Show strictly styled overlay: "Tap Share -> Add to Home Screen to continue."
* *Why:* Required for iOS Notifications (iOS 16.4+) and full-screen immersion.



### Phase 2: The "Check-In" (Input Flow)

* **Step 1 (The Trigger):** User taps one of the 4 Energy Quadrants.
* **Step 2 (The Morph):**
* The selected quadrant expands (Hero animation) to fill the screen.
* Other quadrants fade out.
* A grid of bubbles (Activities) floats in.


* **Step 3 (The Selection):** User taps "Coding".
* The background morphs into the "Focus" color theme.
* The "Coding" icon (Glyph) crystallizes in the center.


* **Step 4 (The Context):**
* **Where?** A stylized **SVG Map** of the campus overlays the bottom half. User taps anywhere to drop a "Pin" at that location.
* **Satisfaction:** A single slider thumb. Sliding right = Rounder shape (Happy). Sliding left = Spiky shape (Frustrated).


* **Step 5 (Commit):** Swipe down to "Save & Dismiss."

### Phase 3: Analytics & Reflection

* **Personal Tab:**
* "Streak" counter.
* "Energy Flow" chart (Time vs. Energy Level).


* **Dev/Admin Portal (Separate View):**
* Campus Heatmap (Aggregated, Anonymized).
* "Most Popular Activity by Hour."



---

## 4. Technical Architecture & Schema

### A. Firebase Firestore Schema

**1. Collection: `users**` (Private)

```json
{
  "uid": "user_123",
  "fcm_token": "token_xyz", // For notifications
  "preferences": {
    "notification_times": ["09:00", "21:00"]
  }
}

```

**2. Collection: `logs**` (The Core Data)

```json
{
  "log_id": "auto_gen_id",
  "uid": "user_123",
  "quadrant": "HIGH_FOCUS", // Enum
  "activity_label": "Coding", // String
  "satisfaction_index": 0.8, // 0.0 to 1.0
  "x_norm": 0.54, // Normalized X coordinate (0.0 - 1.0)
  "y_norm": 0.32, // Normalized Y coordinate (0.0 - 1.0)
  "timestamp": "2023-10-27T14:00:00Z",
  "duration_minutes": 60 // Default or user adjusted
}

```

**3. Collection: `campus_aggregates**` (For Heatmap/Dev Portal)
*Updated via Cloud Function `onCreate` of a log. No PII.*

```json
  "doc_id": "2023-10-27_50_30", // Date + X_Y bucket
  "date": "2023-10-27",
  "x_bucket": 50, // e.g., rounded int %
  "y_bucket": 30,
  "total_visits": 42,
  "avg_satisfaction": 0.75,
  "top_activity": "Studying"
}

```

### B. The Map Implementation (SVG Overlay)

* **Asset:** `assets/campus_map_optimized.svg`.
* **Tech:** `flutter_svg` package.
* **Logic:**
* The SVG is wrapped in an `InteractiveViewer`.
* App listens for `onTapUp` events to calculate normalized (0-1) `x,y` coordinates relative to the map image.
* **No SVG tagging required.** IDs are not used. Positions are loose.
* *Advantage:* Instant load, no API costs, works with any floorplan image.



---

## 5. Agent Instructions (The "Prompt")

**Copy and paste the following into your Agent interface:**

> **SYSTEM ROLE:**
> You are a Senior Flutter Engineer specializing in Creative Coding and PWA development. You are building "Whacha Doin?", a campus activity tracker.
> **CRITICAL CONSTRAINTS:**
> 1. **No `html` renderer.** Assume `canvaskit` for all animations.
> 2. **No 3D/WebGL.** Use `ShaderMask` and `BackdropFilter` for visual effects.
> 3. **Strict State Management.** Use `flutter_riverpod` with code generation.
> 4. **Styling.** Use `flutter_animate` for sequencing. Background is always `#000000`.
> 
> 
> **PHASE 1 TASKS (UI SCAFFOLDING):**
> **Task 1: The `EnergyGrid` (Home)**
> * Create a widget that renders 4 equal containers (2x2 grid).
> * Apply the specified gradients (Social/Focus/Rest/Idle) to each.
> * Add a "Breathing" animation (scale 0.98 <-> 1.02) to each quadrant independently using `flutter_animate`.
> 
> 
> **Task 2: The `MorphTransition**`
> * Implement a `Hero` widget navigation.
> * When a quadrant is tapped, navigate to `ActivitySelectionScreen`.
> * The background color of the new screen must match the tapped quadrant's gradient.
> * The transition must be a "Zoom/Expand" effect, not a slide.
> 
> 
> **Task 3: The `CampusMapPicker**`
> * Create a widget that loads `assets/campus.svg`.
> * Wrap in `InteractiveViewer` for pan/zoom.
> * Implement "Tap to Pin" logic to place a marker at specific `(x, y)` coordinates.
> * Include visual feedback (Pin drop animation).
> 
> 
> **Task 4: Data Models**
> * Generate `freezed` models for `ActivityLog` and `User`.
> * Ensure JSON serialization is set up for Firestore.
> 
> 
> **Start by generating the file structure and the `pubspec.yaml` dependencies required.**

---

## 6. Known "Gotchas" & Overlooks

1. **Notifications:** Web Push on iOS requires the user to add the app to the Home Screen. **Do not skip the Onboarding instruction screen.**
2. **Back Gesture:** Browser "Back" swipes can break Flutter navigation.
* *Fix:* Use `PopScope` to intercept back buttons and manage the internal navigation stack manually.


3. **Map Formatting:** The SVG map must be cleaned in Illustrator/Inkscape first. Group paths by "Building" and name the IDs clearly before export.