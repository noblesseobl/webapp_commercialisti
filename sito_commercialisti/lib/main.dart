import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
import 'package:sito_commercialisti/HomePageSito.dart';
import 'package:sito_commercialisti/NavBar.dart';
import 'package:sito_commercialisti/transition.dart';

import 'Post.dart';

void main() {


  PostsRepository.generate(200);
  runApp(MyHomePage(

  ));
}




class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: LoginUser(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        PagedDataTableLocalization.delegate
        ],
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: const ColorScheme.light(
                primary: Colors.deepPurple, secondary: Colors.teal),
            //textTheme: GoogleFonts.robotoTextTheme(),
            cardTheme: CardTheme(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            popupMenuTheme: PopupMenuThemeData(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
    );
  }

}

class LoginUser extends StatefulWidget {
  LoginUser();

  @override
  State<LoginUser> createState() => _LoginState();
}

class _LoginState extends State<LoginUser> {




  String username="";
  String password="";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    bool sbagliato=false;

    return Scaffold(
        backgroundColor: Colors.purple.shade100,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Form(

                    key: _formKey,
                    child: Container(
                        width: double.maxFinite,
                        padding: getPadding(left: 41, top: 49, right: 41, bottom: 49),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Padding(
                                  padding: getPadding(top: 11),
                                  child: Text("Welcome!",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30
                                      ))),

                              Padding(
                                  padding: getPadding(top: 10),
                                  child: Text("Login",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      ))),

                              SizedBox(height: 40,),

                              SizedBox(
                                width:250,
                                child: Container(
                                  decoration:BoxDecoration(
                                      color: Colors.blueGrey.shade50,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.black)
                                  ),
                                  child:Padding(
                                    padding: const EdgeInsets.only(left: 20),

                                    child: TextFormField(
                                      onChanged: (String value) {
                                        username=value;
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value) ){
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Username'
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10,),

                              SizedBox(

                                width: 250,
                                child: Container(
                                  decoration:BoxDecoration(
                                      color: Colors.blueGrey.shade50,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.black)
                                  ),
                                  child:Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: TextFormField(
                                      obscureText: true,
                                      onChanged: (String value) {
                                        password=value;
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Password'
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 25,),


                              Visibility(
                                visible: sbagliato,
                                child: Text("Username o password errati",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 15,
                                        backgroundColor: Colors.white70,
                                        fontWeight: FontWeight.bold)),
                              ),

                              SizedBox(height: 25,),

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
                                child: Text("Accedi", style: TextStyle(fontSize: 16),),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurple.shade400, // Background color
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0)
                                  ),
                                ),
                              ),

                              SizedBox(height: 25,),
                              _divider(),
                              SizedBox(height: 30,),


                              Padding(
                                  padding: getPadding(top: 22),
                                  child: Text("Non hai un account?",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )
                                  )),

                              // GestureDetector(
                              //     onTap: () {
                              //       Navigator.of(context).push(
                              //         CustomPageRoute(
                              //             child: SignIn(),
                              //             direction:AxisDirection.up),);
                              //       print("registrati");
                              //     },
                              //     child: Padding(
                              //         padding: getPadding(top: 9),
                              //         child: Text("Registrati",
                              //             overflow: TextOverflow.ellipsis,
                              //             textAlign: TextAlign.left,
                              //             style: TextStyle(
                              //                 color: Colors.deepPurple.shade600,
                              //                 decoration: TextDecoration.underline)
                              //         ))),

                              SizedBox(height: 20,),
                              Padding(
                                  padding: getPadding(top: 0),
                                  child: Text("Password dimenticata?",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )
                                  )),

                              // GestureDetector(
                              //   onTap: (){
                              //     Navigator.of(context).push(
                              //       CustomPageRoute(
                              //           child: RecuperaPassword(),
                              //           direction:AxisDirection.up),);
                              //     print("Recupera");
                              //   },
                              //   child: Padding(
                              //       padding: getPadding(top: 11),
                              //       child: Text("Recupera password",
                              //           overflow: TextOverflow.ellipsis,
                              //           textAlign: TextAlign.left,
                              //           style: TextStyle(
                              //               color: Colors.deepPurple.shade600,
                              //               decoration: TextDecoration.underline)
                              //       )),
                              // ),

                            ]))),
              ),

            )));
  }


  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}



