import 'package:flutter/material.dart';
import 'package:sito_commercialisti/Dipendenti.dart';
import 'package:sito_commercialisti/HomePageSito.dart';
import 'package:sito_commercialisti/bacheca.dart';
import 'package:sito_commercialisti/messaggi.dart';
import 'package:sito_commercialisti/profilo.dart';
import 'package:sito_commercialisti/tools.dart';
import 'package:sito_commercialisti/tools2.dart';
import 'package:sito_commercialisti/transition.dart';



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
                '',
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
              Icons.work_outlined,
              color: Color(0xff9B63F8),
            ),
            title: Text('Dipendenti'),
              onTap: (){
                Navigator.of(context).push(
                  CustomPageRoute(
                    child: Dipendenti(),
                    direction: AxisDirection.up
                  ),
                );
              },
          ),

          ListTile(
            leading: Icon(
              Icons.handshake_outlined,
              color: Color(0xff9B63F8),
            ),
            title: Text('Clienti'),
              onTap: (){
                Navigator.of(context).push(
                  CustomPageRoute(
                    child: HomePageSito(),
                    direction: AxisDirection.up),
                );
              },
          ),

          ListTile(
            leading: Icon(
              Icons.mail_outlined,
              color: Color(0xff9B63F8),
            ),
            title: Text('Messaggi'),
            onTap: (){
              Navigator.of(context).push(CustomPageRoute(
                  child: Messaggi(),
                  direction: AxisDirection.up),);
            },
          ),

          ListTile(
            leading: Icon(
              Icons.newspaper_outlined,
              color: Color(0xff9B63F8),
            ),
            title: Text('News/documenti'),
            onTap: (){Navigator.of(context).push(CustomPageRoute(
                child: Bacheca(),
                direction: AxisDirection.up),);},
          ),

          ListTile(
            leading: Icon(
              Icons.chair,
              color: Color(0xff9B63F8),
            ),
            title: Text('Tipologia Cliente'),
            onTap: (){Navigator.of(context).push(CustomPageRoute(
                child: Tools(),
                direction: AxisDirection.up),);},
          ),

          ListTile(
            leading: Icon(
              Icons.home_work,
              color: Color(0xff9B63F8),
            ),
            title: Text('Ufficio'),
            onTap: (){Navigator.of(context).push(CustomPageRoute(
                child: Tools2(),
                direction: AxisDirection.up),);},
          ),


          Divider(),

          ListTile(
            leading: Icon(
              Icons.person,
              color: Color(0xff9B63F8),
            ),
            title: Text('Profilo'),
            onTap: () {
              Navigator.of(context).push(CustomPageRoute(
                  child: Profilo(),
                  direction: AxisDirection.up),);
            },
          ),

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
