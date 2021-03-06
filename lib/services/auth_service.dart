import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static String? snackBar;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<User?> signUpUser(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await userCredential.user!.updateDisplayName(name);
      User? user = userCredential.user;

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        snackBar = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        snackBar = 'The account already exists for that email.';
      }
    } catch (e) {
      snackBar = e.toString();
    }
    return null;
  }

  static Future<User?> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackBar = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        snackBar = 'Wrong password provided for that user.';
      }
    }

    return null;
  }

  static Future<void> signOutUser() async => await auth.signOut();

  static Future<void> removeUser() async {
    try {
      await auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        snackBar =
            'The user must reauthenticate before this operation can be executed.';
      }
    }
  }
}
