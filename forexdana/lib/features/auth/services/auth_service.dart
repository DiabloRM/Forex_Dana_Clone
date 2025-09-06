import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

/// Authentication service that encapsulates Google and Facebook sign-in flows
/// and exchanges provider credentials with Firebase Authentication.
///
/// Usage from UI (button onPressed):
///   final user = await AuthService.instance.signInWithGoogle();
///   if (user == null) { /* show error/snackbar */ }
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get firebaseAuth => _auth;

  /// Sign in with Google. Returns a Firebase [User] on success, or null if
  /// the user cancels or the flow fails.
  Future<User?> signInWithGoogle() async {
    try {
      // Web uses different flow; keep only mobile here as the app targets mobile.
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        final userCred = await _auth.signInWithPopup(googleProvider);
        return userCred.user;
      }

      // For now, return null to disable Google Sign-In until API issues are resolved
      debugPrint(
          'Google Sign-In temporarily disabled due to API compatibility issues');
      return null;

      // TODO: Fix Google Sign-In API compatibility
      // The Google Sign-In API has changed and needs to be updated
      // to work with the current version of the package
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException (Google): ${e.code} - ${e.message}');
      return null;
    } catch (e, st) {
      debugPrint('signInWithGoogle error: $e\n$st');
      return null;
    }
  }

  /// Sign in with Facebook. Returns a Firebase [User] on success, or null if
  /// the user cancels or the flow fails.
  Future<User?> signInWithFacebook() async {
    try {
      if (kIsWeb) {
        final facebookProvider = FacebookAuthProvider();
        final userCred = await _auth.signInWithPopup(facebookProvider);
        return userCred.user;
      }

      final LoginResult result = await FacebookAuth.instance.login(
        permissions: const ['public_profile', 'email'],
      );

      switch (result.status) {
        case LoginStatus.success:
          final AccessToken fbToken = result.accessToken!;
          final OAuthCredential credential =
              FacebookAuthProvider.credential(fbToken.tokenString);
          final UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          return userCredential.user;
        case LoginStatus.cancelled:
          return null; // User aborted login
        case LoginStatus.failed:
        case LoginStatus.operationInProgress:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException (Facebook): ${e.code} - ${e.message}');
      return null;
    } catch (e, st) {
      debugPrint('signInWithFacebook error: $e\n$st');
      return null;
    }
  }

  /// Email/password sign-in. Returns [User] or null on failure.
  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      // For development/testing - check dummy credentials first
      if (email.trim() == 'test@forexdana.com' && password == 'test123') {
        // Create a dummy user for testing (this won't actually create a Firebase user)
        // In production, you'd want to create this user in Firebase Console
        debugPrint('Using dummy credentials for testing');
        // For now, we'll still try Firebase auth but handle the case where user doesn't exist
        try {
          final cred = await _auth.signInWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );
          return cred.user;
        } catch (e) {
          // If user doesn't exist in Firebase, create them for testing
          try {
            final cred = await _auth.createUserWithEmailAndPassword(
              email: email.trim(),
              password: password,
            );
            return cred.user;
          } catch (createError) {
            debugPrint('Failed to create test user: $createError');
            return null;
          }
        }
      }

      // Regular Firebase authentication
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Email sign-in error: ${e.code} - ${e.message}');
      return null;
    } catch (e, st) {
      debugPrint('Email sign-in exception: $e\n$st');
      return null;
    }
  }

  /// Sends an OTP to the provided E.164 formatted phone number.
  /// Returns the verificationId on success, or null on failure.
  Future<String?> sendPhoneOtp({
    required String phoneNumber,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    try {
      String? verificationId;
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber.trim(),
        timeout: timeout,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // On some Android devices the code may be auto-retrieved
          try {
            await _auth.signInWithCredential(credential);
          } catch (_) {}
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('verifyPhoneNumber failed: ${e.code} - ${e.message}');
        },
        codeSent: (String verId, int? forceResendToken) {
          verificationId = verId;
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId ??= verId;
        },
      );
      return verificationId;
    } catch (e, st) {
      debugPrint('sendPhoneOtp error: $e\n$st');
      return null;
    }
  }

  /// Verifies the [smsCode] with the earlier [verificationId].
  /// Returns the signed-in [User] or null on failure.
  Future<User?> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCred = await _auth.signInWithCredential(credential);
      return userCred.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('verifyPhoneOtp error: ${e.code} - ${e.message}');
      return null;
    } catch (e, st) {
      debugPrint('verifyPhoneOtp exception: $e\n$st');
      return null;
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // Also sign out from Facebook if signed in
      try {
        await FacebookAuth.instance.logOut();
      } catch (e) {
        debugPrint('Facebook sign out error: $e');
      }
    } catch (e, st) {
      debugPrint('Sign out error: $e\n$st');
      rethrow;
    }
  }

  /// Gets the current user
  User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
