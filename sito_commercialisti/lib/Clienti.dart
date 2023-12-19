import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
import 'package:sito_commercialisti/Modello.dart';
import 'package:sito_commercialisti/NavBar.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Clienti extends StatefulWidget {
  Clienti();

  @override
  State<Clienti> createState() => ClientiState();

}

class ClientiState extends State<Clienti> {

  final _formKey = GlobalKey<FormState>();
  final tableController = PagedDataTableController<String, int, Cliente>();
  PagedDataTableThemeData? theme;

  List<Cliente> clienti=[];

  Modello modello=Modello();



  @override
  Widget build(BuildContext context) {



    return Scaffold(
          drawer: NavBar(),
          appBar: AppBar(
            //leading: Icon(Icons.menu, size: 45, color: Colors.black,),
            elevation: 5,
            backgroundColor: Colors.purple.shade200,
            shadowColor: Colors.purple.shade200,
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

          body:Center(

            child: Stack(
              children:[
                Container(

                  color: const Color.fromARGB(255, 208, 208, 208),
                  padding: const EdgeInsets.only(top:80, left: 3, right: 3),

                  child: Card(

                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.deepPurple.shade600,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    shadowColor: Colors.black26,
                    color: Colors.white,


                    child: Container(

                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: PagedDataTable<String, int, Cliente>(

                        idGetter: (post) => post.clienteId,

                        controller: tableController,


                        fetchPage: (pageToken, pageSize, sortBy, filtering) async {


                          clienti=[];
                          String tt=modello.token!;


                          var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Cliente/ClienteListGet'));
                          request.bodyFields={
                            "studioId": modello!.studioId.toString(),        //<-- filtro se non null
                            "clienteId": "null",
                            "tipologiaClienteId": "null"   //se valorizzata filtra per tipologia
                          };
                          request.headers['Authorization'] = 'Bearer $tt';

                          http.StreamedResponse response = await request.send();
                          response.stream.asBroadcastStream();
                          var jsonData=  jsonDecode(await response.stream.bytesToString());
                          var inspect = jsonData['Cliente'];

                          if (response.statusCode == 200) {
                            print(jsonData);
                            for(var client in inspect){
                              clienti.add(Cliente(client["clienteId"], client["codiceCliente"], client["studioId"], client["clienteNome"], client["clienteCognome"], client["email"], client["telefono"], client["tipologiaClienteId"],client["tipologiaClienteDescr"] ));
                            }
                          }
                          else {
                            print(response.reasonPhrase);
                          }


                          //Gestione dei filtri fratm'



                          return PaginationResult.items(elements: clienti);

                        },
                        initialPage: "",

                        columns: [

                          TableColumn(
                              id: "Id Cliente",
                              title: "Id Cliente",
                              cellBuilder: (item) => Text(item.codiceCliente),
                              sizeFactor: .1
                          ),

                          TableColumn(
                              id: "Nome",
                              title: "Nome",
                              cellBuilder: (item)=> Text(item.clienteNome),
                              sizeFactor: .1
                          ),

                          TableColumn(
                            id: "Cognome",
                            title: "Cognome",
                            cellBuilder: (item)=> Text(item.clienteCognome),
                            sizeFactor: .12
                          ),

                          TableColumn(
                            id: "email",
                            title: "Email",
                            cellBuilder: (item)=> Text(item.email),
                            sizeFactor: .2
                          ),


                          TableColumn(
                            id: "telefono",
                            title: "Telefono",
                            cellBuilder: (item)=> Text(item.telefono),
                            sizeFactor: .12
                          ),


                          TableColumn(
                            id: "tipologia",
                            title: "Tipologia",
                            cellBuilder: (item)=> Text(item.tipologiaClienteDescr),
                            sizeFactor: .15
                          ),


                        ],



                        // filters: [
                        //   TextTableFilter(
                        //       id: "authorName",
                        //       title: "Author's name",
                        //       chipFormatter: (text) => "By $text"),
                        //   DropdownTableFilter<Gender>(
                        //       id: "gender",
                        //       title: "Gender",
                        //       defaultValue: Gender.male,
                        //       chipFormatter: (gender) =>
                        //       'Only ${gender.name.toLowerCase()} posts',
                        //       items: const [
                        //         DropdownMenuItem(value: Gender.male, child: Text("Male")),
                        //         DropdownMenuItem(value: Gender.female, child: Text("Female")),
                        //         DropdownMenuItem(value: Gender.unespecified, child: Text("Unspecified")),
                        //       ]),
                        //   DatePickerTableFilter(
                        //     id: "date",
                        //     title: "Date",
                        //     chipFormatter: (date) => 'Only on ${DateFormat.yMd().format(date)}',
                        //     firstDate: DateTime(2000, 1, 1),
                        //     lastDate: DateTime.now(),
                        //   ),
                        //   DateRangePickerTableFilter(
                        //     id: "betweenDate",
                        //     title: "Between",
                        //     chipFormatter: (date) =>
                        //     'Between ${DateFormat.yMd().format(date.start)} and ${DateFormat.yMd().format(date.end)}',
                        //     firstDate: DateTime(2000, 1, 1),
                        //     lastDate: DateTime.now(),
                        //   )
                        // ],


                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Card(

                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.deepPurple.shade600,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    shadowColor: Colors.black26,
                    color: Colors.white,

                    child: Container(

                      margin: EdgeInsets.fromLTRB(40, 10, 100, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Text("Clienti",style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),
                          Spacer(),
                          ElevatedButton(

                              style:ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(20),
                                backgroundColor: Colors.purple.shade200,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                              ),
                              onPressed: (){print("ciao volpiano");},
                              child: Text("importa csv",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black))
                          ),
                          SizedBox(width: 30,),
                          ElevatedButton(

                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(20),
                              backgroundColor: Colors.purple.shade200,
                              shape: CircleBorder( ),
                            ),

                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (BuildContext context, StateSetter setState) {
                                          return popUp();
                                        }
                                    );
                                  });
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 20,
                              weight: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
            ),

        ),
    );

  }

  AlertDialog popUp(){
    return AlertDialog(
      backgroundColor: Colors.deepPurple.shade100,
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Text("Credenziali accesso app",style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),

            SizedBox(height: 30),
            Padding(
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
                        hintText: 'Inserisci codice utente'
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
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

                    obscureText: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Inserisci password'
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(

                  padding: const EdgeInsets.all(1.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple.shade400, // Background color
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                    ),
                    child: Icon(Icons.upload_rounded),

                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple.shade400, // Background color
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                    ),
                    child: Text("Submit"),

                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      }
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }




}



class Cliente {

  int clienteId;
  String codiceCliente;
  int studioId;
  String clienteNome;
  String clienteCognome;
  String email;
  String telefono;
  int tipologiaClienteId;
  String tipologiaClienteDescr;

  Cliente(
      this.clienteId,
      this.codiceCliente,
      this.studioId,
      this.clienteNome,
      this.clienteCognome,
      this.email,
      this.telefono,
      this.tipologiaClienteId,
      this.tipologiaClienteDescr
  );

}


