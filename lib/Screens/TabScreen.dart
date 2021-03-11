import 'package:DemoApp/Screens/HomeScreen.dart';
import 'package:DemoApp/Screens/Profile.dart';
import 'package:DemoApp/Screens/camreaScreen.dart';
import 'package:flutter/material.dart';

class TabBarScareen extends StatefulWidget {
  static String routeName = "TabBar";
  @override
  _TabBarScareenState createState() => _TabBarScareenState();
}

class _TabBarScareenState extends State<TabBarScareen> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  List<Map<String, Object>> _pages;
  var selectedPageIndex = 0;
  var _name = '';

  @override
  void initState() {
    _pages = [
      {
        "page": HomeScreen(),
        "title": 'Home',
      },
      {
        "page": ProfileScreen(),
        "title": 'Profile',
      },
      {
        "page": ProfileScreen(),
        "title": 'Profile',
      },
      {
        "page": HomeScreen(),
        "title": 'Home',
      },
    ];
    super.initState();
  }

  void _selectedPage(int index) {
    setState(() {
      if (index == 5) {
        selectedPageIndex = selectedPageIndex;
      } else {
        selectedPageIndex = index;
      }
    });
  }

  @override
  void didChangeDependencies() {
    var data = ModalRoute.of(context).settings.arguments as String;
    setState(() {
      _name = data;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedPageIndex]['page'],
      bottomNavigationBar: Container(
        // margin: EdgeInsets.only(
        //   left: 30,
        //   right: 30,
        // ),
        child: Container(
          height: 90,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: BottomNavigationBar(
                    elevation: 0,
                    onTap: _selectedPage,
                    currentIndex: selectedPageIndex,
                    items: [
                      BottomNavigationBarItem(
                        icon: Image.asset(
                          "assets/images/book.png",
                          height: 20,
                          width: 20,
                        ),
                        label: selectedPageIndex == 0 ? "•" : "",
                      ),
                      BottomNavigationBarItem(
                        icon: Image.asset(
                          "assets/images/message-square.png",
                          height: 20,
                          width: 20,
                        ),
                        label: selectedPageIndex == 1 ? "•" : "",
                        // activeIcon: Text(
                        //   ".",
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 24,
                        //   ),
                        // ),
                      ),
                      BottomNavigationBarItem(
                        icon: Image.asset(
                          "assets/images/userIcon.png",
                          height: 20,
                          width: 20,
                        ),
                        label: selectedPageIndex == 2 ? "•" : "",
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                // height: 120,
                margin: EdgeInsets.only(
                  // bottom: 15,t
                  // top: 40,
                  bottom: 40,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  // icon: Icon(Icons.add),
                  icon: Image.asset(
                    "assets/images/video.png",
                    height: 25,
                    width: 25,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CameraScreen.routeName);
                  },
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
