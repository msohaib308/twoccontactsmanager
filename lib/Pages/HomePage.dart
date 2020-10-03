import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contactList = [];
  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

  getAllContacts() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      //We can now access our contacts here
      List<Contact> contacts =
          (await ContactsService.getContacts(withThumbnails: false)).toList();

      // debugPrint(contacts[0].displayName);
      setState(() {
        contactList = contacts;
      });

      // Lazy load thumbnails after rendering initial contacts.
      for (final contact in contactList) {
        ContactsService.getAvatar(contact).then((avatar) {
          if (avatar == null) return; // Don't redraw if no change.
          setState(() => contact.avatar = avatar);
        });
      }
    } else {
      //If permissions have been denied show standard cupertino alert dialog
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text('Permissions error'),
                content: Text('Please enable contacts access '
                    'permission in system settings'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text('Contacts List ' + contactList.length.toString())),
          // leading: GestureDetector(
          //   onTap: createCOntact,
          //   child: Icon(CupertinoIcons.add_circled),
          // ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.create),
              onPressed: createCOntact,
            )
          ]),
      // body: HomePageWidgets.pageStyle1(),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
                onChanged: filterContacts,
              ),
            ),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                Contact contact = contactList[index];
                return Column(
                  children: [
                    ListTile(
                      leading: (contact.avatar != null &&
                              contact.avatar.isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.avatar),
                            )
                          : CircleAvatar(
                              child: Text(contact.initials().toString()),
                              backgroundColor: Theme.of(context).accentColor,
                            ),
                      title: Text(contact.displayName ?? ''),
                      subtitle: Text(contact?.phones?.firstWhere(
                          (element) => element.value.isNotEmpty, orElse: () {
                        return Item(value: '');
                      })?.value),
                      // trailing: Text('6:45 pm'),
                      trailing: Wrap(
                        spacing: 10, // space between two icons
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.call,
                              color: Colors.green,
                              size: 30,
                            ),
                            onPressed: () {
                              // var sds = index;
                              // _launchURL();
                              launchWhatsApp(
                                  contact: contact,
                                  message: 'Allah is the best planner',
                                  context: context);
                            },
                          ), // icon-1
                          IconButton(
                            icon: Icon(
                              Icons.message,
                              color: Colors.orange,
                              size: 30,
                            ),
                            onPressed: () {},
                          ), // icon-1
                        ],
                      ),
                      onTap: () {},
                      // contentPadding: EdgeInsets.symmetric(
                      //     // horizontal: 20,
                      //     // vertical: 20,
                      //     ),
                    ),
                    Divider(
                      height: 0,
                    )
                  ],
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  // _launchURL() async {
  //   const url = 'https://flutter.dev';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  void createCOntact() async {
    await ContactsService.openContactForm();
    getAllContacts();
  }

  void launchWhatsApp({
    @required Contact contact,
    @required String message,
    @required BuildContext context,
  }) async {
    // var phone = '';
    // var phone = contact.phones.toString();
    String myUrl = '';
    if (Platform.isIOS) {
      myUrl = "whatsapp://wa.me/+923473027259/?text=${Uri.parse(message)}";
    } else {
      myUrl = "whatsapp://send?phone=+923473027259&text=${Uri.parse(message)}";
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
      Scaffold.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Could not launch $myUrl'),
        backgroundColor: Colors.orange,
        elevation: 6.0,
      ));
    }
  }

  void filterContacts(String query) async {
    List<Contact> contacts =
        (await ContactsService.getContacts(query: query, withThumbnails: false))
            .toList();
    // debugPrint(contacts[0].displayName);
    setState(() {
      contactList = contacts;
    });
  }
}
