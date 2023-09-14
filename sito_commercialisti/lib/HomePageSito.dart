import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
import 'package:sito_commercialisti/NavBar.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:intl/intl.dart';
import 'Post.dart';


class HomePageSito extends StatefulWidget {
  HomePageSito();

  @override
  State<HomePageSito> createState() => HomePageSitoState();
}

class HomePageSitoState extends State<HomePageSito> {



  final _formKey = GlobalKey<FormState>();




  final tableController = PagedDataTableController<String, int, Post>();
  PagedDataTableThemeData? theme;



  @override
  Widget build(BuildContext context) {


    return Scaffold(


          drawer: NavBar(),

          appBar: AppBar(
            //leading: Icon(Icons.menu, size: 45, color: Colors.black,),
            elevation: 5,
            toolbarHeight: 80,
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
            heightFactor: 1000,


            child: SingleChildScrollView(
              child: Container(


                color: const Color.fromARGB(255, 208, 208, 208),

                padding: const EdgeInsets.all(20.0),

                child: Padding(


                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),

                  child: Column(
                    children: [
                      Material(

                        elevation: 5,
                        borderRadius: BorderRadius.circular(12),
                        shadowColor: Colors.black,

                        child: Card(

                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.deepPurple.shade600,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          shadowColor: Colors.black26,
                          color: Colors.white,

                          child: Container(

                            margin: EdgeInsets.fromLTRB(40, 30, 150, 30),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [

                                Text("Clienti",style: TextStyle(fontSize: 45, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),

                                Spacer(),
                                ElevatedButton(
                                    style:ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(20),

                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0)
                                      ),
                                    ),

                                    onPressed: (){print("ciao volpiano");},
                                    child: Text("importa csv",style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white))
                                ),

                                SizedBox(width: 30),
                                ElevatedButton(


                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(20),



                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                    ),
                                  ),

                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState) {
                                                return Dialog(
                                                  insetPadding: EdgeInsets.symmetric(horizontal: 400, vertical: 230),


                                                  backgroundColor: Colors.purple.shade50,

                                                  child: Container(


                                                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                                    child: Form(
                                                      key: _formKey,
                                                      child: Column(


                                                        children: [

                                                          SizedBox(height: 30),

                                                          Text("Clienti",style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),


                                                          SizedBox(height: 20),

                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [


                                                              Expanded(
                                                                child: Container(
                                                                  margin:EdgeInsets.fromLTRB(30, 0,10, 0),
                                                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                                                  decoration:BoxDecoration(
                                                                      color: Colors.blueGrey.shade50,
                                                                      borderRadius: BorderRadius.circular(15),
                                                                      border: Border.all(color: Colors.deepPurple.shade400)
                                                                  ),
                                                                  child: TextFormField(
                                                                    decoration: InputDecoration(

                                                                        border: InputBorder.none,
                                                                        hintText: 'Inserisci codice utente'
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),

                                                              Expanded(
                                                                child: Container(
                                                                  margin:EdgeInsets.fromLTRB(10, 0, 30, 0),
                                                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                                                  decoration:BoxDecoration(
                                                                      color: Colors.blueGrey.shade50,
                                                                      borderRadius: BorderRadius.circular(15),
                                                                      border: Border.all(color: Colors.deepPurple.shade400)
                                                                  ),
                                                                  child: TextFormField(

                                                                    obscureText: true,
                                                                    decoration: InputDecoration(
                                                                      hintText: 'Inserisci password',
                                                                      border: InputBorder.none,
                                                                    ),

                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                          SizedBox(height: 40,),


                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                  ),
                                                );
                                              }
                                          );
                                        });
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    weight: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20,),


                      SizedBox(
                        height: 1000,


                        child: Material(

                          elevation: 5,
                          borderRadius: BorderRadius.circular(12),
                          shadowColor: Colors.black,


                          child: Card(


                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.deepPurple.shade600,
                                ),
                                borderRadius: BorderRadius.circular(12)),
                            shadowColor: Colors.black26,
                            color: Colors.white,


                            child: Container(



                              margin: EdgeInsets.fromLTRB(40, 30, 150, 30),
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

                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

        ),
    );




  }





}








