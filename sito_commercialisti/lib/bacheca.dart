import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
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

      body: Center(
        child: Container(
            color: const Color.fromARGB(255, 208, 208, 208),
            padding: const EdgeInsets.all(20.0),
            child: Padding(
              padding:const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                            Text("Bacheca",style: TextStyle(fontSize: 45, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),
                            Spacer(),

                            ElevatedButton(



                              onPressed: () {
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
                                                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                      child: Container(
                                                        height: 170,
                                                        decoration:BoxDecoration(
                                                            color: Colors.blueGrey.shade50,
                                                            borderRadius: BorderRadius.circular(15),
                                                            border: Border.all(color: Colors.deepPurple.shade400)
                                                        ),
                                                        child:Padding(
                                                          padding: const EdgeInsets.only(left: 0),

                                                          child: TextFormField(

                                                            decoration: InputDecoration(
                                                              hintText: 'Inserisci descrizione',
                                                              filled: true,
                                                            ),
                                                            keyboardType: TextInputType.multiline,
                                                            expands: false,
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
                                      );
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(20),




                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                              ),

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
                  Expanded(
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
                              LargeTextTableColumn(
                                  title: "Titolo",
                                  getter: (post) => post.content,
                                  setter: (post, newContent, rowIndex) async {
                                    await Future.delayed(const Duration(seconds: 1));
                                    post.content = newContent;
                                    return true;
                                  },
                                  sizeFactor: .3),
                              LargeTextTableColumn(
                                  title: "Descrizione",
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
                              TableColumn(
                                title: "              ",
                                sizeFactor: null,
                                cellBuilder: (item) => Row(
                                    children: [
                                      IconButton(onPressed: (){
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
                                            });
                                      }, icon: Icon(Icons.edit, color: Colors.deepPurple.shade400)),
                                      IconButton(onPressed: (){showDialog(
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
                                          });}, icon: Icon(Icons.remove_red_eye, color: Colors.deepPurple.shade400)),
                                      IconButton(onPressed: (){
                                        print(item.id);
                                        tableController.removeRow(item.id);
                                      }, icon: Icon(Icons.delete, color: Colors.deepPurple.shade400))
                                    ]),
                              ),
                            ],
                            filters: [
                              TextTableFilter(
                                  id: "authorName",
                                  title: "Author's name",
                                  chipFormatter: (text) => "By $text"),
                              /* DropdownTableFilter<Gender>(
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
                    */
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
                            /*
                  footer: TextButton(
                    onPressed: () {},
                    child: const Text("Im a footer button"),
                  ),
                   */

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
                  ),
                ],
              ),
            )
          ),
      ),

    );
  }


  @override
  void dispose() {
    tableController.dispose();
    super.dispose();
  }



}




final tableController = PagedDataTableController<String, int, Post>();
PagedDataTableThemeData? theme;




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
