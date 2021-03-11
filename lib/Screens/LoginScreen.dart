import 'package:DemoApp/Screens/ForgotPassword.dart';
import 'package:DemoApp/Screens/Regestration.dart';
import 'package:DemoApp/Screens/TabScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "Login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';
  var _isLoading = false;

  // @override
  // void didChangeDependencies() {
  //   var data = ModalRoute.of(context).settings.arguments;
  //   if (data != null) {
  //     print("data---------------" + data);
  //     print("key---------" + _globalKey.currentState.toString());
  //     _globalKey.currentState.showSnackBar(
  //       SnackBar(
  //         content: Text(data),
  //         backgroundColor: Theme.of(context).errorColor,
  //       ),
  //     );
  //     // data = null;
  //   }
  //   super.didChangeDependencies();
  // }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var data = ModalRoute.of(context).settings.arguments as String;
      _globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text(data),
          backgroundColor: Colors.green,
        ),
      );
      super.initState();
    });
  }

  void _OnSubmit() async {
    final _isValid = _formKey.currentState.validate();
    if (!_isValid) {
      return;
    }
    _formKey.currentState.save();
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      authResult = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print("emial:-----------" + _email);
      print("pass:------------" + _password);
      Navigator.of(context).pushReplacementNamed(TabBarScareen.routeName);
    } on PlatformException catch (error) {
      print("Error in platfomException-------" + error.message);
      var message = "An error occurred, Please check your credential";
      if (error.message ==
          "There is no user record corresponding to this identifier. The user may have been deleted.") {
        Navigator.of(context).pushNamed(RegistrationScreen.routeName,
            arguments: {"email": _email, "pass": _password});
      }
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
        child: Container(
          margin: EdgeInsets.only(left: 40, right: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 60, bottom: 30),
                  alignment: Alignment.center,
                  child: Text(
                    "Sign In",
                    style: Theme.of(context).primaryTextTheme.caption,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 6, bottom: 6),
                        child: TextFormField(
                          key: ValueKey("Email"),
                          style: Theme.of(context).primaryTextTheme.bodyText2,
                          onChanged: (value) {
                            print("ValueEmail------" + value);
                            _email = value.trim();
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
                      Container(
                        height: 0.5,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.6,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 6, bottom: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: TextFormField(
                                  key: ValueKey("Password"),
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText2,
                                  onChanged: (value) {
                                    print("ValueEmail------" + value);
                                    _password = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 6) {
                                      return "Please enter valid password";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(ForgotPassword.routeName);
                                },
                                child: Text(
                                  "Forgot?",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
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
    );
  }
}
