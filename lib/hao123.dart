import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hao123/page.dart';

import 'category.dart';

class Hao123 extends StatefulWidget {
  Hao123();
  @override
  State<StatefulWidget> createState() {
    return _Hao123State();
  }
}

class _Hao123State extends State<Hao123> {
  Widget body = const Center(child: Text("loading ..."));
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.grey.withOpacity(1.0),
        title: SizedBox(
          width: 480,
          child: Form(
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (text) {
                init();
              },
              controller: controller,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'seach ...',
              ),
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: body,
    );
  }

  Future<String> getData() async {
    return await rootBundle.loadString("assets/pages.json");
  }

  List<Category> getCategory(String data) {
    List<dynamic> list = jsonDecode(data);
    List<Category> categories = List.empty(growable: true);
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
      categories!.add(Category(title: title, childs: widgets));
    }
    return categories;
  }

  init() {
    getData().then((value) {
      setState(() {
        var categories = getCategory(value);
        List<Widget> list = List.empty(growable: true);
        for (var widget in categories!) {
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
        // filter

        setState(() {
          body = SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: list,
            ),
          );
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}
