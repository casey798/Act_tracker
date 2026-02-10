import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_pwa/features/auth/data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Provides the current Firebase User
final userProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

// Controls the "Tracking" session state (e.g. has the user clicked "Check In"?)
final authProvider = AsyncNotifierProvider<AuthNotifier, String?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    // No persistence: always start as null (not tracking)
    return null;
  }

  Future<void> startTracking() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      
      // Use Firebase UID if available, otherwise just use a placeholder
      final id = firebaseUser?.uid ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';
      
      // We no longer persist to SharedPreferences
      return id;
    });
  }
  
  Future<void> logout() async {
    // Just clear the local state
    state = const AsyncValue.data(null);
  }

  Future<void> signInWithGoogle() async {
     final repo = ref.read(authRepositoryProvider);
     await repo.signInWithGoogle();
     // We don't verify state here, the userProvider stream will update
  }

  Future<void> signInAnonymously() async {
    // print("AuthNotifier: signInAnonymously called");
    final repo = ref.read(authRepositoryProvider);
    await repo.signInAnonymously();
    // print("AuthNotifier: signInAnonymously completed");
  }
}
