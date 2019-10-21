import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
// Class to help clean up calls to the Firebase built-in function
abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user?.uid;
  }
  @override
  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user?.uid;
  }
  @override
   Future<String> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user?.uid;
  }
  @override
    Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

}
