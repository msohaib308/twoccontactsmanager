import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDialogs {
  static showMyDialog(BuildContext context1) async {
    final myController = TextEditingController();
    await showDialog(
      context: context1,
      child: new _SystemPadding(
        child: new AlertDialog(
          title: Text('Open Whatsapp'),
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: myController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                      labelText: 'Enter Number with country code',
                      hintText: '+92XXXXXXXXXX'),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context1);
                }),
            new FlatButton(
                child: const Text('OPEN'),
                onPressed: () async {
                  String myUrl = '';
                  String phone = myController.text;
                  if (Platform.isIOS) {
                    myUrl = "whatsapp://wa.me/$phone/?text=";
                  } else {
                    myUrl = "whatsapp://send?phone=$phone&text=";
                  }

                  if (await canLaunch(myUrl)) {
                    // String data = "content://com.android.contacts/data/" + dataId;
                    // String type = "vnd.android.cursor.item/vnd.com.whatsapp.profile";
                    // Intent sendIntent = new Intent();
                    // sendIntent.setAction(Intent.ACTION_VIEW);
                    // sendIntent.setDataAndType(Uri.parse(data), type);
                    // sendIntent.setPackage("com.whatsapp");
                    // startActivity(sendIntent);
                    // if (mimeType.equals("vnd.android.cursor.item/vnd.com.whatsapp.voip.call") || mimeType.equals("vnd.android.cursor.item/vnd.com.whatsapp.video.call"))
                    await launch(myUrl);
                  } else {
                    // throw 'Could not launch ${myUrl}';
                    Scaffold.of(context1).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Could not launch $myUrl'),
                      backgroundColor: Colors.orange,
                      elevation: 6.0,
                    ));
                  }
                  Navigator.pop(context1);
                })
          ],
        ),
      ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        // padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
