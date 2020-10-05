import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Pages/HomePage.dart';
import 'Services/HexColor.dart';

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
      title: '2C Contacts',
      theme: ThemeData(
        brightness: Brightness.light,
        // primaryColor: Colors.purple[800],
        primaryColor: HexColor('#4eb048'),
        // accentColor: Colors.purple[800],
        accentColor: HexColor('#1d3d71'),
      ),
      home: HomePage(),
    );
  }
}
