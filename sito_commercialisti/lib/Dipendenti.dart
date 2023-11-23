import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
import 'package:sito_commercialisti/Modello.dart';
import 'package:sito_commercialisti/NavBar.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:intl/intl.dart';
import 'Post.dart';
import 'package:http/http.dart' as http;

class Dipendenti extends StatefulWidget {
  Dipendenti();

  @override
  State<Dipendenti> createState() => DipendentiState();
}

class DipendentiState extends State<Dipendenti> {

  final _formKey = GlobalKey<FormState>();
  final tableController = PagedDataTableController<String, int, Post>();
  PagedDataTableThemeData? theme;

  Modello modello=Modello();


  @override
  Widget build(BuildContext context) {

    getDipendenti();

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
                      columns: [
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

                      ],
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

                      menu: PagedDataTableFilterBarMenu(items: [
                        FilterMenuItem(
                          title: const Text("Apply new theme"),
                          onTap: () {
                            setState(() {
                              if (theme == null) {
                                theme = kCustomPagedDataTableTheme;
                              } else {
                                theme = null;
                              }
                            });
                          },
                        ),
                        const FilterMenuDivider(),
                        FilterMenuItem(
                          title: const Text("Remove row"),
                          onTap: () {
                            tableController.removeRow(tableController.currentDataset.first.id);
                          },
                        ),
                        FilterMenuItem(
                          title: const Text("Remove filters"),
                          onTap: () {
                            tableController.removeFilters();
                          },
                        ),
                        FilterMenuItem(
                            title: const Text("Add filter"),
                            onTap: () {
                              tableController.setFilter("gender", Gender.male);
                            }),
                        const FilterMenuDivider(),
                        FilterMenuItem(
                            title: const Text("Print selected rows"),
                            onTap: () {
                              var selectedPosts = tableController.getSelectedRows();
                              debugPrint("SELECTED ROWS ----------------------------");
                              debugPrint(selectedPosts
                                  .map((e) =>
                              "Id [${e.id}] Author [${e.author}] Gender [${e.authorGender.name}]")
                                  .join("\n"));
                              debugPrint("------------------------------------------");
                            }),
                        FilterMenuItem(
                            title: const Text("Unselect all rows"),
                            onTap: () {
                              tableController.unselectAllRows();
                            }),
                        FilterMenuItem(
                            title: const Text("Select random row"),
                            onTap: () {
                              final random = Random.secure();
                              tableController.selectRow(tableController
                                  .currentDataset[random.nextInt(tableController.currentDataset.length)].id);
                            }),
                        const FilterMenuDivider(),
                        FilterMenuItem(
                            title: const Text("Update first row's gender and number"),
                            onTap: () {
                              tableController.modifyRowValue(1, (item) {
                                item.authorGender = Gender.male;
                                item.number = 1;
                                item.author = "Tomas";
                                item.content = "empty content";
                              });
                            }),
                        const FilterMenuDivider(),
                        FilterMenuItem(
                          title: const Text("Refresh cache"),
                          onTap: () {
                            tableController.refresh(currentDataset: false);
                          },
                        ),
                        FilterMenuItem(
                          title: const Text("Refresh current dataset"),
                          onTap: () {
                            tableController.refresh();
                          },
                        ),
                      ]),
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

                        Text("Dipendenti",style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),
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

                                  bool isChecked=false;
                                  String? username=null;
                                  String? nome=null;
                                  String? cognome=null;
                                  String? telefono=null;
                                  String? email=null;

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

                                                Text("Inserisci un nuovo dipendente",
                                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),

                                                SizedBox(height: 30),
                                                //username
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
                                                          username=value;
                                                        },
                                                        validator: (value) {
                                                          if (value == null || value.isEmpty) {
                                                            return 'Please enter some text';
                                                          }
                                                          return null;
                                                        },
                                                        decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintText: 'Inserisci username'
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 15,),
                                                //nome
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
                                                          nome=value;
                                                        },
                                                        validator: (value) {
                                                          if (value == null || value.isEmpty) {
                                                            return 'Please enter some text';
                                                          }
                                                          return null;
                                                        },
                                                        decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintText: 'Inserisci nome'
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 15,),
                                                //cognome
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
                                                          cognome=value;
                                                        },
                                                        validator: (value) {
                                                          if (value == null || value.isEmpty) {
                                                            return 'Please enter some text';
                                                          }
                                                          return null;
                                                        },
                                                        decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintText: 'Inserisci cognome'
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 15,),
                                                //email
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
                                                          email=value;
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
                                                        decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintText: 'Inserisci email'
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 15,),
                                                //telefono
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
                                                          telefono=value;
                                                        },
                                                        validator: (value) {
                                                          if (value == null || value.isEmpty) {
                                                            return 'Please enter some text';
                                                          }
                                                          return null;
                                                        },
                                                        decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintText: 'Inserisci numero di telefono'
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 30,),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [

                                                    Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Switch(
                                                          value: isChecked,
                                                          activeColor: Colors.green,
                                                          onChanged: (bool value) {
                                                            setState(() {
                                                              isChecked = value;
                                                            });
                                                          },
                                                        )
                                                    ),
                                                    Text("Admin"),
                                                    SizedBox(width: 60),

                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: Colors.deepPurple.shade400, // Background color
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20.0)
                                                          ),
                                                        ),
                                                        child: Text("Inserisci"),

                                                        onPressed: () async{
                                                          if (_formKey.currentState!.validate()) {
                                                            _formKey.currentState!.save();

                                                            //qui fai la insert e ricordati di fare la get uffici.

                                                            String tt=modello.token!;
                                                            var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Dipendente/DipendenteMng'));
                                                            request.bodyFields= {
                                                              "codiceUtente":username!,
                                                              "studioId": modello!.studioId.toString(),
                                                              "dipendenteNome" : nome!,
                                                              "dipendenteCognome" : cognome!,
                                                              "ufficioId": modello!.ufficioId.toString(), //sistemare!!!!!
                                                              "email" : email!,
                                                              "telefono": telefono!,
                                                              "amministratore": isChecked.toString(),
                                                              "tipoOperazione":"I",
                                                              "utenteId": "331"                     //sistemare!!!!!!
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
            ]
        ),

      ),
    );

  }



  getDipendenti() async {

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
    }
    else {
      print(response.reasonPhrase);
    }

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





}





const kCustomPagedDataTableTheme = PagedDataTableThemeData(
    rowColors: [
      Color(0xFFC4E6E3),
      Color(0xFFE5EFEE),
    ],
    backgroundColor: Color(0xFFE0F2F1),
    headerBackgroundColor: Color(0xFF80CBC4),
    filtersHeaderBackgroundColor: Color(0xFF80CBC4),
    footerBackgroundColor: Color(0xFF80CBC4),
    footerTextStyle: TextStyle(color: Colors.white),
    textStyle: TextStyle(fontWeight: FontWeight.normal),
    buttonsColor: Colors.white,
    chipTheme: ChipThemeData(
        backgroundColor: Colors.teal,
        labelStyle: TextStyle(color: Colors.white),
        deleteIconColor: Colors.white),
    configuration: PagedDataTableConfiguration(
        footer: PagedDataTableFooterConfiguration(footerVisible: true),
        allowRefresh: true,
        pageSizes: [50, 75, 100],
        initialPageSize: 50));
