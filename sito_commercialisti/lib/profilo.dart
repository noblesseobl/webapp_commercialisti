import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
import 'package:sito_commercialisti/NavBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sito_commercialisti/transition.dart';

import 'HomePageSito.dart';

class Profilo extends StatefulWidget {
  Profilo();

  @override
  State<Profilo> createState() => ProfiloState();
}

class ProfiloState extends State<Profilo> {

  File ? imageFile;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
      drawer: NavBar(),
      appBar: AppBar(
        //leading: Icon(Icons.menu, size: 45, color: Colors.black,),
        elevation: 5,
        toolbarHeight: 80,
        backgroundColor: Colors.purple.shade200,
        shadowColor: Colors.purple.shade100,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),

        title: Stack(
          children: [

            Padding(
                padding: getPadding(top: 0),
                child: Text("Studio Grassi",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.black,
                    ))),
            // Implement the stroke

            Padding(
                padding: getPadding(top: 0),
                child: Text("Studio Grassi",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ))),

          ],),
      ),

      body:  SingleChildScrollView(child:
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                SizedBox(height: 20,),
                Wrap(
                  children:[
                  SizedBox(width: 30,),
                  Text("Profilo",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.grey.shade700)
                  ),
                ],
                ),
                Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          SizedBox(height: 40,),
          CircleAvatar(
            backgroundColor: Colors.blueGrey.shade200,
            backgroundImage: AssetImage('/mole.png'),
            radius: 80,
          ),
            SizedBox(height: 15,),

            new Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _getFromCamera();
                  },
                  child: Text("PICK FROM CAMERA"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple.shade400, // Background color
                  ),
                ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () {
                    _getFromGallery();
                  },
                  child: Text("PICK FROM GALLERY"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple.shade400, // Background color
                  ),
                ),
              ],
            ),

            SizedBox(height: 40,),
          Wrap(
            children:[
              SizedBox(
            width: 500,
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
              decoration:BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.deepPurple.shade400)
              ),
              child:Padding(
                padding: const EdgeInsets.only(left: 12),

                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nome Studio'
                  ),
                ),
              ),
            ),
          ),
          ),
            ]
          ),
          SizedBox(height: 20,),
          Wrap(
              children:[
                SizedBox(
                  width: 500,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Container(
                      decoration:BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.deepPurple.shade400)
                      ),
                      child:Padding(
                        padding: const EdgeInsets.only(left: 12),

                        child: TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Indirizzo'
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]
          ),
          SizedBox(height: 20,),
          Wrap(
              children:[
                SizedBox(
                  width: 500,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Container(
                      decoration:BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.deepPurple.shade400)
                      ),
                      child:Padding(
                        padding: const EdgeInsets.only(left: 12),

                        child: TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email'
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]
          ),
          SizedBox(height: 20,),
          Wrap(
              children:[
                SizedBox(
                  width: 500,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Container(
                      decoration:BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.deepPurple.shade400)
                      ),
                      child:Padding(
                        padding: const EdgeInsets.only(left: 12),

                        child: TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Telefono'
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]
          ),
          SizedBox(height: 20,),
          Wrap(
              children:[
                SizedBox(
                  width: 500,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Container(
                      decoration:BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.deepPurple.shade400)
                      ),
                      child:Padding(
                        padding: const EdgeInsets.only(left: 12),

                        child: TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Descrizione'
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]
          ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: ()  {
                Navigator.of(context).push(
                  CustomPageRoute(
                      child: HomePageSito(),
                      direction:AxisDirection.up
                  ),);
              },
              // {
              //
              //   if (_formKey.currentState!.validate()) {
              //
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text('Processing Data')),
              //     );
              //     try{
              //
              //       var request = http.Request('POST', Uri.parse('http://localhost:51868/Login/LoginCheck'));
              //       request.body = '''{\r\n    "codiceUtente": "TEST_2",\r\n\t"password" : "Algo@2022!"\r\n\r\n}''';
              //
              //       http.Response response = (await request.send()) as Response;
              //
              //       final jsonData = jsonDecode(response.body) as Map< String, dynamic>;
              //
              //       if (jsonData["retCode"]=="0" && jsonData["retDescr"]=="Accesso consentito") {
              //
              //
              //         request = http.Request('POST', Uri.parse('http://localhost:51868/token'));
              //         request.bodyFields = {
              //           'username': 'super',
              //           'password': 'super',
              //           'grant_type': 'password'
              //         };
              //
              //         http.Response response2 = (await request.send()) as Response;
              //
              //         if (response.statusCode == 200) {
              //           Navigator.of(context).push(
              //             CustomPageRoute(
              //                 child: HomePage(),
              //                 direction:AxisDirection.up
              //             ),);
              //         }  else {
              //           print(response.reasonPhrase);
              //         }
              //
              //
              //
              //
              //
              //
              //
              //
              //
              //
              //
              //       }
              //       else if (jsonData["retCode"]=="1" && jsonData["retDescr"]=="Accesso negato"){
              //         print(response.reasonPhrase);
              //         sbagliato=true;
              //       }else{
              //         print(response.reasonPhrase);
              //         sbagliato=true;
              //       }
              //
              //
              //
              //     }catch(er){
              //       print(er);
              //     }
              //
              //
              //
              //   }
              //
              //   // Navigator.of(context).push(
              //   //   CustomPageRoute(
              //   //       child: HomePage(),
              //   //       direction:AxisDirection.up
              //   //   ),);
              //
              //   //cambia route
              //
              // },
              child: Text("SALVA", style: TextStyle(fontSize: 16),),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple.shade400, // Background color
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
              ),
            ),
            SizedBox(height: 80,),
          ],
        ),
        ),
      ],),
    ));
  }

  _getFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    /*
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }

     */
  }

  _getFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    /*
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }

     */
  }
}

