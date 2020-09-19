import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Pages/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.purple[800],
        accentColor: Colors.purple[800],
        // accentColor: Colors.amber,
      ),
      home: HomePage(),
    );
  }
}
