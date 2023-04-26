import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hao123/page.dart';

import 'category.dart';

class Hao123 extends StatefulWidget {
  List<Category> categories = List.empty(growable: true);

  Hao123();
  @override
  State<StatefulWidget> createState() {
    return _Hao123State();
  }
}

class _Hao123State extends State<Hao123> {
  Widget body = Center(child: Text("loading ..."));
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body);
  }

  Future<String> getData() async {
    return await rootBundle.loadString("assets/pages.json");
  }

  getCategory(String data) {
    List<dynamic> list = jsonDecode(data);

    for (var jsonObj in list) {
      var title = jsonObj["title"] as String;
      List<dynamic> pages = jsonObj["pages"];
      List<Widget> widgets = List.empty(growable: true);
      for (var page in pages) {
        String icon = page["icon"] as String;
        String title = page["title"] as String;
        String description = page["description"] as String;
        String url = page["url"] as String;

        widgets.add(PageCard(
            iconUrl: icon, url: url, title: title, description: description));
      }
      widget.categories!.add(Category(title: title, childs: widgets));
    }
  }

  @override
  void initState() {
    super.initState();
    getData().then((value) {
      setState(() {
        getCategory(value);
        List<Widget> list = List.empty(growable: true);
        for (var widget in widget.categories!) {
          if (!list.isEmpty) {
            list.add(Container(
              height: 30,
            ));
          } else {
            list.add(Container(
              height: 10,
            ));
          }
          list.add(widget);
        }
        body = SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: list,
          ),
        );
      });
    });
  }
}
