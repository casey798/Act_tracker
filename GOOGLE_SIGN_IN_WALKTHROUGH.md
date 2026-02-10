# Google Sign-In Fix Walkthrough

I have updated the project configuration and code to enable Google Sign-In.

## Changes Made

### 1. Android Configuration
- Updated `android/app/build.gradle.kts`:
    - Changed `applicationId` to `com.casey.whacha` to match Firebase.
    - Applied `com.google.gms.google-services` plugin.
- Updated `android/settings.gradle.kts`:
    - Added `com.google.gms.google-services` version `4.4.0` to plugins.

### 2. Code Changes
- Updated `lib/features/auth/data/auth_repository.dart`:
    - Uncommented `GoogleSignIn` import.
    - Uncommented `signInWithGoogle` method implementation.
    - Updated `AuthRepository` constructor to accept `GoogleSignIn` instance.
    - Updated `authRepositoryProvider` to inject `GoogleSignIn`.

### 3. Stability Fixes
- **Downgraded `google_sign_in`**: Pinning to `^6.2.1` to avoid breaking changes in v7.x (removed `accessToken`).
- **Downgraded Kotlin Gradle Plugin**: Pinning to `1.9.23` in `settings.gradle.kts` to resolve build cache instability.

## Verification Steps

1.  **Missing File Check**:
    > [!IMPORTANT]
    > I checked `android/app/` and did not find `google-services.json`.
    > You MUST download `google-services.json` from the Firebase Console and place it in the `android/app/` directory before running the app.

2.  **Run the App**:
    - Run `flutter clean` (optional but recommended).
    - Run `flutter pub get`.
    - Run the app on your Android device or emulator.

3.  **Test Sign-In**:
    - Tap "Sign in with Google".
    - Select your Google account.
    - Verify you are logged in.

## Troubleshooting

- If you see an error like `Configuration 'app' is not found`, ensure you placed `google-services.json` in `android/app/`.
- If you see `PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 10: , null, null)`, it usually means a SHA-1 fingerprint mismatch. Verify the SHA-1 in Firebase Console matches your keystore (debug or release).
