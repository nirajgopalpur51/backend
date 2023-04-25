// ignore_for_file: unused_import, depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_33/bottomnav/bottomnavy.dart';
import 'package:flutter_application_33/bottomnav/orders.dart';
// import 'package:flutter_application_33/splashScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_application_33/Login/customer.dart';
import 'package:flutter_application_33/Login/lang.dart';
import 'package:flutter_application_33/Login/optionpage.dart';
import 'package:flutter_application_33/map/MapScreen.dart';
import 'package:flutter_application_33/map/map.dart';
import 'package:flutter_application_33/map/sample/xyz.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Navigation());
  }
}
