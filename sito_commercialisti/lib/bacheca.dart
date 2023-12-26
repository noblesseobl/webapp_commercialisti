import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
import 'package:sito_commercialisti/Modello.dart';
import 'package:sito_commercialisti/NavBar.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:intl/intl.dart';

class Bacheca extends StatefulWidget {
  Bacheca();

  @override
  State<Bacheca> createState() => BachecaState();
}

class BachecaState extends State<Bacheca> {

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  String? testo;

  Modello modello=Modello();

  final tableController = PagedDataTableController<String, int, MexBacheca>();

  List<MexBacheca> bacheca= [];

  Future<http.StreamedResponse> deletePost(int idPost) async{

    var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Bacheca/BachecaMsgMng'));
    String tt=modello!.token!;

    request.bodyFields = {
        "messaggioId": idPost.toString(),
        "tipoOperazione" : "D",
        "utenteId" :  modello!.codiceUtente!

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

                        child: PagedDataTable<String, int, MexBacheca>(

                          idGetter: (messaggio) => messaggio.idMex,

                          controller: tableController,

                          fetchPage: (pageToken, pageSize, sortBy, filtering) async {

                            bacheca=[];
                            String tt=modello.token!;

                            var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Bacheca/BachecaMessageListGet'));
                            request.bodyFields={
                              "studioId": modello!.studioId.toString(),        //<-- filtro se non null
                              "numMsg": "100",
                              "messaggioId": "null"
                            };
                            request.headers['Authorization'] = 'Bearer $tt';
                            http.StreamedResponse response = await request.send();
                            response.stream.asBroadcastStream();
                            var jsonData=  jsonDecode(await response.stream.bytesToString());
                            if (response.statusCode == 200) {
                              print(jsonData);
                              for(var mex in jsonData){
                                DateTime dataInsert= formatoData(mex["dataInserimento"]);
                                DateTime dataLastUpdate=formatoData(mex["dataUltimaModifica"]);
                                bacheca.add(MexBacheca(mex["titolo"], mex["messaggio"], mex["linkAllegato"], mex["messaggioId"], dataInsert, dataLastUpdate));
                              }
                            }
                            else {
                              print(response.reasonPhrase);
                            }


                            String? filtroCerca=filtering.valueOrNullAs<String>("keyword");

                            List<MexBacheca> rimuovi=[];
                            if(filtroCerca!=null){
                              for(MexBacheca mex in bacheca){
                                if( !(mex.titolo.toLowerCase().contains(filtroCerca.toLowerCase())||
                                    mex.messaggio.toLowerCase().contains(filtroCerca.toLowerCase()))){
                                  rimuovi.add(mex);
                                }
                              }
                            }

                            for(MexBacheca mex in rimuovi){
                              bacheca.remove(mex);
                            }

                            DateTimeRange? between= filtering.valueOrNullAs<DateTimeRange>("periodo");
                            rimuovi=[];

                            if (between != null) {
                              for(MexBacheca mex in bacheca) {
                                if (!(between.start.isBefore(mex.dataInserimento) &&
                                    between.end.isAfter(mex.dataInserimento))) {
                                  bacheca.remove(mex);
                                }
                              }
                            }

                            for(MexBacheca mex in rimuovi){
                              bacheca.remove(mex);
                            }

                            //non so perchè il for each non funziona correttamente,
                            //toglie qualche elemento di troppo dalla lista


                            return PaginationResult.items(elements: bacheca);

                          },

                          initialPage: "",

                          columns:  [
                            TableColumn(
                                title: "Titolo",
                                cellBuilder: (item) =>  Text(item.titolo,  style: TextStyle(overflow: TextOverflow.ellipsis)),
                                sizeFactor: .2),
                            TableColumn(
                                cellBuilder: (item) =>  Text(item.messaggio, overflow: TextOverflow.ellipsis, maxLines: 2,),
                                title: "Descrizione",
                                sizeFactor: .3),
                            TableColumn(
                                title: "Data caricamento",
                                sizeFactor: 0.2,
                                sortable: false,  //true? --> da gestire
                                cellBuilder: (item) =>  Text(item.dataInserimento.day.toString()+"/"+item.dataInserimento.month.toString()+"/"+item.dataInserimento.year.toString()+" alle "+
                                    item.dataInserimento.hour.toString()+":"+item.dataInserimento.minute.toString()+":"+item.dataInserimento.second.toString() )
                            ),
                            TableColumn(
                              title: "              ",
                              sizeFactor: null,
                              cellBuilder: (item) => Row(
                                  children: [
                                    Flexible(
                                        child: Icon(Icons.download, color:  Colors.deepPurple.shade400)  //se c'è un allegato viola, se non c'è allora icona grigia
                                    ),    //download

                                    Flexible(
                                      child: IconButton(
                                          onPressed: (){

                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                                      String nuovoTitolo=item.titolo;
                                                      String nuovoMessaggio=item.messaggio;
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
                                                                  Text("Modifica", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text("Codice id: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),

                                                                  Text("${item.idMex}",  style: TextStyle(fontSize: 12)),
                                                                ],
                                                              ),
                                                              SizedBox(height: 20,),
                                                              Text("Titolo: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                                              SizedBox(height: 5),
                                                              Container(
                                                                decoration:BoxDecoration(
                                                                    color: Colors.blueGrey.shade50,
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    border: Border.all(color: Colors.deepPurple.shade400)
                                                                ),
                                                                child:Padding(
                                                                  padding: const EdgeInsets.only(left: 12),

                                                                  child: TextFormField(
                                                                    initialValue: item.titolo,
                                                                    decoration: InputDecoration(
                                                                        border: InputBorder.none,
                                                                        hintText: item.titolo
                                                                    ),
                                                                    onChanged: (String value) {
                                                                      nuovoTitolo=value;
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
                                                              SizedBox(height: 20,),

                                                              Text("Messaggio: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                                              SizedBox(height: 5),
                                                              Container(
                                                                height: 170,
                                                                width: 500,
                                                                decoration:BoxDecoration(
                                                                    color: Colors.blueGrey.shade50,
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    border: Border.all(color: Colors.deepPurple.shade400)
                                                                ),
                                                                child:TextFormField(
                                                                  initialValue: item.messaggio,
                                                                  decoration: InputDecoration(
                                                                    hintText: item.messaggio,
                                                                    border: InputBorder.none,
                                                                    filled: true,
                                                                  ),
                                                                  keyboardType: TextInputType.multiline,
                                                                  expands: true,
                                                                  maxLines: null,
                                                                  onChanged: (String value) {
                                                                    nuovoMessaggio=value;
                                                                  },
                                                                  validator: (value) {
                                                                    if (value == null || value.isEmpty) {
                                                                      return 'Please enter some text';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                              ),
                                                              SizedBox(height: 20),

                                                              Row(
                                                                children: [
                                                                  Text("Pubblicato il: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                                                  Text("${item.dataInserimento}", style: TextStyle(fontSize: 12)),
                                                                ],
                                                              ),
                                                              SizedBox(height: 10,),

                                                              Row(

                                                                children: [
                                                                  Text("Ultima modifica: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                                                  Text("${item.dataUltimaModifica}", style: TextStyle(fontSize: 12)),
                                                                  Spacer(),
                                                                  ElevatedButton(
                                                                    onPressed:(){
                                                                      //gestione upload nuovo file
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                      primary: Colors.deepPurple.shade400, // Background color
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(20.0)
                                                                      ),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(10.0),
                                                                      child: Row(
                                                                        children: [
                                                                          Text("Seleziona \nnuovo file"),
                                                                          SizedBox(width: 10),
                                                                          Icon(Icons.upload_rounded)
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: 20,),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(5.0),
                                                                    child: ElevatedButton(

                                                                      onPressed:() async {
                                                                        try{

                                                                          var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Bacheca/BachecaMsgMng'));
                                                                          String tt=modello.token!;

                                                                          int mexId=item.idMex!;
                                                                          int usId=modello.dipendenteId!;

                                                                          request.bodyFields = {
                                                                            "messaggioId": mexId.toString(),
                                                                            "titolo": nuovoTitolo,
                                                                            "messaggio" : nuovoMessaggio,
                                                                            "linkAllegato" : "null",
                                                                            "tipoOperazione" : "U",
                                                                            "utenteId" :  usId.toString()
                                                                          };
                                                                          request.headers['Authorization'] = 'Bearer $tt';

                                                                          http.StreamedResponse response = await request.send();
                                                                          response.stream.asBroadcastStream();
                                                                          var jsonData=  jsonDecode(await response.stream.bytesToString());

                                                                          item.titolo= nuovoTitolo;
                                                                          item.messaggio= nuovoMessaggio;


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
                                                                        primary: Colors.deepPurple.shade400,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(20.0)
                                                                        ),
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          Text("Invio"),
                                                                          SizedBox(width: 10,),
                                                                          Icon(Icons.edit)
                                                                        ],
                                                                      ),
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
                                          icon: Icon(Icons.edit, color: Colors.deepPurple.shade400)
                                      ),
                                    ),    //update

                                    Flexible(
                                      child: IconButton(
                                          onPressed: (){
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
                                                                children: <Widget>[
                                                                  SizedBox(height: 20,),
                                                                  Text("Titolo:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                                  SizedBox(height: 10),
                                                                  Text("${item.titolo}"),
                                                                  SizedBox(height: 30,),
                                                                  Text("Messaggio:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                                  SizedBox(height: 10,),
                                                                  Text("${item.messaggio}"),

                                                                  SizedBox(height: 20,),
                                                                  Row(
                                                                    children: [
                                                                      Text("Scritta il: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                                      Text("${item.dataInserimento}", style: TextStyle(fontSize: 12)),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 10,),
                                                                  Row(
                                                                    children: [
                                                                      Text("Ultima modifica: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                                      Text("${item.dataUltimaModifica}",  style: TextStyle( fontSize: 12)),
                                                                    ],
                                                                  ),

                                                                  SizedBox(height: 15,),

                                                                  Row(

                                                                    children: [
                                                                      ElevatedButton(
                                                                        onPressed:(){
                                                                          //gestione download nuovo file
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                          primary: Colors.deepPurple.shade400,
                                                                          shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20.0)
                                                                          ),
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(10.0),
                                                                          child: Row(
                                                                            children: [
                                                                              Text("Download"),
                                                                              SizedBox(width: 10),
                                                                              Icon(Icons.download_rounded)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
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

                                                                  Text("Sei sicuro di voler eliminare questo post?",style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),

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
                                                                            http.StreamedResponse response=await deletePost(item.idMex);
                                                                            final jsonData = jsonDecode(await response.stream.bytesToString());
                                                                            bacheca.remove(item);

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
                                    )      //delete

                                  ]),
                            ),
                          ],

                          filters: [
                            TextTableFilter(
                                id: "keyword",
                                title: "Cerca",
                                chipFormatter: (text) => "$text"),

                            DateRangePickerTableFilter(
                              id: "periodo",
                              title: "Periodo",
                              chipFormatter: (date) =>
                              'Tra il ${DateFormat.yMd().format(date.start)} e il ${DateFormat.yMd().format(date.end)}',
                              firstDate: DateTime(2000, 1, 1),
                              lastDate: DateTime.now(),
                            )

                          ],

                        )
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

                            Text("Bacheca",style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),
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
                                            String? nuovoTitolo=null;
                                            String? nuovoMessaggio=null;

                                            return AlertDialog(
                                              backgroundColor: Colors.deepPurple.shade100,
                                              scrollable: true,
                                              content: Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[

                                                    Text("Aggiungi un nuovo post", style:TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black)),
                                                    SizedBox(height: 30),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                      child: Container(
                                                        decoration:BoxDecoration(
                                                            color: Colors.blueGrey.shade50,
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(color: Colors.deepPurple.shade400)
                                                        ),
                                                        child:Padding(
                                                          padding: const EdgeInsets.only(left: 12),

                                                          child: TextFormField(
                                                            decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                hintText: 'Inserisci titolo'
                                                            ),
                                                            onChanged: (String value) {
                                                              nuovoTitolo=value;
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
                                                    Padding(
                                                      padding: const EdgeInsets.all( 5.0),
                                                      child: Container(
                                                        height: 170,
                                                        width: 500,
                                                        decoration:BoxDecoration(
                                                            color: Colors.blueGrey.shade50,
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(color: Colors.deepPurple.shade400)
                                                        ),
                                                        child:TextFormField(

                                                          decoration: InputDecoration(
                                                            hintText: 'Inserisci descrizione',
                                                            border: InputBorder.none,
                                                            filled: true,
                                                          ),
                                                          keyboardType: TextInputType.multiline,
                                                          expands: true,
                                                          maxLines: null,
                                                          onChanged: (String value) {
                                                            nuovoMessaggio=value;
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

                                                    SizedBox(height: 30),
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

                                                                //qui gestire i file e il file picker
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              primary: Colors.deepPurple.shade400,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20.0)
                                                              ),
                                                            ),
                                                            child: Text("Pubblica"),

                                                            onPressed: () async {
                                                              try {
                                                                if (_formKey.currentState!.validate()) {
                                                                  _formKey.currentState!.save();
                                                                }

                                                                String tt=modello.token!;
                                                                var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Bacheca/BachecaMsgMng'));
                                                                request.bodyFields = {
                                                                  "studioId" : modello.studioId.toString(),
                                                                  "titolo": nuovoTitolo!,
                                                                  "messaggio" : nuovoMessaggio!,
                                                                  "linkAllegato" : "null",            //da sistemare il file da mandare.
                                                                  "tipoOperazione" : "I",
                                                                  "utenteId" :  modello.codiceUtente.toString()
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

                                                                  nuovoMessaggio=null;
                                                                  nuovoTitolo=null;
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

  DateTime formatoData(String data){
    //gestione date
    //2023-12-18T12:43:07.57

    int year= int.parse(data.substring(0,4));
    int month= int.parse(data.substring(5,7));
    int day= int.parse(data.substring(8,10));
    int hour= int.parse(data.substring(11,13));
    int minute= int.parse(data.substring(14,16));
    int second= int.parse(data.substring(17,19));
    //
    // print (year);
    // print (month);
    // print (day);
    // print (hour);
    // print (minute);
    // print (second);

    return DateTime(year, month, day, hour, minute, second);
  }


}



class MexBacheca {

  String titolo;
  String messaggio;
  String? linkAllegato;
  int idMex;
  DateTime dataInserimento;
  DateTime dataUltimaModifica;

  MexBacheca(this.titolo, this.messaggio, this.linkAllegato, this.idMex,
      this.dataInserimento, this.dataUltimaModifica);

}


