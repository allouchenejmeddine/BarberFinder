import 'package:barber_finder/screens/profile/barberProfile.dart';
import 'package:barber_finder/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../services/authentication.dart';
import '../services/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String userName = "";
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );
  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var firebaseUser= context.watch<User?>();
    importData(firebaseUser);
    return SafeArea(
        child: Scaffold(
          body : Center(
            child: Container(
              height: MediaQuery.of(context).orientation== Orientation.landscape ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).orientation== Orientation.landscape ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg.png")
                )
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).orientation== Orientation.landscape ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(72),
                                        child: Image.network(profileImageSrc,fit: BoxFit.fill,
                                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){

                                            if(loadingProgress==null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                  ),
                                  const SizedBox(width: 20,),
                                  Flexible(
                                    fit: FlexFit.loose,
                                      child: Text("Hello $userName" , overflow: TextOverflow.ellipsis,style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),)
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await context.read<AuthService>().signOut();
                                  },
                                  icon: Icon(Icons.logout, size: 30,))
                            ],
                          ),
                          const Divider(
                            height: 20,
                          ),
                          const SizedBox(height: 20,),
                          Text(
                            'Find a near barber',
                            style: GoogleFonts.inter(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 70,),
                          SizedBox(
                            height: 350,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, _)=> ScaleTransition(scale: _animation,
                              child: Icon(Icons.arrow_forward_ios, size: 30,),),
                              itemCount: 10,
                              itemBuilder: (context, index) => buildCard(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        )
    );
  }
  Widget buildCard()=> SizedBox(
    width: 290,
    height: 300,
    child: Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Color.fromRGBO(52, 52, 52, 1)
          ),
          borderRadius: BorderRadius.circular(20),

      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Barber Name"),
              SizedBox(
                height: 70,
                  width: 70,
                  child: Image.network("https://www.kindpng.com/picc/m/192-1925162_login-icon-png-transparent-png.png",)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Work 1 "),
                  Text("Work 2 "),
                  Text("Work 3 ")
                ],
              ),
              ElevatedButton.icon(
                label: Text("RESERVER"),
                  onPressed: (){
                    
                  }, 
                  icon: Icon(Icons.add),
              )
            ],
          ),
        ),
      )
    ),
  );
  void importData(User? firebaseUser) async {
    Future<UserModel?> user = context.read<Database>().getProfileData(firebaseUser?.uid.toString()).then((value) async {
      userName=value!.name!;
      profileImageSrc=value.profileImage!;
      if(mounted){
        setState((){
        });
      }
      return value;
    });
  }
}
