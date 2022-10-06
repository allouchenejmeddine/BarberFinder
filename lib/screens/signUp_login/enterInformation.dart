import 'package:barber_finder/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../navigationBar.dart' as NAV;

import '../../services/database.dart';

class EnterInformation extends StatefulWidget {
  const EnterInformation({Key? key}) : super(key: key);

  @override
  State<EnterInformation> createState() => _EnterInformationState();
}

class _EnterInformationState extends State<EnterInformation> {
  final formKey = GlobalKey<FormState>();
  Database database = new Database(FirebaseDatabase.instance);
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover
            )
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text("One more step",
                        style: GoogleFonts.inter(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 20,),
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
                      SizedBox(height: 20,),
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
                      SizedBox(height: 40,),
                      ElevatedButton.icon(
                          onPressed: () async {
                            if(formKey.currentState!.validate()){
                              UserModel? newUser = await context.read<Database>().createAccount(firebaseUser?.uid, nameController.text, phoneNumberController.text);
                              Provider.of<UserModel>(context, listen: false).completeUserInformation(firebaseUser?.uid, nameController.text, phoneNumberController.text);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const NAV.NavigationBar() ));
                            }
                          },
                          icon: const Icon(Icons.done_all_sharp),
                          label: const Text("Validate my profile")
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
