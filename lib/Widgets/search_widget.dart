import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final void Function(List<dynamic> searchDataList, String text) seacrhText;

  SearchWidget(this.seacrhText);
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _searchController = TextEditingController();

  Stream _future;
  var datalist = [];

  var searchList = [];

  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {});
    });
    Firestore.instance
        .collection('video/KNkZltLvbGjRJ9Y0vNcl/videoDetail')
        .snapshots()
        .map((event) {
      event.documents.forEach((element) {
        datalist.add(element);
      });
    }).toList();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    // _chewieController.dispose();
    super.dispose();
  }

  Future<void> onSearchhText(String value) async {
    searchList = [];

    print(
        "Search text bool-------------------${_searchController.text.isNotEmpty}");
    if (_searchController.text.isNotEmpty) {
      var str = _searchController.text;
      print("Fututre----------------------------");
      print(datalist);
      datalist.forEach((item) {
        if (item['title'].toLowerCase().contains(str.toLowerCase()) ||
            item['topic'].toLowerCase().contains(str.toLowerCase())) {
          print("in map function----------------------${item['topic']}-");
          searchList.add(item);
        }
      });
      print(searchList.length);
    }
    widget.seacrhText(searchList, _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        color: Colors.white,
      ),
      height: 60,
      child: Row(
        children: [
          Container(
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
              color: Theme.of(context).primaryColor,
            ),
            height: double.infinity,
            padding: EdgeInsets.all(17),
            child: Image.asset(
              "assets/images/search.png",
              height: 20,
              width: 20,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Content Creation',
                ),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  fontFamily: 'Hind',
                ),
                onChanged: onSearchhText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
