import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hao123/edit.dart';
import 'package:hao123/page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
        actions: [
          if ((!kIsWeb) && Platform.isMacOS)
            IconButton(
                onPressed: () {
                  getData().then((value) {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return PageEditor(jsonString: value);
                    })).then((value) {
                      init(controller.text);
                    });
                  });
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                ))
        ],
        backgroundColor: Color.fromRGBO(130, 77, 252, 0.9),
        title: SizedBox(
          width: 480,
          height: 43,
          child: Form(
            child: TextField(
              textInputAction: TextInputAction.search,
              onChanged: (text) {
                init(text);
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
      ),
      body: body,
    );
  }

  Future<String> getData() async {
    if ((!kIsWeb) &&
        (Platform.isLinux || Platform.isMacOS || Platform.isWindows)) {
      String home = Platform.environment['HOME'] ?? "";
      File f = File(path.join(home, ".hao123.json"));
      setState(() {
        body = Center(
          child: Text("读取本地配置中..."),
        );
      });
      try {
        String s = f.readAsStringSync();
        if (s.isNotEmpty) {
          setState(() {
            body = Center(
              child: Text("本地配置读取成功..."),
            );
          });
          return Future.value(s);
        }
      } on Exception catch (_) {}
      setState(() {
        body = Center(
          child: Text("本地配置读取失败，使用内置配置..."),
        );
      });
    }

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
      categories.add(Category(title: title, childs: widgets));
    }
    return categories;
  }

  init(String search) {
    setState(() {
      body = Center(
        child: Text("解析配置中..."),
      );
    });
    getData().then((value) {
      var categories = getCategory(value);
      for (var i = 0; i < categories.length; i++) {
        if (categories[i].title.toUpperCase().contains(search.toLowerCase())) {
          continue;
        }
        for (var j = 0; j < categories[i].childs.length; j++) {
          if (categories[i].childs[j] is PageCard) {
            categories[i].childs.removeWhere((element) {
              if (element is PageCard) {
                var pageCard = element;
                if (pageCard.description
                    .toUpperCase()
                    .contains(search.toUpperCase())) {
                  return false;
                }
                if (pageCard.url.toUpperCase().contains(search.toLowerCase())) {
                  return false;
                }
                if (pageCard.title
                    .toUpperCase()
                    .contains(search.toUpperCase())) {
                  return false;
                }
                return true;
              }
              return false;
            });
          }
        }
      }
      categories.removeWhere((element) {
        return element.childs.isEmpty;
      });
      List<Widget> list = List.empty(growable: true);
      for (var widget in categories) {
        if (list.isNotEmpty) {
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
  }

  @override
  void initState() {
    super.initState();
    init(controller.text);
  }
}
