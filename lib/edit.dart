import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:json_editor/json_editor.dart';

// ignore: must_be_immutable
class PageEditor extends StatefulWidget {
  String jsonString = "";
  PageEditor({
    required this.jsonString,
  });
  @override
  State<StatefulWidget> createState() {
    return _PageEditorState();
  }
}

class _PageEditorState extends State<PageEditor> {
  double titleWidth = 80;

  save(String data) {
    try {
      String home = Platform.environment['HOME'] ?? "";
      File f = File(path.join(home, ".hao123.json"));
      f.writeAsString(data, flush: true);
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  bool validate(String data) {
    try {
      List<dynamic> list = jsonDecode(data);
      for (var jsonObj in list) {
        var title = jsonObj["title"] as String;
        if (title.isEmpty) {
          return false;
        }
        List<dynamic> pages = jsonObj["pages"];
        for (var page in pages) {
          String icon = page["icon"] as String;
          if (icon.isEmpty) {
            return false;
          }
          String title = page["title"] as String;
          if (title.isEmpty) {
            return false;
          }
          String description = page["description"] as String;
          if (description.isEmpty) {
            return false;
          }
          String url = page["url"] as String;
          if (url.isEmpty) {
            return false;
          }
        }
      }
    } on Exception catch (_) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Widget title = Container(
      child: Text(
        "编辑",
        style: TextStyle(fontSize: 18),
      ),
      width: titleWidth,
    );
    return Scaffold(
        body: Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 18, right: 18),
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: (MediaQuery.of(context).size.width - titleWidth) / 2.0,
              ),
              title,
              Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: Colors.grey,
                  )),
              IconButton(
                  onPressed: () {
                    if (validate(widget.jsonString)) {
                      save(widget.jsonString);
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    Icons.save,
                    color: Colors.grey,
                  ))
            ],
          ),
        ),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(left: 18, right: 18),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border:
                  Border.all(width: 1.0, color: Colors.grey.withOpacity(0.2))),
          child: JsonEditor.string(
            jsonString: widget.jsonString,
            onValueChanged: (value) {
              String s = value.toPrettyString();
              if (validate(s)) {
                save(s);
                widget.jsonString = s;
              }
            },
          ),
        ))
      ],
    ));
  }
}
