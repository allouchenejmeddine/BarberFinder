import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barber_finder/services/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:barber_finder/variables.dart';
import '../../models/user_model.dart';
import '../../services/database.dart';

class BarberProfile extends StatefulWidget {
   BarberProfile({Key? key}) : super(key: key);
  String? url ;
  @override
  State<BarberProfile> createState() => _BarberProfileState();
}

class _BarberProfileState extends State<BarberProfile> {

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

    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 1000),  //show/hide animation
        opacity: showbtn ? 1.0:0.0,
        child: FloatingActionButton(
          elevation: 30,
          onPressed: () {
            scrollController.animateTo( //go to top of scroll
                108,  //scroll offset to go
                duration: const Duration(milliseconds: 500), //duration of scroll
                curve:Curves.bounceOut //scroll type
            );
          },
          backgroundColor: Colors.redAccent,
          child: const Icon(Icons.arrow_downward),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
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
                    const SizedBox(height: 40,),
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
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Your address',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.location_city,
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
                    TextFormField(
                      controller: normalRateController,
                      validator: (value){
                        if(RegExp(r"^[0-9]*$").hasMatch(value!) == false){
                          return "Please enter a valid rate";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Your normal rate',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.money,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    TextFormField(
                      controller: supplementRateController,
                      validator: (value){
                        if(RegExp(r"^[0-9]*$").hasMatch(value!) == false){
                          return "Please enter a valid supplement rate";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Your supplement rate',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.add,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Text("Do you move to clients ?" , style: GoogleFonts.inter(
                      fontSize: 17,
                      color: Colors.black,
                    ),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              fillColor: MaterialStateProperty.all(Colors.indigo),
                                value: isSelected[0],
                                onChanged: (value){
                                  setState((){
                                    isSelected[0] = value!;
                                    isSelected[1] = !value;
                                  });
                                }
                            ),
                            const Text(
                              "YES",
                              style: TextStyle(
                                  color: Colors.black54
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                                fillColor: MaterialStateProperty.all(Colors.indigo),
                                value: isSelected[1],
                                onChanged: (value){
                                  setState((){
                                    isSelected[0] = !value!;
                                    isSelected[1] = value ;
                                  });
                                }
                            ),
                            const Text(
                              "NO",
                              style: TextStyle(
                                  color: Colors.black54
                              ),
                            ),
                          ],
                        ),

                      ],
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
                    )
                  ],

                )
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
