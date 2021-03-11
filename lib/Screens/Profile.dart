import 'package:DemoApp/Screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text("logout"),
          onPressed: () {
            FirebaseAuth auth = FirebaseAuth.instance;
            auth.signOut().then(
              (value) {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
            );
          },
        ),
      ),
    );
  }
}
