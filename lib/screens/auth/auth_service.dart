import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //Register a new user with email and password
  Future<String?> registerWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      await _firestore.collection('users').doc(user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await user.sendEmailVerification();

      return null; // success
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseAuthError(e);
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }


  //Sign in with email and password
  Future<String?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (!_auth.currentUser!.emailVerified) {
        await _auth.signOut();
        return 'Please verify your email before logging in.';
      }

      return null; // success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'invalid-email':
          return 'Invalid email format.';
        default:
          return 'Login error: ${e.message}';
      }
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }


}

String _handleFirebaseAuthError(FirebaseAuthException e) {
  switch (e.code) {
    case 'email-already-in-use':
      return 'This email is already in use.';
    case 'invalid-email':
      return 'The email address is not valid.';
    case 'weak-password':
      return 'The password is too weak.';
    case 'operation-not-allowed':
      return 'Email/password accounts are not enabled.';
    default:
      return 'Authentication error: ${e.message}';
  }
}
