import 'package:barber_finder/services/database.dart';
import 'package:barber_finder/services/storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

List<bool> isSelected = [true,false]; // to initialize with barber profile
TextEditingController nameController = TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController countryController = TextEditingController();
TextEditingController phoneNumberController = TextEditingController();
TextEditingController normalRateController = TextEditingController();
TextEditingController supplementRateController = TextEditingController();
Storage storage = new Storage(FirebaseStorage.instance);
Database database = new Database(FirebaseDatabase.instance);
String profileImageSrc ="https://firebasestorage.googleapis.com/v0/b/barber-finder-33dc0.appspot.com/o/default_images%2Fprofile_default.png?alt=media&token=16655469-bf9a-4f35-9ccb-e4765e3f1a8b";
ScrollController scrollController = ScrollController();
bool showbtn = false;
final formKey = GlobalKey<FormState>();
