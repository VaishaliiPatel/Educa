import 'dart:io';

import 'package:DemoApp/Screens/LoginScreen.dart';
import 'package:DemoApp/Screens/TabScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationScreen extends StatefulWidget {
  static String routeName = "Registration";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';
  String _name = '';
  File _imageURL;
  var _isLoading = false;
  bool isCheck = false;
  final _picker = ImagePicker();
  void pickedImage() async {
    final pickedImageFIle = await _picker.getImage(
      source: ImageSource.camera,
      maxWidth: 150,
      imageQuality: 50,
    );
    setState(() {
      _imageURL = File(pickedImageFIle.path);
    });
    print("ImagePath ${_imageURL.path}");
  }

  // void _pickImage() async {
  //   final pickedImageFile = await picker.getImage(
  //     source: ImageSource.camera,
  //     maxWidth: 150,
  //     imageQuality: 50,
  //   );
  //   _imagePath = File(pickedImageFile.path);
  //   widget.pickImageFn(File(pickedImageFile.path));
  //   print("---------pickimage-----------------------------");
  //   print(pickedImageFile.path);
  // }

  void _OnSubmit() async {
    if (!isCheck) {
      print("in check box");
      _globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Please select terms and privacy."),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (_imageURL == null) {
      print("in image");
      _globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Please upload photo."),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    final _isValid = _formKey.currentState.validate();
    print("isValid------------------------$_isValid");
    if (!_isValid) {
      return;
    }
    _formKey.currentState.save();

    AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });

      authResult = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      await Firestore.instance
          .collection('users')
          .document(authResult.user.uid)
          .setData(
              {"UserName": _name, "email": _email, "imageURL": _imageURL.path});
      // print("emial:-----------" + _email);
      // print("pass:------------" + _password);
      // print("image:------------" + _imageURL.path);
      Navigator.of(context).pushReplacementNamed(TabBarScareen.routeName);
    } on PlatformException catch (error) {
      print("Error in platfomException123-------" + error.message);
      var message = "An error occurred, Please check your credential";
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
      print("Error in catch123-------");
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    final data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    setState(() {
      _email = data['email'];
      _password = data['pass'];
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          //pending platfom info.
          icon: Platform.isIOS
              ? Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )
              : Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              LoginScreen.routeName,
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 40, right: 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50, bottom: 20),
                    alignment: Alignment.center,
                    child: Text(
                      "Create account",
                      style: Theme.of(context).primaryTextTheme.caption,
                    ),
                  ),
                  Container(
                    height: 120,
                    width: 120,
                    margin: EdgeInsets.only(bottom: 20),
                    child: IconButton(
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: _imageURL == null
                            ? Image.asset(
                                "assets/images/addUser.jpg",
                                height: 150,
                                width: 150,
                              )
                            : Image.file(
                                _imageURL,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                      ),
                      onPressed: pickedImage,
                    ),
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
                      initialValue: _password.length == 0 ? null : _password,
                      key: ValueKey("Password"),
                      style: Theme.of(context).primaryTextTheme.bodyText2,
                      onChanged: (value) {
                        print(value);
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
                  SizedBox(
                    height: 20,
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
                      key: ValueKey("Name"),
                      style: Theme.of(context).primaryTextTheme.bodyText2,
                      onChanged: (value) {
                        print(value);
                        _name = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Name",
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty || value.length < 6) {
                          return "Please enter valid name.";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        // color: Colors.red,
                        height: 20,
                        alignment: Alignment.topCenter,
                        width: 20,
                        margin: EdgeInsets.only(right: 20, bottom: 15),
                        child: Checkbox(
                          onChanged: (value) {
                            setState(() {
                              isCheck = value;
                            });
                          },
                          value: isCheck,
                          activeColor: Theme.of(context).primaryColor,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'By creating account, I agree to ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Terms',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: null,
                              ),
                              TextSpan(
                                text: ' and ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy.',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                ),
                                recognizer: null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                  // FlatButton(
                  //   child: Text("logout"),
                  //   onPressed: () {
                  //     FirebaseAuth auth = FirebaseAuth.instance;
                  //     auth.signOut().then(
                  //       (value) {
                  //         Navigator.pushReplacementNamed(
                  //             context, LoginScreen.routeName);
                  //       },
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
