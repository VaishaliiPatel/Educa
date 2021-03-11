import 'package:DemoApp/Screens/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPassword extends StatefulWidget {
  static String routeName = "ForgotPassword";

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  String _email = '';
  var _isLoading = false;
  Future _OnSubmit() async {
    final _isValid = _formKey.currentState.validate();
    var authResult;
    if (!_isValid) {
      return;
    }
    _formKey.currentState.save();
    try {
      setState(() {
        _isLoading = true;
      });
      authResult = _auth.sendPasswordResetEmail(email: _email).then((value) {
        print("Value user--------");
        Navigator.of(context).pushReplacementNamed(
          LoginScreen.routeName,
          arguments: "A Password reset link has been sent to $_email",
        );
      }).catchError((error) {
        print("Error in platfomException1-------" + error.message);
        var message = "An error occurred, 11Please check your credential";
        if (error.message != null) {
          message = error.message;
        }
        _globalKey.currentState.showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      });
      print("emial:-----------" + _email);
    } catch (error) {
      print("Error in catch-------" + error.message);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 40, right: 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 120, bottom: 20),
                    alignment: Alignment.center,
                    child: Text(
                      "Forgot password?",
                      style: Theme.of(context).primaryTextTheme.caption,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "Please enter your email address to reset password.",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Hind',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      initialValue: _email.length == 0 ? null : _email,
                      key: ValueKey("Email"),
                      style: Theme.of(context).primaryTextTheme.bodyText2,
                      onChanged: (value) {
                        print(value);
                        _email = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Email address",
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return "Please enter valid email address";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  if (!_isLoading)
                    RaisedButton(
                      onPressed: _OnSubmit,
                      child: Text(
                        "Continue",
                        style: Theme.of(context).primaryTextTheme.button,
                      ),
                    ),
                  if (_isLoading) CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
