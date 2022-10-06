import 'package:barber_finder/screens/signUp_login/enterInformation.dart';
import 'package:barber_finder/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:barber_finder/screens/navigationBar.dart' as NAV;

class EmailNotVerified extends StatefulWidget {
  const EmailNotVerified({Key? key}) : super(key: key);

  @override
  State<EmailNotVerified> createState() => _EmailNotVerifiedState();
}

class _EmailNotVerifiedState extends State<EmailNotVerified> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    bool? verified = await context.read<AuthService>().isEmailVerified;
    if(state.name=="resumed"){
      if(verified == true){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const EnterInformation()));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Your email is not verified yet"))
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg.png")
                )
            ),
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Your email is not verified",
                      style: GoogleFonts.inter(
                        fontSize: 23,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text("Please click on the link we sent to your email",
                      style: GoogleFonts.inter(
                        fontSize: 21,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          bool? verified = await context.read<AuthService>().isEmailVerified;
                          if(verified == true){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const EnterInformation()));
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Your email is not verified yet"))
                            );
                          }
                        },
                        icon: const Icon(Icons.verified),
                        label: const Text("Check again")
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
