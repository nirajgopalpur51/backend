import 'dart:async';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
// import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_33/bottomnav/Shops.dart';
import 'package:flutter_application_33/bottomnav/orders.dart';
import 'package:flutter_application_33/map/CustomMarker.dart';
import 'package:flutter_application_33/map/MapScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:login_backend/Screens/appointment_screen.dart';
// import 'package:login_backend/Screens/home_screen.dart';
// import 'package:login_backend/Screens/map_screen.dart';
// import 'package:login_backend/Screens/person_info.dart';
// import 'package:login_backend/Screens/search_screen.dart';

class Navigation extends StatefulWidget {
  @override
  State<Navigation> createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  int index = 0;
  Widget bodyScreen = MapScreen();

  currentScreen(int value) {
    index = value;
    if (index == 0) {
      bodyScreen = MapScreen();
    }
    if (index == 1) {
      bodyScreen = Shops();
    }
    if (index == 2) {
      bodyScreen = Orders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: bodyScreen,
        bottomNavigationBar: DotNavigationBar(
            currentIndex: index,
            dotIndicatorColor: Color(0xff00B48B),
            unselectedItemColor: Colors.black,
            selectedItemColor: Color(0xff00B48B),
            backgroundColor: Colors.white,
            enableFloatingNavBar: false,
            onTap: (index1) {
              setState(() {
                index = index1;
              });
              currentScreen(index);
            },
            items: [
              DotNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
              ),
              DotNavigationBarItem(
                icon: Icon(
                  Icons.shopping_basket,
                ),
              ),
              DotNavigationBarItem(
                icon: Icon(
                  Icons.sports_basketball,
                ),
              ),
            ]));
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
