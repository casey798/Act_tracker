import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // return AuthRepository(FirebaseAuth.instance, GoogleSignIn());
  return AuthRepository(FirebaseAuth.instance, GoogleSignIn());
});

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(this._firebaseAuth, this._googleSignIn);
  // AuthRepository(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled the sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      // print("Error signing in with Google: $e");
      // Handle error correctly in a real app (log it, rethrow, etc.)
      rethrow; 
    }
  }

  Future<User?> signInAnonymously() async {
    try {
      // print("AuthRepository: Attempting signInAnonymously...");
      final UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      // print("AuthRepository: signInAnonymously success! User: ${userCredential.user?.uid}");
      return userCredential.user;
    } catch (e) {
      // print("AuthRepository: signInAnonymously FAILED: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
