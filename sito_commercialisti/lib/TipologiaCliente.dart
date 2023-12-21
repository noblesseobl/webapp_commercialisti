import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
import 'package:sito_commercialisti/Modello.dart';
import 'package:sito_commercialisti/NavBar.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:http/http.dart' as http;

class Tools extends StatefulWidget {
  Tools();

  @override
  State<Tools> createState() => ToolsState();
}

class ToolsState extends State<Tools> {


  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  Modello modello=Modello();

  final tableController = PagedDataTableController<String, int, TipologiaCliente>();

  List<TipologiaCliente> tipologieClienti= [];

  Future<http.StreamedResponse> deleteTipologia(int tipol) async {

    var request= http.Request('POST',Uri.parse('http://www.studiodoc.it/api/Tools/TipologiaClienteMng'));
    String tt=modello!.token!;
    request.bodyFields = {
      "tipologiaClienteId": tipol.toString(),
      "tipoOperazione": "D",
      "utenteId": modello!.codiceUtente!
    };
    request.headers['Authorization'] = 'Bearer $tt';

    return request.send();

  }



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
                        child: PagedDataTable<String, int, TipologiaCliente>(

                          controller: tableController,
                          idGetter: (tipologia) => tipologia.idTipologia,

                          fetchPage: (pageToken, pageSize, sortBy, filtering) async {
                            tipologieClienti=[];
                            String tt=modello.token!;

                            var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Tools/TipologiaClienteListGet'));
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

                              for(var tip in jsonData){
                                String tipologiaDescr=tip["tipologiaClienteDescr"].toString();
                                int tipologiaId= tip["tipologiaClienteId"];
                                String ultimaModifica=tip["dataUltimaModifica"].toString();
                                tipologieClienti?.add(TipologiaCliente(tipologiaDescr, tipologiaId, ultimaModifica) );
                              }
                            }
                            else {
                              print(response.reasonPhrase);
                            }

                            return PaginationResult.items(elements: tipologieClienti);

                          },
                          initialPage: "",

                          columns: [
                            TableColumn(
                              title: "Nome tipologia cliente",
                              cellBuilder: (item) => Text(item.nome, style: TextStyle(fontSize: 15, overflow: TextOverflow.visible)),
                              sizeFactor: 0.3,
                            ),

                            TableColumn(
                                title: "              ",
                                sizeFactor: null,
                                cellBuilder: (item)=> Row(
                                  //mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    Flexible(
                                        child:IconButton(
                                            onPressed:(){
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return StatefulBuilder(
                                                        builder: (BuildContext context, StateSetter setState) {
                                                          String nuovoNomeTipologia=item.nome;
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
                                                                  SizedBox(height: 5),
                                                                  Text("${item.idTipologia}"),
                                                                  SizedBox(height: 20,),
                                                                  Text("Descrizione", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                                  Container(
                                                                    decoration:BoxDecoration(
                                                                        color: Colors.blueGrey.shade50,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        border: Border.all(color: Colors.black)
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 10),
                                                                      child: TextFormField(
                                                                        onChanged: (String value) {
                                                                          nuovoNomeTipologia=value;
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
                                                                          try{

                                                                            var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Tools/TipologiaClienteMng'));
                                                                            String tt=modello.token!;
                                                                            int Tiid=modello.dipendenteId!;

                                                                            int tipologiaid=item.idTipologia!;

                                                                            request.bodyFields = {
                                                                              "tipologiaClienteId": "$tipologiaid",
                                                                              "tipologiaClienteDescr": "$nuovoNomeTipologia",
                                                                              "tipoOperazione": "U",
                                                                              "utenteId": "$Tiid"
                                                                            };
                                                                            request.headers['Authorization'] = 'Bearer $tt';

                                                                            http.StreamedResponse response = await request.send();
                                                                            response.stream.asBroadcastStream();
                                                                            var jsonData=  jsonDecode(await response.stream.bytesToString());

                                                                            item.nome= nuovoNomeTipologia;

                                                                            if (jsonData["retCode"]==0) {
                                                                              print(jsonData);
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(content: Text(jsonData["retDescr"].toString())),
                                                                              );
                                                                            }
                                                                            else {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(content: Text("Qualcosa è andato storto durante l'update!")),
                                                                              );
                                                                            }
                                                                            Navigator.of(context).pop();
                                                                            setState((){
                                                                              tableController.refresh();
                                                                            });
                                                                          }catch(er){
                                                                            print(er);
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(content: Text('Errore del Server!')),
                                                                            );
                                                                          }
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                          primary: Colors.deepPurple.shade400, // Background color
                                                                          shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20.0)
                                                                          ),
                                                                        ),
                                                                        child: Row(
                                                                          children: [
                                                                            Text("Modifica"),
                                                                            SizedBox(width: 10,),
                                                                            Icon(Icons.edit)
                                                                          ],
                                                                        ),
                                                                      ),

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
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return
                                                      StatefulBuilder(
                                                          builder: (BuildContext context, StateSetter setState) {
                                                            return AlertDialog(
                                                              backgroundColor: Colors.deepPurple.shade100,
                                                              content: Form(
                                                                key: _formKey,
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: <Widget>[

                                                                    Text("Sei sicuro di voler eliminare questa categoria?",style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),

                                                                    SizedBox(height: 40),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                      children: [


                                                                        Padding(
                                                                          padding: const EdgeInsets.all(10.0),
                                                                          child: ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                              primary: Colors.grey.shade100, // Background color
                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(20.0)
                                                                              ),
                                                                            ),
                                                                            child: Text("Annulla", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),

                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                        ),

                                                                        Padding(
                                                                          padding: const EdgeInsets.all(10.0),
                                                                          child: ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                              primary: Colors.deepPurple.shade400, // Background color
                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(20.0)
                                                                              ),
                                                                            ),
                                                                            child: Text("Elimina", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),

                                                                            onPressed: () async {

                                                                              http.StreamedResponse response = await deleteTipologia(item.idTipologia);
                                                                              final jsonData3 =  jsonDecode(await response.stream.bytesToString());

                                                                              tipologieClienti.remove(item);
                                                                              if(jsonData3["retCode"]==0){
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  SnackBar(content: Text(jsonData3["retDescr"].toString())),
                                                                                );
                                                                              }else{
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  SnackBar(content: Text("Qualcosa è andato storto durante la cancellazione!")),
                                                                                );
                                                                              }
                                                                              Navigator.of(context).pop();

                                                                              setState((){
                                                                                tableController.refresh();
                                                                              });
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

                            Text("Tipologia cliente",style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),
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

                                            String? nuovoNomeTipologia=null;
                                            return AlertDialog(
                                              backgroundColor: Colors.deepPurple.shade100,
                                              scrollable: true,
                                              content: Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[

                                                    Text("Aggiungi un nuova nuova tipologia cliente",style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black) ),

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
                                                              nuovoNomeTipologia=value;
                                                            },
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                return 'Please enter some text';
                                                              }
                                                              return null;
                                                            },
                                                            decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                hintText: 'Inserisci il nome della tipologia'
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
                                                          padding: const EdgeInsets.all(10.0),
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
                                                                var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Tools/TipologiaClienteMng'));
                                                                request.bodyFields= {
                                                                  "studioId": modello.studioId.toString(),
                                                                  "tipologiaClienteId": "null",
                                                                  "tipologiaClienteDescr": nuovoNomeTipologia!,
                                                                  "tipoOperazione": "I",
                                                                  "utenteId": modello.dipendenteId.toString(),
                                                                };
                                                                request.headers['Authorization'] = 'Bearer $tt';

                                                                http.StreamedResponse response = await request.send();
                                                                response.stream.asBroadcastStream();

                                                                var jsonData=  jsonDecode(await response.stream.bytesToString());

                                                                if (response.statusCode == 200) {
                                                                  Navigator.of(context).pop();
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(content: Text(jsonData["retDescr"].toString())),
                                                                  );
                                                                  print(jsonData);
                                                                }
                                                                else {
                                                                  print(response.reasonPhrase);
                                                                }
                                                                setState((){
                                                                  tableController.refresh();
                                                                });
                                                                nuovoNomeTipologia=null;
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
      ),

    );
  }

}



class TipologiaCliente {

  String nome;
  int idTipologia;
  String? ultimaModifica;
  TipologiaCliente(this.nome, this.idTipologia, [this.ultimaModifica]);

}

