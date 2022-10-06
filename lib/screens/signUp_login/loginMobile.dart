import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barber_finder/services/authentication.dart';
import 'package:provider/provider.dart';
import '../../services/authentication.dart';
import 'signUp.dart';
class LoginMobile extends StatefulWidget {
  const LoginMobile({Key? key}) : super(key: key);

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  final formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Image(image: AssetImage("assets/images/logo.png")),
                      SizedBox(height: 20,),
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Welcome back',
                              style: GoogleFonts.inter(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Login to your account',
                              style: GoogleFonts.inter(
                                fontSize: 23,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 35),
                            TextFormField(
                              controller: emailController,
                              validator: (value){
                                if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!) == false){
                                  return "Please enter a valid email";
                                };
                                return null ;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.error,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              validator: (value){
                                if(value!.length <6){
                                  return "Your password must have at least 6 caracters";
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.error,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Row(
                              //...
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width:(MediaQuery.of(context).size.width/2).toDouble(),
                              child: ElevatedButton.icon(
                                label: const Text("LOGIN"),
                                onPressed: () async {
                                  if(formKey.currentState!.validate()){
                                    var result = await context.read<AuthService>().signIn(emailController.text, passwordController.text) ;
                                    if(result != "loggedIn"){
                                      print(result);
                                      if(result == "There is no user record corresponding to this identifier. The user may have been deleted."){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Please check your email address"))
                                        );
                                      }else if(result == "The password is invalid or the user does not have a password."){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Please check your password"))
                                        );
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(result!))
                                        );
                                      }
                                  }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  maximumSize: Size(70, (MediaQuery.of(context).size.height/2).toDouble())
                                ),
                                icon: const Icon(Icons.cut_rounded),
                              ),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              child: Text("CREATE AN ACCOUNT"),
                              onPressed: (){
                                //context.read<AuthService>().createAccount(emailController.text, passwordController.text);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context)=> const SignUp()
                                )
                                );
                              },
                            ),
                          ],
                        ),
                      ),
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


