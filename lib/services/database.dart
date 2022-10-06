import 'dart:convert';

import 'package:barber_finder/models/barber_model.dart';
import 'package:barber_finder/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class Database{
  FirebaseDatabase firebaseDatabase;
  Database(this.firebaseDatabase);
  var reference = FirebaseDatabase.instance.ref();


  Future<UserModel?> createAccount(String? uid, String name, String phoneNumber) async {
    try{
      final result = await reference.child("Users").child(uid!).set({
        "id" : uid,
        "name" : name,
        "phoneNumber" : phoneNumber,
        "profileImage" : "https://firebasestorage.googleapis.com/v0/b/barber-finder-33dc0.appspot.com/o/default_images%2Fprofile_default.png?alt=media&token=16655469-bf9a-4f35-9ccb-e4765e3f1a8b",
        "isBarber" : false
      });
      return UserModel(id: uid,name: name,phoneNumber: phoneNumber);
    } on FirebaseException catch(e){
      throw Exception(e.message);
    }
  }

  Future<UserModel?> getProfileData(String? uid) async {
    try{
      final snapshot = await reference.child("Users").child(uid!).get();
      if(snapshot.exists){
        UserModel user = UserModel.fromJson(jsonDecode(jsonEncode(snapshot.value)));
        return user;
      }else{
        return null;
      }
    } on FirebaseException catch (e){
      throw Exception(e.message);
    }
  }

  Future<String>? getProfileImage(String? uid) async {
    try{
      final snapshot = await reference.child("Users").child(uid!).get().then((value){
        if(value.exists){
          UserModel user = UserModel.fromJson(jsonDecode(jsonEncode(value.value)));
          return user.profileImage;
        }else{
          return "null";
        }
      });
      return "dd";
    } on FirebaseException catch (e){
      throw Exception(e.message);
    }
  }

  Future<String>? setProfileImage(String? uid, String url) async {
    try{
      final snapshot = await reference.child("Users").child(uid!).child("profileImage").set(url);
      return "dd";
    } on FirebaseException catch (e){
      throw Exception(e.message);
    }
  }

  Future<void> updateProfile(String? uid, UserModel user) async {
    try{
      final result = await reference.child("Users").child(uid!).update(user.toJson());
    } on FirebaseException catch(e){
      throw Exception(e.message);
    }
  }

  Future<BarberModel?> becomeBarber(String? uid, UserModel user)async {
    try{
      BarberModel barber = new BarberModel(user.id, user.name, user.phoneNumber, user.profileImage, "", 10, 5, false, []);
      await reference.child("Barbers").child(user.id.toString()).set({
        "id" : user.id
      }).catchError((e){
        print(e.toString());
      }).then((value) async {
        print('barber created');
        await reference.child("Users").child(user.id.toString()).remove();
        return value;
      });
      return null ;
    } on FirebaseException catch(e){
      throw Exception(e.message);
    }
  }
}