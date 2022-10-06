import 'package:barber_finder/models/user_model.dart';
import 'package:barber_finder/screens/signUp_login/emailNotVerified.dart';
import 'package:barber_finder/services/authentication.dart';
import 'package:barber_finder/screens/navigationBar.dart' as Nav;
import 'package:barber_finder/screens/signUp_login/loginMobile.dart';
import 'package:barber_finder/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:splash_screen_view/splash_screen_view.dart';
import 'package:provider/provider.dart';





Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().whenComplete(() =>
      runApp(const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_)=> AuthService(FirebaseAuth.instance),
        ),
        Provider<Database>(
          create: (_)=> Database(FirebaseDatabase.instance),
        ),
        Provider(
            create: (_) => UserModel(),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges, initialData: null,),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen()
      ),
    );

  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
             image: AssetImage('assets/images/my_bg.png')
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton.icon(
                  onPressed: (){

                  },
                  icon: const Icon(Icons.phone, color: Colors.white),
                  label: const Text("LOGIN WITH PHONE", style: TextStyle(
                    color: Colors.white
                  ),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)
                  ),
              ),
            )
          ],
        )
      ),
    );
  }

}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: const AuthWrapper(),
      duration: 5000,
      imageSize: MediaQuery.of(context).size.width.toInt(),
      imageSrc: "assets/images/logo.png",
      text: "Your barber, anywhere !",
      backgroundColor: Colors.white,
      textType: TextType.TyperAnimatedText,
      textStyle: const TextStyle(
        fontSize: 40.0,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    bool? emailVerified = firebaseUser?.emailVerified;

    if (firebaseUser != null) {
      print(firebaseUser.email);
      if(emailVerified==true){
        return const Nav.NavigationBar();
      }else{
        return const EmailNotVerified();
      }
    }
    print("= null notified");
    return const LoginMobile();
    }
  }



