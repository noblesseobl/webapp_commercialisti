import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
import 'package:sito_commercialisti/Modello.dart';
import 'package:sito_commercialisti/NavBar.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:intl/intl.dart';
import 'Post.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';


class Messaggi extends StatefulWidget {
  Messaggi();

  @override
  State<Messaggi> createState() => MessaggiState();
}

List tipoMessaggio =["Ricevuti", "Inviati"];
List tipocliente=["Privato", "Aziendale"];

class MessaggiState extends State<Messaggi> {

  final _formKey = GlobalKey<FormState>();
  String? testo;
  File? file;
  String? titolo;
  String? dropdownValue = tipoMessaggio.first;
  String? dropdownValue2 = tipocliente.first;

  String? get $dropdownValue => null;
  String? get $dropdownValue2 => null;

  Modello modello=Modello();
  List<Messaggio> casella= List.empty();




  List<Map> categories = [
    {"name": "Mario Rossi", "isChecked": false},
    {"name": "Giacomo Giallo", "isChecked": false},
    {"name": "Luca Verdi", "isChecked": false},
  ];

  List<Map> categories2 = [
    {"name": "Fabio Alberti", "isChecked": false},
    {"name": "Pinco Pallino", "isChecked": false},
    {"name": "Gianluca Viola", "isChecked": false},
  ];


  final tableController = PagedDataTableController<String, int, Post>();
  PagedDataTableThemeData? theme;




  @override
  Widget build(BuildContext context) {
    getMessaggi();
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
          children:[

            //tabella
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
                            title: "Data caricamento",
                            sortable: true,
                            cellBuilder: (item) =>
                                Text(DateFormat.yMd().format(item.createdAt))),
                        TableColumn(
                          title: "              ",
                          sizeFactor: null,
                          cellBuilder: (item) => Row(
                              children: [
                                if(1<0)
                                  Flexible(child:IconButton(onPressed: (){
                                    print(item.id);
                                  }, icon: Icon(Icons.download, color: Colors.deepPurple.shade400)))
                                else
                                  Flexible(child:IconButton(onPressed: (){
                                    print(item.id);
                                  }, icon: Icon(Icons.download, color: Colors.grey.shade300))),
                                if(1<0)
                                  Flexible(child: IconButton(onPressed: (){
                                    print(item.id);
                                  }, icon: Icon(Icons.mail_outline_outlined, color: Colors.deepPurple.shade400)))
                                else
                                  Flexible(child: IconButton(onPressed: (){
                                    print(item.id);
                                  }, icon: Icon(Icons.mail_outline_outlined, color: Colors.grey.shade300))),
                                Flexible(child: IconButton(onPressed: (){showDialog(
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
                                    });}, icon: Icon(Icons.remove_red_eye, color: Colors.deepPurple.shade400))),
                                Flexible(child: IconButton(onPressed: (){
                                  print(item.id);
                                  tableController.removeRow(item.id);
                                }, icon: Icon(Icons.delete, color: Colors.deepPurple.shade400))),
                              ]),
                        ),
                      ],



                      filters: [
                        TextTableFilter(
                            id: "authorName",
                            title: "Author's name",
                            chipFormatter: (text) => "By $text"),

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


                    ),

                ),
              )
          ),

            //*******************************************************

            //barra in alto
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
                        Text("Messaggi",style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),
                        Spacer(),


                        //drop down
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration:BoxDecoration(
                                color: Colors.blueGrey.shade50,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.deepPurple.shade400)
                            ),
                            child:Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child:  DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    items: tipoMessaggio!.map<DropdownMenuItem<String>>(
                                            (dynamic value) {
                                          return DropdownMenuItem<String>(
                                            child: Text(value),
                                            value: value.toString(),
                                          );
                                        }).toList(),
                                    value: dropdownValue,
                                    iconEnabledColor: Colors.deepPurple.shade400,
                                    iconDisabledColor: Colors.deepPurple.shade400,
                                    //isExpanded: true,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style:
                                    TextStyle(color: Colors.blueGrey.shade700),
                                    underline: Container(
                                      width: 100,
                                      height: 2,
                                      color: Colors.deepPurple.shade400,
                                    ),
                                    onChanged: (String? value) {
                                      setState(() {
                                        dropdownValue = value;
                                        print(dropdownValue);
                                      });
                                    }),),
                              ),
                          ),
                        ),

                        //bottone scrivi messaggio
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
                                        return AlertDialog(
                                          
                                          backgroundColor: Colors.deepPurple.shade100,
                                          scrollable: true,
                                          content: Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                                  child: Container(
                                                    decoration:BoxDecoration(
                                                        color: Colors.blueGrey.shade50,
                                                        borderRadius: BorderRadius.circular(15),
                                                        border: Border.all(color: Colors.deepPurple.shade400)
                                                    ),
                                                    child:Padding(
                                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                                      child: DropdownButtonHideUnderline(
                                                        child: DropdownButton(
                                                            items: tipocliente!.map<DropdownMenuItem<String>>(
                                                                    (dynamic value) {
                                                                  return DropdownMenuItem<String>(
                                                                    child: Text(value),
                                                                    value: value.toString(),
                                                                  );
                                                                }).toList(),
                                                            value: dropdownValue2,
                                                            iconEnabledColor: Colors.deepPurple.shade400,
                                                            iconDisabledColor: Colors.deepPurple.shade400,
                                                            //isExpanded: true,
                                                            icon: const Icon(Icons.arrow_downward),
                                                            elevation: 16,
                                                            style:
                                                            TextStyle(color: Colors.blueGrey.shade700),
                                                            underline: Container(
                                                              width: 100,
                                                              height: 2,
                                                              color: Colors.deepPurple.shade400,
                                                            ),
                                                            onChanged: (String? value) {
                                                              setState(() {
                                                                dropdownValue2 = value;
                                                                print(dropdownValue2);
                                                              });
                                                            }),),),),
                                                ),
                                                SizedBox(height: 20,),
                                                if(dropdownValue2==tipocliente[0])
                                                  Padding(
                                                    padding: const EdgeInsets.all(20),
                                                    child:
                                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                      const Text(
                                                        "Scegli i clienti desiderati: ",
                                                        style: TextStyle(fontSize: 16),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      const Divider(),
                                                      const SizedBox(height: 10),
                                                      Column(
                                                          children: categories.map((favorite) {
                                                            return CheckboxListTile(
                                                                activeColor: Colors.deepPurple.shade400,
                                                                checkboxShape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(5)),
                                                                value: favorite["isChecked"],
                                                                title: Text(favorite["name"]),
                                                                onChanged: (val) {
                                                                  setState(() {
                                                                    favorite["isChecked"] = val;
                                                                  });
                                                                });
                                                          }).toList()),
                                                      const SizedBox(height: 10),
                                                      const Divider(),
                                                    ]),
                                                  )
                                                else
                                                  Padding(
                                                    padding: const EdgeInsets.all(20),
                                                    child:
                                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                      const Text(
                                                        "Scegli i clienti desiderati: ",
                                                        style: TextStyle(fontSize: 16),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      const Divider(),
                                                      const SizedBox(height: 10),
                                                      Column(
                                                          children: categories2.map((favorite) {
                                                            return CheckboxListTile(
                                                                activeColor: Colors.deepPurple.shade400,
                                                                checkboxShape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(5)),
                                                                value: favorite["isChecked"],
                                                                title: Text(favorite["name"]),
                                                                onChanged: (val) {
                                                                  setState(() {
                                                                    favorite["isChecked"] = val;
                                                                  });
                                                                });
                                                          }).toList()),
                                                      const SizedBox(height: 10),
                                                      const Divider(),
                                                    ]),
                                                  ),

                                                Wrap(
                                                  children: categories.map((favorite) {
                                                    if (favorite["isChecked"] == true) {
                                                      return Card(
                                                        elevation: 3,
                                                        color: Colors.deepPurple.shade400,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                favorite["name"],
                                                                style: const TextStyle(color: Colors.white),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    favorite["isChecked"] = !favorite["isChecked"];
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
                                                Wrap(
                                                  children: categories2.map((favorite) {
                                                    if (favorite["isChecked"] == true) {
                                                      return Card(
                                                        elevation: 3,
                                                        color: Colors.deepPurple.shade400,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                favorite["name"],
                                                                style: const TextStyle(color: Colors.white),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    favorite["isChecked"] = !favorite["isChecked"];
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
                                                  }).toList(),
                                                ),
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
                                                        decoration: const InputDecoration(
                                                            border: InputBorder.none,
                                                            hintText: 'Inserisci titolo'
                                                        ),
                                                        validator: (value) {
                                                          if (value == null || value.isEmpty) {
                                                            return 'Inserisci titolo!';
                                                          }
                                                          titolo=value;
                                                          return null;
                                                        },
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

                                                      decoration: const InputDecoration(
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

                                                        onPressed: () async {
                                                          if (_formKey.currentState!.validate()) {
                                                            _formKey.currentState!.save();

                                                            //richiama il file picker                                                           }
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

                                                        onPressed: () async {

                                                          if (_formKey.currentState!.validate()){}
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


                          child: const Icon(
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
            )

          ]
        ),
      ),

    );
  }



  getMessaggi() async {
    var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Messaggio/MessaggioMsgGet'));
    String tt=modello.token!;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    request.bodyFields={

        "studioId": modello!.studioId.toString(),
        "inviatoDaStudio" : "true",  //<-- true / false
        "dipendenteId": "null",        //<-- filtro se non null
        "clienteId": "null",           //<-- filtro se non null
        "ufficioId": "null",          // <-- filtro se non null
        "dataDal": date.toString() ,       //<-- data nel formato YYYYMMDD
        "dataAl": "19000101",       // <-- data nel formato YYYYMMDD
        "messaggioId": "null"          //<-- filtro se non null


    };
    request.headers['Authorization'] = 'Bearer $tt';

    http.StreamedResponse response = await request.send();
    response.stream.asBroadcastStream();

    var jsonData=  jsonDecode(await response.stream.bytesToString());


    if (response.statusCode == 200) {
      print(jsonData);

      for(var mex in jsonData){
        casella.add(Messaggio(mex["titolo"], mex["messaggio"]));
      }

    }
    else {
      print(response.reasonPhrase);
    }
  }


}



class Messaggio {

  String titolo;
  String messaggio;
  Messaggio(this.titolo, this.messaggio);


  // "messaggioId": 0,
  // "dipendenteId": 2,
  // "dipendenteCognome": "Rossi",
  // "dipendenteNome": "Mario",
  // "clienteId": 1,
  // "clienteCognome": "Sasso",
  // "clienteNome": "Marco",
  // "titolo": "WEB_Titolo nuovo messaggio",
  // "testo": "WEB_Questo è il messaggio",
  // "inviatoDaStudio": true,
  // "ufficioId": 1,
  // "ufficioDescr": "Segreteria",
  // "numeroAllegati": 2,
  // "dataLetturaMessaggio": "2023-09-25T00:00:00"

}






//sposta nel table se poi ti dovessero servire

/*
footer: TextButton(
  onPressed: () {},
  child: const Text("Im a footer button"),
),
 */

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