import 'package:barber_finder/screens/homePage.dart';
import 'package:barber_finder/screens/profile/userProfile.dart';
import 'package:barber_finder/screens/signUp_login/loginMobile.dart';
import 'package:barber_finder/screens/profile/barberProfile.dart';
import 'package:barber_finder/screens/signUp_login/signUp.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  final List<Widget> tabItems = [const HomePage(), UserProfile(),];

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            color: Colors.amber,
            items: const [
              Icon(Icons.search, size : 30),
              Icon(Icons.edit, size: 30,)
            ],
            onTap: (index) {
              setState(() {
                _page = index;
              });
            },
            animationCurve: Curves.easeInOut,
            backgroundColor: Colors.white,
          ),
          resizeToAvoidBottomInset: true,
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg.png"),
                      fit: BoxFit.cover
                  )
              ),
              child: tabItems[_page]
          )
          ),
        );
  }
}
