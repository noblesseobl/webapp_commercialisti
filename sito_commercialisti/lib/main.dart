import 'package:flutter/material.dart';
import 'package:sito_commercialisti/NavBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp( debugShowCheckedModeBanner: false,);
  }
}


class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: NavBar(),
      appBar: AppBar(

        backgroundColor: Color(0xffF6EEF6),
        iconTheme: IconThemeData(color: Color(0xff9B63F8)),
        title: Text(
          'BooKingz',
          style: TextStyle(
            color: Color(0xff9B63F8),
            fontSize: 35,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w800,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.25),
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Text('CIAO'),
      ),
    );
  }
}
