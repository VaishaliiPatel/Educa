import 'dart:io';

import 'package:DemoApp/Screens/SaveVideo.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
// import 'package:flutter_camera/video_timer.dart';

class CameraScreen extends StatefulWidget {
  static String routeName = "Camera";

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final _key = GlobalKey<ScaffoldState>();
  List<CameraDescription> _cameras;
  CameraController _cameraController;
  var _isRecording = false;
  String _videoPath;
  // final _timerKey = GlobalKey<VideoTimerState>();
  // final _timerKey = GlobalKey<VideoTimerState>();

  @override
  void initState() {
    _initCamere();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

//for amera initilazition
  Future<void> _initCamere() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.medium);
    _cameraController.initialize().then(
      (_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      },
    ).catchError((error) {
      print("CatchError1------");
    });
  }

  buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    // print(
    //     "Ratio1---- ${_cameraController.value.aspectRatio / size.aspectRatio}");
    print("ration2------ ${_cameraController.value.aspectRatio}");
    return ClipRect(
      child: Container(
        child: Transform.scale(
          scale: _cameraController.value.aspectRatio / size.aspectRatio,
          child: Center(
            child: AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio,
              child: CameraPreview(_cameraController),
            ),
          ),
        ),
      ),
    );
  }

//Change camera mode.
  Future<void> onCameraSwitch() async {
    final CameraDescription cameraDescription =
        (_cameraController.description == _cameras[0])
            ? _cameras[1]
            : _cameras[0];
    if (_cameraController != null) {
      _cameraController.dispose();
    }
    print("Chnaged Description--------------$cameraDescription");
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.medium);
    _cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (_cameraController.value.hasError) {
        _key.currentState.showSnackBar(
          SnackBar(
            content: Text(
              'Camera error ${_cameraController.value.errorDescription}',
            ),
          ),
        );
        print(
            "In camre error-----------${_cameraController.value.errorDescription}");
      }
    });
    try {
      await _cameraController.initialize().then((value) {
        setState(() {});
      });
      print("In try camera block");
    } on CameraException catch (error) {
      print("Camrear Exception----" + error.description);
    }
    if (mounted) {
      setState(() {});
    }
  }

  //for current timeStamp
  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  //For record video
  Future<String> startVideoRecording() async {
    print("startVideoRecording------");
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    setState(() {
      _isRecording = true;
    });
    // _timerKey.currentState.startTimer();
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = '${dir.path}/media';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.mp4';

    if (_cameraController.value.isRecordingVideo) {
      return null;
    }
    try {
      await _cameraController.startVideoRecording(filePath);
    } on CameraException catch (error) {
      return null;
    }
    print("File Path=--------------------" + filePath);
    _videoPath = filePath;
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    print("in stop---------");
    if (!_cameraController.value.isRecordingVideo) {
      return null;
    }
    setState(() {
      _isRecording = false;
    });
    try {
      await _cameraController.stopVideoRecording();
      Navigator.of(context)
          .pushNamed(SaveVideoScreen.routeName, arguments: _videoPath);
    } on CameraException catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController != null) {
      if (!_cameraController.value.isInitialized) {
        return Container();
      }
    } else {
      return const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (!_cameraController.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      key: _key,
      extendBody: true,
      body: Container(
        child: Stack(
          children: [
            // if (_cameraController != null &&
            //     _cameraController.value != null &&
            //     !_cameraController.value.isInitialized)
            buildCameraPreview(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        child: Stack(
          children: [
            Container(
              height: 40,
              margin: EdgeInsets.only(
                // bottom: 80,
                top: 10,
                left: 70,
                right: 70,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: new Color.fromRGBO(0, 0, 0, 0.25),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      child: IconButton(
                        icon: Image.asset(
                          "assets/images/mic.png",
                          color: Colors.white,
                          height: 20,
                          width: 20,
                        ),
                        onPressed: () {
                          print("on press mic");
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: IconButton(
                        icon: Image.asset(
                          "assets/images/refresh.png",
                          color: Colors.white,
                          height: 20,
                          width: 20,
                        ),
                        onPressed: onCameraSwitch,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.42,
              ),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color:
                    !_isRecording ? Theme.of(context).primaryColor : Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: Image.asset(
                  "assets/images/video.png",
                  color: Colors.white,
                  height: 25,
                  width: 25,
                ),
                onPressed: () {
                  !_isRecording ? startVideoRecording() : stopVideoRecording();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
