import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
import 'package:sito_commercialisti/Modello.dart';
import 'package:sito_commercialisti/NavBar.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:intl/intl.dart';
import 'Post.dart';

class Bacheca extends StatefulWidget {
  Bacheca();

  @override
  State<Bacheca> createState() => BachecaState();
}

class BachecaState extends State<Bacheca> {

  final _formKey = GlobalKey<FormState>();

  String? testo;

  Modello modello=Modello();

  final tableController = PagedDataTableController<String, int, MexBacheca>();

  //PagedDataTableThemeData? theme;

  List<MexBacheca> bacheca= [];

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

                        child: PagedDataTable<String, int, MexBacheca>( //metti Messaggio
                          //rowsSelectable: true,
                          //theme: theme,
                          idGetter: (messaggio) => messaggio.idMex,

                          controller: tableController,

                          fetchPage: (pageToken, pageSize, sortBy, filtering) async {

                            bacheca=[];
                            String tt=modello.token!;

                            var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Bacheca/BachecaMessageListGet'));
                            request.bodyFields={
                              "studioId": modello!.studioId.toString(),        //<-- filtro se non null
                              "numMsg": "20",
                              "messaggioId": "null"
                            };
                            request.headers['Authorization'] = 'Bearer $tt';

                            http.StreamedResponse response = await request.send();
                            response.stream.asBroadcastStream();
                            var jsonData=  jsonDecode(await response.stream.bytesToString());

                            if (response.statusCode == 200) {
                              print(jsonData);
                              for(var mex in jsonData){
                                bacheca.add(MexBacheca(mex["titolo"], mex["messaggio"], mex["linkAllegato"], mex["messaggioId"], mex["dataInserimento"], mex["dataUltimaModifica"]));
                              }
                            }
                            else {
                              print(response.reasonPhrase);
                            }

                            return PaginationResult.items(elements: bacheca);

                            // if (filtering.valueOrNull("authorName") == "error!") {
                            //   throw Exception("This is an unexpected error, wow!");
                            // }
                            //
                            // var result = await PostsRepository.getPosts(
                            //     pageSize: pageSize,
                            //     pageToken: pageToken,
                            //     sortBy: sortBy?.columnId,
                            //     sortDescending: sortBy?.descending ?? false,
                            //     gender: filtering.valueOrNullAs<Gender>("gender"),
                            //     authorName: filtering.valueOrNullAs<String>("authorName"),
                            //     between: filtering.valueOrNullAs<DateTimeRange>("betweenDate"));
                            // return PaginationResult.items(
                            //     elements: result.items, nextPageToken: result.nextPageToken);
                          },

                          initialPage: "",

                          columns:  [
                            LargeTextTableColumn(
                                title: "Titolo",
                                getter: (post) => post.titolo,
                                setter: (post, newContent, rowIndex) async {
                                  await Future.delayed(const Duration(seconds: 1));
                                  post.titolo = newContent;
                                  return true;
                                },
                                sizeFactor: .3),
                            LargeTextTableColumn(
                                title: "Descrizione",
                                getter: (post) => post.messaggio,
                                setter: (post, newContent, rowIndex) async {
                                  await Future.delayed(const Duration(seconds: 1));
                                  post.messaggio = newContent;
                                  return true;
                                },
                                sizeFactor: .3),
                            TableColumn(
                                title: "Data caricamento",
                                sortable: false, //true? --> da gestire
                                cellBuilder: (item) =>  Text(item.dataInserimento)),

                            TableColumn(
                              title: "              ",
                              sizeFactor: null,
                              cellBuilder: (item) => Row(
                                  children: [
                                    Flexible(
                                        child:IconButton(
                                            onPressed: (){
                                              print(item.id);
                                              },
                                            icon: Icon(Icons.download, color: Colors.deepPurple.shade400)
                                        )
                                    ),

                                    Flexible(
                                      child: IconButton(
                                          onPressed: (){
                                            //print(item.content);
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
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                                child: Container(
                                                                  decoration:BoxDecoration(
                                                                      color: Colors.blueGrey.shade50,
                                                                      borderRadius: BorderRadius.circular(15),
                                                                      border: Border.all(color: Colors.deepPurple.shade400)
                                                                  ),
                                                                  child:Padding(
                                                                      padding: const EdgeInsets.only(left: 12, right: 12),

                                                                      child: Text(item.content)
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10,),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                                child: Container(
                                                                  height: 170,
                                                                  decoration:BoxDecoration(
                                                                      color: Colors.blueGrey.shade50,
                                                                      borderRadius: BorderRadius.circular(15),
                                                                      border: Border.all(color: Colors.deepPurple.shade400)
                                                                  ),
                                                                  child:Padding(
                                                                      padding: const EdgeInsets.only(left: 12, right: 12),
                                                                      child: Text(item.content)

                                                                  ),
                                                                ),
                                                              ),

                                                              SizedBox(height: 30,),

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
                                    ),

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
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Text("Titolo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                              Text("${item.content}"),
                                                              SizedBox(height: 20,),
                                                              Text("Descrizione", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                              Text("${item.content}"),
                                                              SizedBox(height: 20,),

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
                                    ),

                                    Flexible(
                                        child:IconButton(
                                            onPressed: (){
                                              print(item.id);
                                              tableController.removeRow(item.id);
                                            },
                                            icon: Icon(Icons.delete, color: Colors.deepPurple.shade400)
                                        )
                                    )

                                  ]),
                            ),
                          ],

                          filters: [
                            TextTableFilter(
                                id: "titolo",
                                title: "Titolo",
                                chipFormatter: (text) => "By $text"),

                            DatePickerTableFilter(
                              id: "data",
                              title: "Data",
                              chipFormatter: (date) => 'Solo il giorno: ${DateFormat.yMd().format(date)}',
                              firstDate: DateTime(2000, 1, 1),
                              lastDate: DateTime.now(),
                            ),
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
                                shape: CircleBorder( ),
                              ),

                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            //return popUp();
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


  AlertDialog popUp(){
  return AlertDialog(
    backgroundColor: Colors.deepPurple.shade100,
    scrollable: true,
    content: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci testo!';
                  }
                  testo=value;
                  return null;
                },
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



class MexBacheca {

  String titolo;
  String messaggio;
  String? linkAllegato;
  int idMex;
  String dataInserimento;
  String dataUltimaModifica;

  MexBacheca(this.titolo, this.messaggio, this.linkAllegato, this.idMex,
      this.dataInserimento, this.dataUltimaModifica);

}



// const kCustomPagedDataTableTheme = PagedDataTableThemeData(
//     rowColors: [
//       Color(0xFFC4E6E3),
//       Color(0xFFE5EFEE),
//     ],
//     backgroundColor: Color(0xFFE0F2F1),
//     headerBackgroundColor: Color(0xFF80CBC4),
//     filtersHeaderBackgroundColor: Color(0xFF80CBC4),
//     footerBackgroundColor: Color(0xFF80CBC4),
//     footerTextStyle: TextStyle(color: Colors.white),
//     textStyle: TextStyle(fontWeight: FontWeight.normal),
//     buttonsColor: Colors.white,
//     chipTheme: ChipThemeData(
//         backgroundColor: Colors.teal,
//         labelStyle: TextStyle(color: Colors.white),
//         deleteIconColor: Colors.white),
//     configuration: PagedDataTableConfiguration(
//         footer: PagedDataTableFooterConfiguration(footerVisible: true),
//         allowRefresh: true,
//         pageSizes: [50, 75, 100],
//         initialPageSize: 10));

