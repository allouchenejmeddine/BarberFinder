import 'package:barber_finder/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class AuthService{
  final FirebaseAuth firebaseAuth;
  AuthService(this.firebaseAuth);
  Database database = Database(FirebaseDatabase.instance);
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();
  Future<bool?>? get isEmailVerified => firebaseAuth.currentUser?.reload().then((value) async =>firebaseAuth.currentUser?.emailVerified);


  Future<String?> signIn (String email, String password) async {
    try{
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "loggedIn";
    } on FirebaseAuthException catch(e){
      return e.message;
    }
  }

  Future<String?> createAccount(String email, String password) async {
    try{
      var result = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((value) async {
        await value.user?.sendEmailVerification().whenComplete(() => print("email sent")).catchError((error) => print(error.toString()));
      });
      return "signedUp";
    } on FirebaseAuthException catch(e){
      return(e.message);
    }
  }


  Future<void> signOut() async {
    firebaseAuth.signOut();
  }
}
