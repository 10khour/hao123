import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Category extends StatelessWidget {
  String title;
  List<Widget> childs;
  Category({required this.title, required this.childs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 1,
            child: Container(color: Colors.grey),
          ),
          const SizedBox(
            height: 5,
          ),
          Wrap(
            children: childs,
          )
        ],
      ),
    );
  }
}
