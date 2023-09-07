import 'package:flutter/material.dart';



class NavBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(''),
            accountEmail: Text(''),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                  child: Image.asset(
                'assets/g_wagon.png',
                fit: BoxFit.cover,
              )),
            ),
            decoration: BoxDecoration(
              color: Color(0xff9B63F8),
              image: DecorationImage(
                image: NetworkImage(
                    'https://cdn.pixabay.com/photo/2018/11/05/14/09/vector-3796144_960_720.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Color(0xff9B63F8),
            ),
            title: Text('Profilo'),
            onTap: () => print('NavBar Profilo BTN Pressed'),
          ),
          ListTile(
            leading: Icon(Icons.favorite_outlined, color: Color(0xff9B63F8)),
            title: Text('Favorite'),
            onTap: () => print('NavBar Favorite BTN Pressed'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info, color: Color(0xff9B63F8)),
            title: Text('About Us'),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Color(0xff9B63F8)),
            title: Text('Impostazioni'),
            onTap: () => print('NavBar Impostazioni Us BTN Pressed'),
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.logout_rounded, color: Color(0xff9B63F8)),
              title: Text('Logout'),
              onTap: () async {
                final action = await _asyncConfirmDialog(context);
              }),
        ],
      ),
    );
  }
}

//Allert Logout
enum ConfirmAction { Cancel, Accept }

Future<Future<ConfirmAction?>> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete This Contact?'),
        content: const Text('This will delete the contact from your device.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Cancel);
            },
          ),
          ElevatedButton(
            child: const Text('Logout'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Accept);//CAPIRE BENE COME FUNZIONA

            },
          )
        ],
      );
    },
  );
}
