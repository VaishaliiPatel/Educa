import 'dart:typed_data';
import 'package:DemoApp/Screens/PlayVideoScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoListWidget extends StatefulWidget {
  // VideoListWidget({Key key}) : super(key: key);

  @override
  _VideoListWidgetState createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> {
  VideoPlayerController _videoPlayerController;

  var videoList;
  String filePath;
  Stream _future;

  @override
  void initState() {
    _future = Firestore.instance
        .collection('video/KNkZltLvbGjRJ9Y0vNcl/videoDetail')
        .orderBy('timeStamp', descending: true)
        .snapshots();
    // getThumbnails(document);
    super.initState();
  }

  void onClickVideo(int index, String data) {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController = VideoPlayerController.network(data);
      _videoPlayerController.initialize();
      _videoPlayerController.pause();
      // print("in play-----------");
    } else {
      _videoPlayerController.initialize();
      _videoPlayerController.play();
      // print("in paush---------");
    }
  }

  Future getThumbnails(document) async {
    Uint8List unit8List = await VideoThumbnail.thumbnailData(
      video: document,
      imageFormat: ImageFormat.JPEG,
      // maxWidth: 128,
      quality: 50,
    );
    // print("unit8-------------$unit8List");
    return unit8List;
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: StreamBuilder(
        stream: _future,
        builder: (contex, AsyncSnapshot streamSnapShot) {
          // getThumbnails(streamSnapShot.data.documents);
          if (streamSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: streamSnapShot.data.documents.length,
            itemBuilder: (ctx, index) {
              return FutureBuilder(
                future: getThumbnails(
                    streamSnapShot.data.documents[index]['videoPath']),
                builder: (_, snapshot) {
                  // print( "datasnapshot----------------------------${snapshot.data}");
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    margin: EdgeInsets.only(top: 5, bottom: 10, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                PlayVideoScreen.routeName,
                                arguments: [
                                  streamSnapShot.data.documents[index]
                                      ['videoPath'],
                                  streamSnapShot.data.documents[index]['topic'],
                                  streamSnapShot.data.documents[index]['title'],
                                ]);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              child:
                                  snapshot.hasData && snapshot.data.length != 0
                                      ? Image.memory(
                                          snapshot.data,
                                          fit: BoxFit.cover,
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(),
                                        ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 10),
                          child: Text(
                            streamSnapShot.data.documents[index]['topic'],
                            maxLines: 1,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 10),
                          child: Text(
                            streamSnapShot.data.documents[index]['title'],
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      // }
    );
  }
}
