import 'package:DemoApp/Screens/ForgotPassword.dart';
import 'package:DemoApp/Screens/HomeScreen.dart';
import 'package:DemoApp/Screens/LoginScreen.dart';
import 'package:DemoApp/Screens/PlayVideoScreen.dart';
import 'package:DemoApp/Screens/Regestration.dart';
import 'package:DemoApp/Screens/SaveVideo.dart';
import 'package:DemoApp/Screens/SplashScreen.dart';
import 'package:DemoApp/Screens/TabScreen.dart';
import 'package:DemoApp/Screens/VideoScreen.dart';
import 'package:DemoApp/Screens/camreaScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: new Color(0xff2F71BA),
        // primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: new Color(0xff2F71BA),
          minWidth: double.infinity,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(16),
        ),
        primaryTextTheme: TextTheme(
            bodyText1: TextStyle(
              fontFamily: 'Hind',
              // color: Colors.white,
              fontSize: 17,
            ),
            caption: TextStyle(
              fontFamily: 'Hind',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: new Color(0xff2F71BA),
            ),
            bodyText2: TextStyle(
              fontFamily: 'Hind',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            button: TextStyle(
              fontFamily: 'Hind',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            headline1: TextStyle(
              fontFamily: 'Hind',
              fontSize: 16,
              color: Colors.grey,
            )),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, authSnapshot) {
          print("AuthState---------------${authSnapshot.connectionState}");
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          print("AuthState-hasData---------------${authSnapshot.hasData}");
          if (authSnapshot.hasData) {
            print("in hiome");
            return TabBarScareen();
          }
          return LoginScreen();
        },
      ),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        RegistrationScreen.routeName: (ctx) => RegistrationScreen(),
        ForgotPassword.routeName: (ctx) => ForgotPassword(),
        CameraScreen.routeName: (ctx) => CameraScreen(),
        VideoScreen.routeName: (ctx) => VideoScreen(),
        SaveVideoScreen.routeName: (ctx) => SaveVideoScreen(),
        TabBarScareen.routeName: (ctx) => TabBarScareen(),
        PlayVideoScreen.routeName: (ctx) => PlayVideoScreen(),
      },
    );
  }
}
