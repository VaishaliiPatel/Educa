import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: new Color(0xff2F71BA),
        ),
        child: Center(
          // heightFactor: 50,
          child: Image.asset(
            "assets/images/Splash.png",
            height: 50,
            width: 170,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
