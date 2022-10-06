import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? id;
  String? name;
  String? phoneNumber;
  String? profileImage;

  UserModel({
    this.id,
    this.name,
    this.phoneNumber,
    this.profileImage
  });

  UserModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name=json['name'];
    phoneNumber = json['phoneNumber'];
    profileImage = json['profileImage'];
  }

  void completeUserInformation(String? id, String name, String phoneNumber){
    this.id=id;
    this.name=name;
    this.phoneNumber=phoneNumber;
  }

  void updateUserInformation(String? id, String name, String phoneNumber, String profileImage){
    this.id=id;
    this.name=name;
    this.phoneNumber=phoneNumber;
    this.profileImage=profileImage;
  }


  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = Map<String,dynamic>();
    data["id"] = id;
    data['name'] = name;
    data['phoneNumber']= phoneNumber;
    data['profileImage']= profileImage;
    return data;
  }

}