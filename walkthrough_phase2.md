# Verification Walkthrough

## Goal
Verify that the Activity Selection screen displays correctly sized (smaller) blobs, has a background glow, and animates smoothly.

## Steps

1.  **Launch the App**:
    - Run `flutter run -d chrome`.

2.  **Navigate to Activity Selection**:
    - Tap "Focus" (Red/Pink).

3.  **Verify Visuals**:
    - [ ] **Grid Width**: Confirm the grid does NOT stretch to the full width of the screen (on desktop). It should be centered and constrained (max 800px).
    - [ ] **Blob Size**: Confirm blobs are smaller, similar to Home Screen size, not giant circles.
    - [ ] **Background Glow**: Confirm there is a subtle, colored glow behind the grid (matching the category color).
    - [ ] **Spacing**: Confirm there is comfortable space between blobs (20px).

4.  **Verify Performance**:
    - [ ] **Animation**: Confirm the "explode" animation is smoother and less laggy than before.

5.  **Test Other Categories**:
    - Tap "Social" -> Check Orange glow/blobs.
    - Tap "Rest" -> Check Green glow/blobs.
    - Tap "Idle" -> Check Blue glow/blobs.
