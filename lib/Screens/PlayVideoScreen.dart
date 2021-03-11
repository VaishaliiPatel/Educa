import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayVideoScreen extends StatefulWidget {
  static String routeName = "PalyVideo";
  @override
  _PlayVideoScreenState createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;
  List<dynamic> data;
  var isPlay = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final routeData =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    print("in Play Video-------------------${routeData[0]}");
    data = routeData;
    _videoPlayerController = VideoPlayerController.network(
      routeData[0],
    );
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    _videoPlayerController.play();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void onSubmit() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      setState(() {
        isPlay = false;
      });
      print("in play-----------");
    } else {
      _videoPlayerController.play();
      setState(() {
        isPlay = true;
      });
      print("in paush---------");
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
                    child: Column(
                      children: [
                        Container(
                          height: 350,
                          width: MediaQuery.of(context).size.width,
                          child: AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: VideoPlayer(
                              _videoPlayerController,
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
                            data[1],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Hind',
                              fontSize: 24,
                              // color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data[2],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Hind',
                              fontSize: 20,
                              // color: Theme.of(context).primaryColor,
                            ),
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
          onPressed: onSubmit,
          child: Text(
            isPlay ? "Pause" : "Play",
            style: Theme.of(context).primaryTextTheme.button,
          ),
        ),
      ),
    );
  }
}
