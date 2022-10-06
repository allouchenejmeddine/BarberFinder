import 'package:barber_finder/models/user_model.dart';

class BarberModel extends UserModel{
  String? address;
  int? normalRate;
  int? supplementRate;
  bool? moveToClient;
  List<String?>? works;

  BarberModel(String? id, String? name, String? phoneNumber, String? profileImage, String? address, int? normalRate, int? supplementRate, bool? moveToClient, List<String?>? works ) : super (id : id, name : name, phoneNumber: phoneNumber, profileImage: profileImage){
    this.normalRate = normalRate;
    this.supplementRate=supplementRate;
    this.moveToClient=moveToClient;
    this.works=works;
  }

  @override
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = Map<String,dynamic>();
    data["id"] = id;
    data['name'] = name;
    data['phoneNumber']= phoneNumber;
    data['profileImage']= profileImage;
    return data;
  }



}