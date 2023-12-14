import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
import 'package:sito_commercialisti/Modello.dart';
import 'package:sito_commercialisti/NavBar.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:http/http.dart' as http;


class Tools2 extends StatefulWidget {
  Tools2();

  @override
  State<Tools2> createState() => Tools2State();
}

class Tools2State extends State<Tools2> {

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  Modello modello=Modello();

  final tableController = PagedDataTableController<String, int, Ufficio>();

  List<Ufficio> uffici= [];



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

      body: Center(
        child: Stack(

                children: [

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

                        child: PagedDataTable<String, int, Ufficio>(

                          idGetter: (ufficio) => ufficio.idUfficio,
                          fetchPage: (pageToken, pageSize, sortBy, filtering) async {

                            uffici=[];
                            String tt=modello.token!;

                            var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Tools/UfficioListGet'));
                            request.bodyFields= {
                              "studioId": modello!.studioId.toString(),
                              "ufficioId": "null"
                            };


                            request.headers['Authorization'] = 'Bearer $tt';

                            http.StreamedResponse response = await request.send();
                            response.stream.asBroadcastStream();


                            var jsonData=  jsonDecode(await response.stream.bytesToString());

                            if (response.statusCode == 200) {
                              print(jsonData);

                              for(var uff in jsonData){
                                String ufficioDescr=uff["ufficioDescr"].toString();
                                int ufficioId= uff["ufficioId"];
                                String ultimaModifica=uff["dataUltimaModifica"].toString();
                                uffici?.add(Ufficio(ufficioDescr, ufficioId, ultimaModifica) );
                              }
                            }
                            else {
                              print(response.reasonPhrase);
                            }

                            return PaginationResult.items(elements: uffici);
                          },
                          initialPage:"",
                          columns:[
                            TableColumn(
                                title: "Nome ufficio",
                                cellBuilder: (item) => Text(item.nome)
                            ),
                            TableColumn(
                               title: "              ",
                               sizeFactor: null,
                               cellBuilder: (item)=> Row(
                                 children: [

                                   Flexible(
                                       child:IconButton(
                                           onPressed: (){
                                             showDialog(
                                                 context: context,
                                                 builder: (BuildContext context) {
                                                   return StatefulBuilder(
                                                       builder: (BuildContext context, StateSetter setState) {

                                                         String nuovoNomeUfficio=item.nome;
                                                         return AlertDialog(
                                                           backgroundColor: Colors.deepPurple.shade100,
                                                           scrollable: true,
                                                           content: Form(
                                                             key: _formKey2,
                                                             child: Column(
                                                               mainAxisSize: MainAxisSize.min,
                                                               mainAxisAlignment: MainAxisAlignment.start,
                                                               crossAxisAlignment: CrossAxisAlignment.start,
                                                               children: <Widget>[
                                                                 Text("Codice id", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                                 Text("${item.idUfficio}"),
                                                                 SizedBox(height: 20,),
                                                                 Text("Descrizione", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                                 TextFormField(
                                                                   onChanged: (String value) {
                                                                     nuovoNomeUfficio=value;
                                                                   },
                                                                   validator: (value) {
                                                                     if (value == null || value.isEmpty) {
                                                                       return 'Please enter some text';
                                                                     }
                                                                     return null;
                                                                   },
                                                                   decoration: InputDecoration(
                                                                       border: InputBorder.none,
                                                                       hintText: '${item.nome}',
                                                                       hintStyle: TextStyle(
                                                                         color: Colors.black
                                                                       ),
                                                                   ),
                                                                 ),
                                                                 SizedBox(height: 20,),
                                                                 Text("Ultima modifica", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                                 Text("${item.ultimaModifica}"),
                                                                 SizedBox(height: 20,),
                                                                 Row(
                                                                   children: [
                                                                     ElevatedButton(
                                                                       onPressed:() async {

                                                                         var request = http.Request('POST', Uri.parse('www.studiodoc.it/api/Tools/UfficioMng'));
                                                                         String tt=modello.token!;
                                                                         int Utid=modello.dipendenteId!;
                                                                         int uffid=item.idUfficio!;

                                                                         request.bodyFields = {
                                                                           "ufficioId": "$uffid",
                                                                           "ufficioDescr": "$nuovoNomeUfficio",
                                                                           "tipoOperazione": "U",
                                                                           "utenteId": "$Utid"
                                                                         };
                                                                         request.headers['Authorization'] = 'Bearer $tt';

                                                                         http.StreamedResponse response = await request.send();
                                                                         response.stream.asBroadcastStream();

                                                                         var jsonData=  jsonDecode(await response.stream.bytesToString());

                                                                         if (response.statusCode == 200) {
                                                                           print(jsonData);
                                                                         }
                                                                         else {
                                                                           print(response.reasonPhrase);
                                                                         }
                                                                         return;

                                                                       },
                                                                       style: ElevatedButton.styleFrom(
                                                                         primary: Colors.deepPurple.shade400, // Background color
                                                                         shape: RoundedRectangleBorder(
                                                                             borderRadius: BorderRadius.circular(20.0)
                                                                         ),
                                                                       ),
                                                                       child: Text("Modifica"),
                                                                     ),
                                                                     Icon(Icons.edit)
                                                                   ],
                                                                 )//update del nome


                                                               ],
                                                             ),
                                                           ),
                                                         );
                                                       }
                                                   );
                                                 }
                                             );
                                           },
                                           icon: Icon(Icons.remove_red_eye, color: Colors.deepPurple.shade400))),


                                   Flexible(
                                       child:IconButton(
                                           onPressed: (){
                                             //print(item.id);
                                             //tableController.removeRow(item.id);
                                           },
                                           icon: Icon(Icons.delete, color: Colors.deepPurple.shade400)
                                       )
                                   )

                                 ],
                               )
                             ),
                          ],



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

                            Text("Ufficio",style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),
                            Spacer(),
                            ElevatedButton(

                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(20),
                                backgroundColor: Colors.purple.shade200,
                                shape: CircleBorder(),
                              ),

                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {

                                      return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {

                                            String? nuovoNomeUfficio=null;
                                            return AlertDialog(
                                              backgroundColor: Colors.deepPurple.shade100,
                                              scrollable: true,
                                              content: Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[

                                                    Text("Aggiungi un nuovo ufficio",style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),

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
                                                            onChanged: (String value) {
                                                              nuovoNomeUfficio=value;
                                                            },
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                return 'Please enter some text';
                                                              }
                                                              return null;
                                                            },
                                                            decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                hintText: 'Inserisci il nome dell\'ufficio'
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 30,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              primary: Colors.deepPurple.shade400, // Background color
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20.0)
                                                              ),
                                                            ),
                                                            child: Text("Aggiungi"),

                                                            onPressed: () async{
                                                              if (_formKey.currentState!.validate()) {
                                                                _formKey.currentState!.save();

                                                                String tt=modello.token!;
                                                                var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Tools/UfficioMng'));
                                                                request.bodyFields= {
                                                                  "studioId": modello.studioId.toString(),
                                                                  "ufficioId": "null",
                                                                  "ufficioDescr": nuovoNomeUfficio!,
                                                                  "tipoOperazione": "I",
                                                                  "utenteId": modello.dipendenteId.toString(),
                                                                };
                                                                request.headers['Authorization'] = 'Bearer $tt';

                                                                http.StreamedResponse response = await request.send();
                                                                response.stream.asBroadcastStream();

                                                                var jsonData=  jsonDecode(await response.stream.bytesToString());

                                                                if (response.statusCode == 200) {
                                                                  print(jsonData);
                                                                }
                                                                else {
                                                                  print(response.reasonPhrase);
                                                                }
                                                                nuovoNomeUfficio=null;
                                                                return;

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
                ],
              ),
            )

    );
  }

}



class Ufficio {

  String nome;
  int idUfficio;
  String ultimaModifica;
  Ufficio(this.nome, this.idUfficio, this.ultimaModifica);

}


//banner per aggiunta (inerito con successo/fallimento)
//aggiorna lista dopo aggiunta
//eliminazione


