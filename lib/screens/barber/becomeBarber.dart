import 'package:barber_finder/models/user_model.dart';
import 'package:barber_finder/screens/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/barber_model.dart';
import '../../services/database.dart';

class BecomeBarber extends StatefulWidget {
  const BecomeBarber({Key? key}) : super(key: key);

  @override
  State<BecomeBarber> createState() => _BecomeBarberState();
}

class _BecomeBarberState extends State<BecomeBarber> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    return Scaffold(
      body: SingleChildScrollView(
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
            child: Container(
              child:Column(
                children: [
                  Text("This screen should be a form of application to become barber, ignored for this version"),
                  TextButton(
                    onPressed: (){
                      try{
                        context.read<Database>().becomeBarber(firebaseUser?.uid, context.read<UserModel>()).then((value){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Successfully became a barber"))
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
                        });

                      } catch (e){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString()))
                        );
                      }


                    },
                    child: Text("Ask for approval"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
