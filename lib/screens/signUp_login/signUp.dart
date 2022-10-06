import 'package:barber_finder/main.dart';
import 'package:barber_finder/screens/signUp_login/emailNotVerified.dart';
import 'package:barber_finder/screens/signUp_login/enterInformation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../services/authentication.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("in auth");
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
              padding: const EdgeInsets.all(30),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            Text("Create your account, it's simple !",
                              style: GoogleFonts.inter(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 50),
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
                            const SizedBox(height: 30),
                            ElevatedButton(
                              child: Text("CREATE ACCOUNT"),
                              onPressed: () async {
                                if(formKey.currentState!.validate()){
                                  await context.read<AuthService>().createAccount(emailController.text, passwordController.text).whenComplete((){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Please verify your email by clicking the link we sent to your mail"))
                                    );
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EmailNotVerified()) );
                                  });
                                }
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
      ),
    );
  }
}
