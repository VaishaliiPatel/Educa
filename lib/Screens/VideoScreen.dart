import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class VideoScreen extends StatefulWidget {
  static String routeName = "VideoScreen";

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  CameraController cameraController;
  String videoPath;
  List<CameraDescription> _cameras;
  int selectedCameraIdx;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Future pickCameraMedia(BuildContext context) async {
    final getMedia = ImagePicker().getVideo;

    final media = await getMedia(source: ImageSource.camera);
    final file = File(media.path);
    print("VideoFile-------" + file.path);
    Navigator.of(context).pop(file);
  }

  void initState() {
    super.initState();
    availableCameras().then((value) {
      _cameras = value;
      if (_cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });
      }
      _onCameraSwitched(_cameras[selectedCameraIdx]).then((void v) {});
    }).catchError((error) {
      print("Error in switch camera");
    });
  }

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController.dispose();
    }

    cameraController =
        CameraController(cameraDescription, ResolutionPreset.low);

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (cameraController.value.hasError) {
        _key.currentState.showSnackBar(
          SnackBar(
            content: Text(
              'Camera error ${cameraController.value.errorDescription}',
            ),
          ),
        );
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      // _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
        selectedCameraIdx < _cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = _cameras[selectedCameraIdx];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  void _onRecordButtonPressed() {
    _startVideoRecording().then((String filePath) {
      if (filePath != null) {
        // Fluttertoast.showToast(
        //     msg: 'Recording video started',
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIos: 1,
        //     backgroundColor: Colors.grey,
        //     textColor: Colors.white);
      }
    });
  }

  Future<String> _startVideoRecording() async {
    if (!cameraController.value.isInitialized) {
      // Fluttertoast.showToast(
      //     msg: 'Please wait',
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIos: 1,
      //     backgroundColor: Colors.grey,
      //     textColor: Colors.white);

      return null;
    }

    // Do nothing if a recording is on progress
    if (cameraController.value.isRecordingVideo) {
      return null;
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/${currentTime}.mp4';

    try {
      await cameraController.startVideoRecording(filePath);
      videoPath = filePath;
    } on CameraException catch (e) {
      // _showCameraException(e);
      print("error1----------");
      return null;
    }

    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      extendBody: true,
      body: Container(
        child: Stack(
          children: [
            // if (_cameraController != null &&
            //     _cameraController.value != null &&
            //     !_cameraController.value.isInitialized)
            // buildCameraPreview(),
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
                        onPressed: () {},
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
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: Image.asset(
                  "assets/images/video.png",
                  color: Colors.white,
                  height: 25,
                  width: 25,
                ),
                onPressed: () => pickCameraMedia(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _saveVideo() {
  return Container();
}
