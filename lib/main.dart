import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twoccontactsmanager/chatList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: GestureDetector(
          onTap: () {},
          child: Icon(CupertinoIcons.settings),
        ),
        middle: CupertinoTextField(
          placeholder: 'Search',
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
        ),
        leading: GestureDetector(
          onTap: () {},
          child: Icon(CupertinoIcons.photo_camera),
        ),
      ),
      child: Material(
        child: ListView(
          children: chatList.map((snap) {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      image: NetworkImage(snap['photo']),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(snap['name']),
                  subtitle: Text(snap['message']),
                  trailing: Text('6:45 pm'),
                  onTap: () {},
                  // contentPadding: EdgeInsets.symmetric(
                  //     // horizontal: 20,
                  //     // vertical: 20,
                  //     ),
                ),
                Divider(),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
