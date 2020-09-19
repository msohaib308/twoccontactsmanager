import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../chatList.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contactList = [];
  String _name = '';
  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

  getAllContacts() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      //We can now access our contacts here
      List<Contact> contacts = (await ContactsService.getContacts()).toList();
      // debugPrint(contacts[0].displayName);
      setState(() {
        contactList = contacts;
      });
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
        title: Center(child: Text('Contacts List')),
        // leading: GestureDetector(
        //   onTap: () {},
        //   child: Icon(CupertinoIcons.photo_camera),
        // ),
      ),
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
                Contact contact = contactList?.elementAt(index);
                return Column(
                  children: [
                    ListTile(
                      leading: (contact.avatar != null &&
                              contact.avatar.isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.avatar),
                            )
                          : CircleAvatar(
                              child: Text(contact.initials()),
                              backgroundColor: Theme.of(context).accentColor,
                            ),
                      title: Text(contact.displayName),
                      subtitle: Text(contact.phones.single.value),
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
                            onPressed: () {},
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

  void filterContacts(String query) async {
    List<Contact> contacts =
        (await ContactsService.getContacts(query: query)).toList();
    // debugPrint(contacts[0].displayName);
    setState(() {
      contactList = contacts;
    });
  }
}
