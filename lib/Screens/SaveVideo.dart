import 'package:DemoApp/Screens/TabScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class SaveVideoScreen extends StatefulWidget {
  static String routeName = "SaveVideo";
  @override
  _SaveVideoScreenState createState() => _SaveVideoScreenState();
}

class _SaveVideoScreenState extends State<SaveVideoScreen> {
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;
  final _formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldState>();

  var _topic = '';
  var _title = '';
  var _videoPath = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final routeData = ModalRoute.of(context).settings.arguments as String;
    _videoPlayerController = VideoPlayerController.network(routeData);
    _videoPath = routeData;
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _OnSubmit() async {
    final _isValid = _formKey.currentState.validate();
    print("isValid------------------------$_isValid");
    if (!_isValid) {
      return;
    }
    _formKey.currentState.save();

    try {
      await Firestore.instance
          .collection('video/KNkZltLvbGjRJ9Y0vNcl/videoDetail')
          .add(
        {
          "topic": _topic,
          "title": _title,
          "videoPath": _videoPath,
          "timeStamp": DateTime.now()
        },
      );
      print("on save video");
      Navigator.of(context).pushReplacementNamed(TabBarScareen.routeName,
          arguments: "Your video uploaded successfully!");
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
    } catch (error) {
      print("Error in catch123-------");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 30, right: 30),
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Retake",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Hind',
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Topic",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Hind',
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: TextFormField(
                            key: ValueKey("topic"),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Hind',
                              fontSize: 18,
                            ),
                            onChanged: (value) {
                              print("ValueTopic------" + value);
                              _topic = value.trim();
                            },
                            decoration: InputDecoration(
                              hintText: "Enter Topic",
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter  topic";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Title",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Hind',
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: TextFormField(
                            key: ValueKey("title"),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Hind',
                              fontSize: 18,
                            ),
                            onChanged: (value) {
                              print("ValueTopic------" + value);
                              _title = value.trim();
                            },
                            decoration: InputDecoration(
                              hintText: "Enter Title",
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter title";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 30, right: 30, bottom: 40),
        child: RaisedButton(
          onPressed: _OnSubmit,
          child: Text(
            "Upload",
            style: Theme.of(context).primaryTextTheme.button,
          ),
        ),
      ),
    );
  }
}
