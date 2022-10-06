import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class Storage{
  final FirebaseStorage firebaseStorage;
  Storage(this.firebaseStorage);

  Future<String?> changeProfileImage(XFile image, String? userId) async {
    Reference refDefaultImages = firebaseStorage.ref().child("Users").child(userId!).child("profile image");
    UploadTask uploadTask;
    String? downloadURL ;
    try{
      uploadTask= refDefaultImages.putData(await image.readAsBytes());
      downloadURL = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    } on FirebaseException catch (e){
      print(e.message);
    }
    return downloadURL;
  }



}