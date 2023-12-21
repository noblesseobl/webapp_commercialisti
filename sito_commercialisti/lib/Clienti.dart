import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
import 'package:sito_commercialisti/Modello.dart';
import 'package:sito_commercialisti/NavBar.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:http/http.dart' as http;
import 'package:sito_commercialisti/TipologiaCliente.dart';

class Clienti extends StatefulWidget {
  Clienti();

  @override
  State<Clienti> createState() => ClientiState();

}



class ClientiState extends State<Clienti> {

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final tableController = PagedDataTableController<String, int, Cliente>();
  PagedDataTableThemeData? theme;

  List<Cliente> clienti=[];

  Modello modello=Modello();

  List<TipologiaCliente> tipoClienti=[];
  List<DipendenteDesignato> dipendentiDesignati=[];

  TipologiaCliente? dropdownValue;
  TipologiaCliente? get $dropdownValue => null;

  TipologiaCliente? dropdownValue2;
  TipologiaCliente? get $dropdownValue2 => null;


  void categorieClienti() async {

    var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Tools/TipologiaClienteListGet'));
    String tt=modello.token!;
    request.bodyFields = {
      "studioId": modello!.studioId.toString(),
      "tipologiaClienteId": "null"};

    request.headers['Authorization'] = 'Bearer $tt';

    http.StreamedResponse response = await request.send();
    response.stream.asBroadcastStream();

    var jsonData=  jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(jsonData);

      for(var mex in jsonData){
        tipoClienti.add(TipologiaCliente(mex["tipologiaClienteDescr"], mex["tipologiaClienteId"], mex["dataUltimaModifica"]));
      }
    }
    else {
      print(response.reasonPhrase);
    }
    dropdownValue= tipoClienti.first;
  }

  void dipendentiGet() async {

    //gestisci utenti non super admin

    var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Dipendente/DipendenteListGet'));
    String tt=modello.token!;

    request.bodyFields={
      "dipendenteId" : "null",
      "ufficioId": modello!.ufficioId.toString()
    };

    request.headers['Authorization'] = 'Bearer $tt';

    http.StreamedResponse response = await request.send();

    response.stream.asBroadcastStream();

    var jsonData=  jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(jsonData);
      for(var dip in jsonData){
        if(dip["superUser"]==false) {
          dipendentiDesignati.add(DipendenteDesignato(
              false, dip["dipendenteNome"], dip["dipendenteCognome"],
              dip["dipendenteId"]));
        }
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future<http.StreamedResponse> deleteCliente(int idCliente) async{

    String tt=modello!.token!;
    var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Cliente/ClienteMng'));
    request.bodyFields = {
      "clienteId" :idCliente.toString(),
      "tipoOperazione": "D",
      "utenteId": modello.dipendenteId.toString()
    };
    request.headers['Authorization'] = 'Bearer $tt';
    return request.send();

  }

  Future<List<DipendenteDesignato>> getDipendentiPerCliente(int idCliente) async{

    String tt=modello.token!;
    var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Cliente/ClienteListGet'));
    request.bodyFields = {
      "studioId": modello.studioId.toString(),
      "clienteId": idCliente.toString(),
      "tipologiaClienteId": "null"
    };
    request.headers['Authorization'] = 'Bearer $tt';

    http.StreamedResponse response = await request.send();
    response.stream.asBroadcastStream();
    var jsonData=  jsonDecode(await response.stream.bytesToString());

    var inspect = jsonData['Dipendente'];
    List<DipendenteDesignato> dd=[];

    if (response.statusCode == 200) {
      for(var dip in inspect){
        dd.add(DipendenteDesignato(false, dip["dipendenteNome"], dip["dipendenteCognome"], dip["dipendenteId"]));
      }
    }
    else {
      print(response.reasonPhrase);
    }

    return dd;
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

                          dipendentiDesignati=[];
                          dipendentiGet();
                          tipoClienti=[];
                          categorieClienti();

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
                            sizeFactor: .1
                          ),

                          TableColumn(
                            id: "email",
                            title: "Email",
                            cellBuilder: (item)=> Text(item.email),
                            sizeFactor: .15
                          ),

                          TableColumn(
                            id: "telefono",
                            title: "Telefono",
                            cellBuilder: (item)=> Text(item.telefono),
                            sizeFactor: .1
                          ),

                          TableColumn(
                            id: "tipologia",
                            title: "Tipologia",
                            cellBuilder: (item)=> Text(item.tipologiaClienteDescr),
                            sizeFactor: .1
                          ),

                          TableColumn(
                            title: "              ",
                            sizeFactor: .25,
                            cellBuilder: (item) => Row(
                                children: [

                                  Flexible(
                                    child: IconButton(
                                        onPressed: (){

                                          String? nuovoCodiceUtente;
                                          String? nuovoNome;
                                          String? nuovoCognome;
                                          String? nuovaEmail;
                                          String? nuovoNumero;
                                          String? nuovaTipologia;


                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
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
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  SizedBox(width: 170,),
                                                                  Text("Modifica", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                                  SizedBox(width: 170,)
                                                                ],
                                                              ),

                                                              SizedBox(height: 20,),
                                                              Text("Codice cliente: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                                              SizedBox(height: 5),
                                                              Container(
                                                                margin: EdgeInsets.only(right: 100),
                                                                decoration:BoxDecoration(
                                                                    color: Colors.blueGrey.shade50,
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    border: Border.all(color: Colors.deepPurple.shade400)
                                                                ),
                                                                child:Padding(
                                                                  padding: const EdgeInsets.only(left: 12),

                                                                  child: TextFormField(
                                                                    initialValue: item.codiceCliente,
                                                                    decoration: InputDecoration(
                                                                        border: InputBorder.none,
                                                                        hintText: item.codiceCliente
                                                                    ),
                                                                    onChanged: (String value) {
                                                                      nuovoCodiceUtente=value;
                                                                    },
                                                                    validator: (value) {
                                                                      if (value == null || value.isEmpty) {
                                                                        return 'Please enter some text';
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10,),

                                                              Text("Nome: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                                              SizedBox(height: 5),
                                                              Container(
                                                                margin: EdgeInsets.only(right: 100),
                                                                decoration:BoxDecoration(
                                                                    color: Colors.blueGrey.shade50,
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    border: Border.all(color: Colors.deepPurple.shade400)
                                                                ),
                                                                child:Padding(
                                                                  padding: const EdgeInsets.only(left: 12),

                                                                  child: TextFormField(
                                                                    initialValue: item.clienteNome,
                                                                    decoration: InputDecoration(
                                                                        border: InputBorder.none,
                                                                        hintText: item.clienteNome
                                                                    ),
                                                                    onChanged: (String value) {
                                                                      nuovoNome=value;
                                                                    },
                                                                    validator: (value) {
                                                                      if (value == null || value.isEmpty) {
                                                                        return 'Please enter some text';
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10,),
                                                              Text("Cognome: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                                              SizedBox(height: 5),
                                                              Container(
                                                                margin: EdgeInsets.only(right: 100),
                                                                decoration:BoxDecoration(
                                                                    color: Colors.blueGrey.shade50,
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    border: Border.all(color: Colors.deepPurple.shade400)
                                                                ),
                                                                child:Padding(
                                                                  padding: const EdgeInsets.only(left: 12),

                                                                  child: TextFormField(
                                                                    initialValue: item.clienteCognome,
                                                                    decoration: InputDecoration(
                                                                        border: InputBorder.none,
                                                                        hintText: item.clienteCognome
                                                                    ),
                                                                    onChanged: (String value) {
                                                                      nuovoCognome=value;
                                                                    },
                                                                    validator: (value) {
                                                                      if (value == null || value.isEmpty) {
                                                                        return 'Please enter some text';
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10,),
                                                              Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                                              SizedBox(height: 5),
                                                              Container(
                                                                margin: EdgeInsets.only(right: 100),
                                                                decoration:BoxDecoration(
                                                                    color: Colors.blueGrey.shade50,
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    border: Border.all(color: Colors.deepPurple.shade400)
                                                                ),
                                                                child:Padding(
                                                                  padding: const EdgeInsets.only(left: 12),

                                                                  child: TextFormField(
                                                                    initialValue: item.email,
                                                                    decoration: InputDecoration(
                                                                        border: InputBorder.none,
                                                                        hintText: item.email
                                                                    ),
                                                                    onChanged: (String value) {
                                                                      nuovaEmail=value;
                                                                    },
                                                                    validator: (value) {
                                                                      if (value == null || value.isEmpty) {
                                                                        return 'Please enter some text';
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10,),
                                                              Text("Numero: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                                              SizedBox(height: 5),
                                                              Container(
                                                                margin: EdgeInsets.only(right: 100),
                                                                decoration:BoxDecoration(
                                                                    color: Colors.blueGrey.shade50,
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    border: Border.all(color: Colors.deepPurple.shade400)
                                                                ),
                                                                child:Padding(
                                                                  padding: const EdgeInsets.only(left: 12),

                                                                  child: TextFormField(
                                                                    initialValue: item.telefono,
                                                                    decoration: InputDecoration(
                                                                        border: InputBorder.none,
                                                                        hintText: item.telefono
                                                                    ),
                                                                    onChanged: (String value) {
                                                                      nuovoNumero=value;
                                                                    },
                                                                    validator: (value) {
                                                                      if (value == null || value.isEmpty) {
                                                                        return 'Please enter some text';
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10,),

                                                              Text("Tipologia: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                                              SizedBox(height: 5),
                                                              Container(
                                                                decoration:BoxDecoration(
                                                                    color: Colors.blueGrey.shade50,
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    border: Border.all(color: Colors.deepPurple.shade400)
                                                                ),
                                                                child:Padding(
                                                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                                                  child: DropdownButtonHideUnderline(
                                                                    child: DropdownButton<TipologiaCliente>(
                                                                        items: tipoClienti!.map<DropdownMenuItem<TipologiaCliente>>(
                                                                                (TipologiaCliente value) {
                                                                              return DropdownMenuItem<TipologiaCliente>(
                                                                                child: Text(value.nome, style: TextStyle(color: Colors.black),),
                                                                                value: value,
                                                                              );
                                                                            }).toList(),
                                                                        value: dropdownValue2,
                                                                        iconEnabledColor: Colors.deepPurple.shade400,
                                                                        iconDisabledColor: Colors.deepPurple.shade400,
                                                                        //isExpanded: true,
                                                                        icon: const Icon(Icons.arrow_downward),
                                                                        elevation: 16,
                                                                        style:
                                                                        TextStyle(color: Colors.blueGrey.shade700, fontSize: 15),
                                                                        underline: Container(
                                                                          width: 100,
                                                                          height: 2,
                                                                          color: Colors.deepPurple.shade400,
                                                                        ),
                                                                        onChanged: (TipologiaCliente? value) {
                                                                          setState(() {
                                                                            dropdownValue2 = value;
                                                                            print(dropdownValue2);
                                                                          });
                                                                        }),),),),

                                                              SizedBox(height: 20),


                                                              //dipendenti designati
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                child: Text(
                                                                  "Scegli i dipendenti designati: ",
                                                                  style: TextStyle(fontSize: 16,color: Colors.black, fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10),
                                                              Divider(),
                                                              SizedBox(height: 5),


                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                child: Column(
                                                                    children: dipendentiDesignati2.map((favorite) {
                                                                      return CheckboxListTile(
                                                                          activeColor: Colors.deepPurple.shade400,
                                                                          checkboxShape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(5)),
                                                                          value: favorite.isChecked,
                                                                          title: Text(favorite.dipendenteNome+ " "+favorite.dipendenteCognome),
                                                                          onChanged: (val) {
                                                                            setState(() {
                                                                              favorite.isChecked = val!;
                                                                            });
                                                                          });
                                                                    }).toList()),
                                                              ),
                                                              SizedBox(height: 5),
                                                              Divider(),
                                                              Wrap(
                                                                children: dipendentiDesignati2.map((favorite) {
                                                                  if (favorite.isChecked == true) {
                                                                    return Card(
                                                                      elevation: 3,
                                                                      color: Colors.deepPurple.shade400,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Row(
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: [
                                                                            Text(
                                                                              favorite.dipendenteNome+" "+favorite.dipendenteCognome,
                                                                              style: const TextStyle(color: Colors.white),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  favorite.isChecked = !favorite.isChecked;
                                                                                });
                                                                              },
                                                                              child: const Icon(
                                                                                Icons.delete_forever_rounded,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                  return Container();
                                                                }).toList() ,
                                                              ),

                                                              SizedBox(height: 50),


                                                              // SizedBox(height: 20,),
                                                              // Row(
                                                              //   mainAxisAlignment: MainAxisAlignment.start,
                                                              //   children: [
                                                              //     Padding(
                                                              //       padding: const EdgeInsets.all(5.0),
                                                              //       child: ElevatedButton(
                                                              //
                                                              //         onPressed:() async {
                                                              //           try{
                                                              //
                                                              //             var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Bacheca/BachecaMsgMng'));
                                                              //             String tt=modello.token!;
                                                              //
                                                              //             int mexId=item.idMex!;
                                                              //             int usId=modello.dipendenteId!;
                                                              //
                                                              //             request.bodyFields = {
                                                              //               "messaggioId": mexId.toString(),
                                                              //               "titolo": nuovoTitolo,
                                                              //               "messaggio" : nuovoMessaggio,
                                                              //               "linkAllegato" : "null",
                                                              //               "tipoOperazione" : "U",
                                                              //               "utenteId" :  usId.toString()
                                                              //             };
                                                              //             request.headers['Authorization'] = 'Bearer $tt';
                                                              //
                                                              //             http.StreamedResponse response = await request.send();
                                                              //             response.stream.asBroadcastStream();
                                                              //             var jsonData=  jsonDecode(await response.stream.bytesToString());
                                                              //
                                                              //             item.titolo= nuovoTitolo;
                                                              //             item.messaggio= nuovoMessaggio;
                                                              //
                                                              //
                                                              //             if (jsonData["retCode"]==0) {
                                                              //               print(jsonData);
                                                              //               ScaffoldMessenger.of(context).showSnackBar(
                                                              //                 SnackBar(content: Text(jsonData["retDescr"].toString())),
                                                              //               );
                                                              //             }
                                                              //             else {
                                                              //               ScaffoldMessenger.of(context).showSnackBar(
                                                              //                 SnackBar(content: Text("Qualcosa è andato storto durante l'update!")),
                                                              //               );
                                                              //             }
                                                              //             Navigator.of(context).pop();
                                                              //             setState((){
                                                              //               tableController.refresh();
                                                              //             });
                                                              //           }catch(er){
                                                              //             print(er);
                                                              //             ScaffoldMessenger.of(context).showSnackBar(
                                                              //               const SnackBar(content: Text('Errore del Server!')),
                                                              //             );
                                                              //           }
                                                              //         },
                                                              //         style: ElevatedButton.styleFrom(
                                                              //           primary: Colors.deepPurple.shade400,
                                                              //           shape: RoundedRectangleBorder(
                                                              //               borderRadius: BorderRadius.circular(20.0)
                                                              //           ),
                                                              //         ),
                                                              //         child: Row(
                                                              //           children: [
                                                              //             Text("Invio"),
                                                              //             SizedBox(width: 10,),
                                                              //             Icon(Icons.edit)
                                                              //           ],
                                                              //         ),
                                                              //       ),
                                                              //     ),
                                                              //
                                                              //
                                                              //
                                                              //   ],
                                                              // )


                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                );
                                              }

                                          );
                                        },
                                        icon: Icon(Icons.edit, color: Colors.deepPurple.shade400)
                                    ),
                                  ),    //update

                                  Flexible(
                                    child: IconButton(
                                        onPressed: () async {

                                          List<DipendenteDesignato> dd= await getDipendentiPerCliente(item.clienteId);

                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                                      return AlertDialog(
                                                        backgroundColor: Colors.deepPurple.shade100,
                                                        scrollable: true,
                                                        content: Form(
                                                          key: _formKey,
                                                          child: Row(
                                                            children: [
                                                              SizedBox(width: 20),
                                                              Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(height: 20,),
                                                                  Row(
                                                                    children: [
                                                                      Text("Codice utente: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                                                      Text("${item.codiceCliente}", style: TextStyle(fontSize: 18)),
                                                                    ],
                                                                  ),

                                                                  SizedBox(height: 20,),
                                                                  Row(
                                                                    children: [
                                                                      Text("Nome: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                                                      Text("${item.clienteNome+" "+item.clienteCognome}", style: TextStyle( fontSize: 18)),
                                                                    ],
                                                                  ),


                                                                  SizedBox(height: 20,),
                                                                  Row(
                                                                    children: [
                                                                      Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                                                      Text("${item.email}", style: TextStyle(fontSize: 18)),
                                                                    ],
                                                                  ),

                                                                  SizedBox(height: 20,),
                                                                  Row(
                                                                    children: [
                                                                      Text("Telefono: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                                                      Text("${item.telefono}",  style: TextStyle( fontSize: 18)),
                                                                    ],
                                                                  ),

                                                                  SizedBox(height: 20),
                                                                  Row(
                                                                    children: [
                                                                      Text("Tipologia cliente: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                                                      Text("${item.tipologiaClienteDescr}",  style: TextStyle( fontSize: 18)),
                                                                    ],
                                                                  ),

                                                                  SizedBox(height: 20,),
                                                                  Text("Seguito da: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                                                  SizedBox(height: 10,),
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children:  dd.map((e) { return Text("- ${e.dipendenteNome+" "+e.dipendenteCognome}", style: TextStyle(fontSize: 18),);}).toList(),
                                                                  ),


                                                                  SizedBox(height: 20,),

                                                                ],
                                                              ),
                                                              SizedBox(width: 20),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                );
                                              }
                                          );
                                        },
                                        icon: Icon(Icons.remove_red_eye, color: Colors.deepPurple.shade400)
                                    ),
                                  ),    //read

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

                                                                  Text("Sei sicuro di voler eliminare questo cliente?",style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),

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
                                                                            primary: Colors.deepPurple.shade400,
                                                                            shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(20.0)
                                                                            ),
                                                                          ),
                                                                          child: Text("Elimina", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),

                                                                          onPressed: () async {
                                                                            http.StreamedResponse response=await deleteCliente(item.clienteId);

                                                                            final jsonData = jsonDecode(await response.stream.bytesToString());
                                                                            clienti.remove(item);

                                                                            if(jsonData["retCode"]==0){
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(content: Text(jsonData["retDescr"].toString())),
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


                                          },
                                          icon: Icon(Icons.delete, color: Colors.deepPurple.shade400)
                                      )
                                  )     //delete

                                ]),
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

                              String? nuovoCodiceCliente;
                              String? nuovoNome;
                              String? nuovoCognome;
                              String? nuovaMail;
                              String? nuovoTelefono;

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (BuildContext context, StateSetter setState) {


                                          return AlertDialog(
                                            contentPadding: const EdgeInsets.fromLTRB(40, 30, 100 ,30),
                                            backgroundColor: Colors.deepPurple.shade100,
                                            scrollable: true,
                                            content: Form(
                                              key: _formKey,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,

                                                children: <Widget>[
                                                  Text("Aggiungi un nuovo cliente", style:TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black)),
                                                  SizedBox(height: 30),

                                                  //codice utente
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                    child: Container(
                                                      decoration:BoxDecoration(
                                                          color: Colors.blueGrey.shade50,
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(color: Colors.deepPurple.shade400)
                                                      ),
                                                      child:Padding(
                                                        padding: const EdgeInsets.only(left: 12),

                                                        child: TextFormField(
                                                          decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              hintText: 'Codice cliente'
                                                          ),
                                                          onChanged: (String value) {
                                                            nuovoCodiceCliente=value;
                                                          },
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Please enter some text';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),

                                                  //nome
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                    child: Container(
                                                      decoration:BoxDecoration(
                                                          color: Colors.blueGrey.shade50,
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(color: Colors.deepPurple.shade400)
                                                      ),
                                                      child:Padding(
                                                        padding: const EdgeInsets.only(left: 12),

                                                        child: TextFormField(
                                                          decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              hintText: 'Nome'
                                                          ),
                                                          onChanged: (String value) {
                                                            nuovoNome=value;
                                                          },
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Please enter some text';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),

                                                  //cognome
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                    child: Container(
                                                      decoration:BoxDecoration(
                                                          color: Colors.blueGrey.shade50,
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(color: Colors.deepPurple.shade400)
                                                      ),
                                                      child:Padding(
                                                        padding: const EdgeInsets.only(left: 12),

                                                        child: TextFormField(
                                                          decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              hintText: 'Cognome'
                                                          ),
                                                          onChanged: (String value) {
                                                            nuovoCognome=value;
                                                          },
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Please enter some text';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),

                                                  //email
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Container(
                                                      decoration:BoxDecoration(
                                                          color: Colors.blueGrey.shade50,
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(color: Colors.deepPurple.shade400)
                                                      ),
                                                      child:Padding(
                                                        padding: const EdgeInsets.only(left: 12),

                                                        child: TextFormField(
                                                          decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              hintText: 'Email'
                                                          ),
                                                          onChanged: (String value) {
                                                            nuovaMail=value;
                                                          },
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Please enter some text';
                                                            }
                                                            else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value) ){
                                                              return 'Please enter a valid email';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  //telefono
                                                  SizedBox(height: 10),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                    child: Container(
                                                      decoration:BoxDecoration(
                                                          color: Colors.blueGrey.shade50,
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(color: Colors.deepPurple.shade400)
                                                      ),
                                                      child:Padding(
                                                        padding: const EdgeInsets.only(left: 12),

                                                        child: TextFormField(
                                                          decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              hintText: 'Telefono'
                                                          ),
                                                          onChanged: (String value) {
                                                            nuovoTelefono=value;
                                                          },
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Please enter some text';
                                                            }
                                                            else if (!RegExp(r"^[0-9]+").hasMatch(value) ){
                                                              return 'Please enter a valid number';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  //tipologia cliente
                                                  SizedBox(height: 10),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Container(
                                                      decoration:BoxDecoration(
                                                          color: Colors.blueGrey.shade50,
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(color: Colors.deepPurple.shade400)
                                                      ),
                                                      child:Padding(
                                                        padding: const EdgeInsets.only(left: 10, right: 10),
                                                        child: DropdownButtonHideUnderline(
                                                          child: DropdownButton<TipologiaCliente>(
                                                              items: tipoClienti!.map<DropdownMenuItem<TipologiaCliente>>(
                                                                      (TipologiaCliente value) {
                                                                    return DropdownMenuItem<TipologiaCliente>(
                                                                      child: Text(value.nome, style: TextStyle(color: Colors.black),),
                                                                      value: value,
                                                                    );
                                                                  }).toList(),
                                                              value: dropdownValue,
                                                              iconEnabledColor: Colors.deepPurple.shade400,
                                                              iconDisabledColor: Colors.deepPurple.shade400,
                                                              //isExpanded: true,
                                                              icon: const Icon(Icons.arrow_downward),
                                                              elevation: 16,
                                                              style:
                                                              TextStyle(color: Colors.blueGrey.shade700, fontSize: 15),
                                                              underline: Container(
                                                                width: 100,
                                                                height: 2,
                                                                color: Colors.deepPurple.shade400,
                                                              ),
                                                              onChanged: (TipologiaCliente? value) {
                                                                setState(() {
                                                                  dropdownValue = value;
                                                                  print(dropdownValue);
                                                                });
                                                              }),),),),
                                                  ),

                                                  //dipendenti designati
                                                  SizedBox(height: 20),

                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                    child: Text(
                                                      "Scegli i dipendenti designati: ",
                                                      style: TextStyle(fontSize: 16,color: Colors.black, fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Divider(),
                                                  SizedBox(height: 5),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Column(
                                                        children: dipendentiDesignati.map((favorite) {
                                                          return CheckboxListTile(
                                                              activeColor: Colors.deepPurple.shade400,
                                                              checkboxShape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(5)),
                                                              value: favorite.isChecked,
                                                              title: Text(favorite.dipendenteNome+ " "+favorite.dipendenteCognome),
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  favorite.isChecked = val!;
                                                                });
                                                              });
                                                        }).toList()),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Divider(),
                                                  Wrap(
                                                    children: dipendentiDesignati.map((favorite) {
                                                      if (favorite.isChecked == true) {
                                                        return Card(
                                                          elevation: 3,
                                                          color: Colors.deepPurple.shade400,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Text(
                                                                  favorite.dipendenteNome+" "+favorite.dipendenteCognome,
                                                                  style: const TextStyle(color: Colors.white),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      favorite.isChecked = !favorite.isChecked;
                                                                    });
                                                                  },
                                                                  child: const Icon(
                                                                    Icons.delete_forever_rounded,
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      return Container();
                                                    }).toList() ,
                                                  ),

                                                  ////////////////////////

                                                  SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            primary: Colors.deepPurple.shade400,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10)
                                                            ),
                                                          ),
                                                          child: Text("Aggiungi"),

                                                          onPressed: () async {
                                                            try{

                                                              if (_formKey.currentState!.validate()) {
                                                                _formKey.currentState!.save();
                                                              }
                                                              String tt=modello.token!;

                                                              String idDipDes="";
                                                              for (var dip in dipendentiDesignati){
                                                                if(dip.isChecked){
                                                                  idDipDes=idDipDes+dip.dipendenteId.toString()+"|";
                                                                }
                                                              }

                                                              var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Cliente/ClienteMng'));
                                                              request.bodyFields = {
                                                                "clienteId" : "null",
                                                                "codiceCliente": nuovoCodiceCliente!,
                                                                "studioId": modello.studioId.toString(),
                                                                "clienteNome": nuovoNome!,
                                                                "clienteCognome":nuovoCognome!,
                                                                "email":nuovaMail!,
                                                                "telefono": nuovoTelefono!,
                                                                "tipologiaClienteId": dropdownValue!.idTipologia.toString(),
                                                                "dipIds": idDipDes,
                                                                "tipoOperazione": "I",
                                                                "utenteId": modello.dipendenteId.toString()
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
                                                                setState((){
                                                                  tableController.refresh();
                                                                });
                                                                print(jsonData);

                                                              }
                                                              else {
                                                                print(response.reasonPhrase);
                                                              }


                                                            }catch(e){
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                const SnackBar(content: Text('Errore!')),
                                                              );
                                                              print(e);
                                                            }
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),

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
              ]
            ),
        ),
    );
  }

}

class DipendenteDesignato {
  bool isChecked;
  String dipendenteNome;
  String dipendenteCognome;
  int dipendenteId;

  DipendenteDesignato(this.isChecked, this.dipendenteNome,
      this.dipendenteCognome, this.dipendenteId);
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


