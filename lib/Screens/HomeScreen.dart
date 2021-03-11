import 'package:DemoApp/Widgets/SearchedVideoList.dart';
import 'package:DemoApp/Widgets/search_widget.dart';
import 'package:DemoApp/Widgets/video_list.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "Home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _globalKey = GlobalKey<ScaffoldState>();
  var searchList = [];
  String serchedText = '';

  @override
  void didChangeDependencies() {
    var data = ModalRoute.of(context).settings.arguments as String;
    print("Homescreendarata-------------- $data");
    super.didChangeDependencies();
  }

  _searchData(List<dynamic> searchDataList, String text) {
    setState(() {
      serchedText = text;
      searchList = searchDataList;
    });

    print("Data in search -------${searchDataList.length}");
    print("Data in searchText -------$text");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: new Color(0xffeff2ff),
        padding: EdgeInsets.only(left: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              Container(
                child: Text(
                  "Hello, Alex!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  "What would you like to learn today?",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: new Color(0xffADADAD),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SearchWidget(
                _searchData,
              ),
              SizedBox(
                height: 40,
              ),
              if (serchedText.length == 0) VideoListWidget(),
              if (serchedText.length != 0 && searchList.length != 0)
                SerachedVideoListWidget(searchList),
              if (serchedText.length != 0 && searchList.length == 0)
                Container(
                  height: 350,
                  alignment: Alignment.center,
                  child: Text(
                    "No video found",
                    style: TextStyle(
                      fontFamily: 'Hind',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
