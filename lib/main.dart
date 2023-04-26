import 'package:flutter/material.dart';
import 'package:hao123/hao123.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'hao123',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Hao123());
  }
}
