import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
import 'package:sito_commercialisti/Modello.dart';
import 'package:sito_commercialisti/NavBar.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:intl/intl.dart';
import 'Post.dart';

import 'package:http/http.dart' as http;

class Clienti extends StatefulWidget {
  Clienti();

  @override
  State<Clienti> createState() => ClientiState();

}

class ClientiState extends State<Clienti> {

  final _formKey = GlobalKey<FormState>();
  final tableController = PagedDataTableController<String, int, Post>();
  PagedDataTableThemeData? theme;


  Modello modello=Modello();



  @override
  Widget build(BuildContext context) {

    getClienti();

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
                      child: PagedDataTable<String, int, Post>(

                        rowsSelectable: true,
                        theme: theme,
                        idGetter: (post) => post.id,
                        controller: tableController,
                        fetchPage: (pageToken, pageSize, sortBy, filtering) async {
                          if (filtering.valueOrNull("authorName") == "error!") {
                            throw Exception("This is an unexpected error, wow!");
                          }

                          var result = await PostsRepository.getPosts(
                              pageSize: pageSize,
                              pageToken: pageToken,
                              sortBy: sortBy?.columnId,
                              sortDescending: sortBy?.descending ?? false,
                              gender: filtering.valueOrNullAs<Gender>("gender"),
                              authorName: filtering.valueOrNullAs<String>("authorName"),
                              between: filtering.valueOrNullAs<DateTimeRange>("betweenDate"));
                          return PaginationResult.items(
                              elements: result.items, nextPageToken: result.nextPageToken);
                        },
                        initialPage: "",
                        columns: colonne(),
                        filters: [
                          TextTableFilter(
                              id: "authorName",
                              title: "Author's name",
                              chipFormatter: (text) => "By $text"),
                          DropdownTableFilter<Gender>(
                              id: "gender",
                              title: "Gender",
                              defaultValue: Gender.male,
                              chipFormatter: (gender) =>
                              'Only ${gender.name.toLowerCase()} posts',
                              items: const [
                                DropdownMenuItem(value: Gender.male, child: Text("Male")),
                                DropdownMenuItem(value: Gender.female, child: Text("Female")),
                                DropdownMenuItem(
                                    value: Gender.unespecified, child: Text("Unspecified")),
                              ]),
                          DatePickerTableFilter(
                            id: "date",
                            title: "Date",
                            chipFormatter: (date) => 'Only on ${DateFormat.yMd().format(date)}',
                            firstDate: DateTime(2000, 1, 1),
                            lastDate: DateTime.now(),
                          ),
                          DateRangePickerTableFilter(
                            id: "betweenDate",
                            title: "Between",
                            chipFormatter: (date) =>
                            'Between ${DateFormat.yMd().format(date.start)} and ${DateFormat.yMd().format(date.end)}',
                            firstDate: DateTime(2000, 1, 1),
                            lastDate: DateTime.now(),
                          )
                        ],
                        footer: TextButton(
                          onPressed: () {},

                          child: const Text("Im a footer button"),
                        ),

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

  List<BaseTableColumn<Post>> colonne(){
    return [
        TableColumn(
          title: "Identificator",
          cellBuilder: (item) => Text(item.id.toString()),
          sizeFactor: .05,
        ),
        TableColumn(
            title: "Author", cellBuilder: (item) => Text(item.author)),
        LargeTextTableColumn(
            title: "Content",
            getter: (post) => post.content,
            setter: (post, newContent, rowIndex) async {
              await Future.delayed(const Duration(seconds: 1));
              post.content = newContent;
              return true;
            },
            sizeFactor: .3),
        TableColumn(
            id: "createdAt",
            title: "Created At",
            sortable: true,
            cellBuilder: (item) =>
                Text(DateFormat.yMd().format(item.createdAt))),
        DropdownTableColumn<Post, Gender>(
          title: "Gender",
          sizeFactor: null,
          getter: (post) => post.authorGender,
          setter: (post, newGender, rowIndex) async {
            post.authorGender = newGender;
            await Future.delayed(const Duration(seconds: 1));
            return true;
          },
          items: const [
            DropdownMenuItem(value: Gender.male, child: Text("Male")),
            DropdownMenuItem(value: Gender.female, child: Text("Female")),
            DropdownMenuItem(
                value: Gender.unespecified, child: Text("Unspecified")),
          ],
        ),
        TableColumn(
            title: "Enabled",
            sizeFactor: null,
            cellBuilder: (item) => IconButton(onPressed: (){print("ciao");}, icon: Icon(Icons.add))),
        TextTableColumn(
            title: "Number",
            id: "number",
            sortable: true,
            sizeFactor: .05,
            isNumeric: true,
            getter: (post) => post.number.toString(),
            setter: (post, newValue, rowIndex) async {
              await Future.delayed(const Duration(seconds: 1));

              int? number = int.tryParse(newValue);
              if (number == null) {
                return false;
              }

              post.number = number;

              // if you want to do this too, dont forget to call refreshRow
              post.author = "empty content haha";
              tableController.refreshRow(rowIndex);
              return true;
            }),

      ];

  }


  getClienti() async {

    var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Cliente/ClienteListGet'));
    String tt=modello.token!;
    request.bodyFields={
      "studioId": modello!.studioId.toString(),        //<-- filtro se non null
      "clienteId": "null",
      "tipologiaClienteId": "1"

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
  }


}

