import 'package:barber_finder/screens/barber/becomeBarber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:barber_finder/variables.dart';
import '../../models/user_model.dart';
import '../../services/database.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key}) : super(key: key);
  String? url ;
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  Future<String>? loadImage() async  {
    final firebaseUser = context.watch<User?>();
    UserModel user =  context.read<Database>().getProfileData(firebaseUser?.uid) as UserModel;
    String toReturn = user.profileImage!;
    profileImageSrc=toReturn;
    setState(() {
      print("profileImage=$profileImageSrc");
    });
    return toReturn;
  }

  Future<String>? myFuture;

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState()  {
    scrollController.addListener(() {
      double showoffset = -1;
      if(scrollController.offset > showoffset){
        showbtn = true;
        setState(() {
        });
      }else if(scrollController.offset > 10){
        showbtn = false;
        setState(() {
        });
      }
    });
    myFuture=loadImage();
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => scrollController.notifyListeners());
  }

  @override
  Widget build(BuildContext context)  {
    final firebaseUser = context.watch<User?>();
    //String? url ;
    var updatedProfile = context.watch<UserModel>();
    importData(firebaseUser);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          controller: scrollController,
          child: Center(
            child: Container(
              height: MediaQuery.of(context).orientation== Orientation.landscape ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).orientation== Orientation.landscape ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg.png")
                  )
              ),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: FutureBuilder<String>(
                                  future: myFuture,
                                  builder: (BuildContext context, AsyncSnapshot<String> image){
                                    return SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(72),
                                            child: image.hasData ? Image.network(image.data!,fit: BoxFit.fill,
                                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){
                                                profileImageSrc=image.data!;
                                                if(loadingProgress==null) return child;
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                                  ),
                                                );
                                              },
                                            ): Image.network(profileImageSrc, fit: BoxFit.fill,)
                                        )
                                    );
                                  }
                              ),
                            ),
                            Positioned(
                              bottom: -15, right :-15,
                              child: IconButton(
                                icon : Icon(Icons.edit, color: Colors.redAccent,),
                                onPressed: () async {
                                  final ImagePicker _picker = ImagePicker();
                                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery).then((value) async {
                                    if(value == null){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("No file was selected"))
                                      );
                                    }else {
                                      profileImageSrc = (await storage.changeProfileImage(value, firebaseUser?.uid))!;
                                      await database.setProfileImage(firebaseUser?.uid.toString(), profileImageSrc);
                                      setState(() {
                                      });
                                    }
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 70,),
                        TextFormField(
                          controller: nameController,
                          validator: (value){
                            if(RegExp(r"^[a-zA-Z]").hasMatch(value!) == false){
                              return "Please enter a valid name";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Your name',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        TextFormField(
                          controller: phoneNumberController,
                          validator: (value){
                            if(RegExp(r"^[0-9]*$").hasMatch(value!) == false){
                              return "Please enter a valid phone number";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Your phone number',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(
                              Icons.phone,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        ElevatedButton.icon(
                            onPressed: () async {
                              if(formKey.currentState!.validate()){
                                Provider.of<UserModel>(context, listen: false).updateUserInformation(firebaseUser?.uid, nameController.text, phoneNumberController.text, profileImageSrc);
                                await database.updateProfile(firebaseUser?.uid, updatedProfile).then((value){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Profile updated successfully"))
                                  );
                                }).catchError((e){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString()))
                                  );
                                });
                              }
                            },
                            icon: const Icon(Icons.done_all_sharp),
                            label: const Text("Save changes")
                        ),
                        const SizedBox(height: 50,),
                        TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => BecomeBarber()));
                            },
                            child: const Text("Are you a barber ? Click here")
                        )
                      ],
                    )
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
  void importData(User? firebaseUser) async {
    Future<UserModel?> user = context.read<Database>().getProfileData(firebaseUser?.uid.toString()).then((value) async {
      nameController.text=value!.name!;
      phoneNumberController.text=value.phoneNumber!;
      profileImageSrc = value.profileImage!;
      return value;
    });
  }





}
