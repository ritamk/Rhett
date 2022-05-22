import 'package:firebase_auth/firebase_auth.dart';
import 'package:rhett/shared/constants.dart';

class AuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> signIn(String email, String pass) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: pass);
      final String uid = userCredential.user!.uid;
      return uid;
    } on FirebaseAuthException catch (e) {
      print("signIn: ${e.toString()}");
      throw sthWentWrong;
    }
  }

  Future<String?> signUp(String email, String pass) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: pass);
      final String uid = userCredential.user!.uid;
      return uid;
    } on FirebaseAuthException catch (e) {
      print("signUp: ${e.toString()}");
      throw sthWentWrong;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      print("signOut: ${e.toString()}");
      throw sthWentWrong;
    }
  }
}
