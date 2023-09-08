import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
import 'package:sito_commercialisti/NavBar.dart';
import 'package:data_table_2/data_table_2.dart';

class HomePageSito extends StatefulWidget {
  HomePageSito();

  @override
  State<HomePageSito> createState() => HomePageSitoState();
}

class HomePageSitoState extends State<HomePageSito> {

  List<Persona> persone=  List<Persona>.empty();

  Classe modello=Classe(List<Persona>.empty());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        //leading: Icon(Icons.menu, size: 45, color: Colors.black,),
        elevation: 5,
        toolbarHeight: 80,
        backgroundColor: Colors.purple.shade200,
        shadowColor: Colors.purple.shade100,
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

      body: Container(
        child: PaginatedDataTable2(
          columns: _columns,
          source: modello,


        ),
      ),

    );
  }




  List<DataColumn> get _columns {
    return [
      DataColumn(
        label: const Text('Desert'),
        // onSort: (columnIndex, ascending) =>
        //     sort<String>((d) => d.name, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Calories'),
        numeric: true,
        // onSort: (columnIndex, ascending) =>
        //     sort<num>((d) => d.calories, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Fat (gm)'),
        numeric: true,
        // onSort: (columnIndex, ascending) =>
        //     sort<num>((d) => d.fat, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Carbs (gm)'),
        numeric: true,
        // onSort: (columnIndex, ascending) =>
        //     sort<num>((d) => d.carbs, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Protein (gm)'),
        numeric: true,
        // onSort: (columnIndex, ascending) =>
        //     sort<num>((d) => d.protein, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Sodium (mg)'),
        numeric: true,
        // onSort: (columnIndex, ascending) =>
        //     sort<num>((d) => d.sodium, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Calcium (%)'),
        numeric: true,
        // onSort: (columnIndex, ascending) =>
        //     sort<num>((d) => d.calcium, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Iron (%)'),
        numeric: true,
        // onSort: (columnIndex, ascending) =>
        //     sort<num>((d) => d.iron, columnIndex, ascending),
      ),
    ];
  }
}


class Persona{
  int? id;
  String? nome;

  Persona(this.id, this.nome);


}


class Classe extends DataTableSource{


  List<Persona> persone;

  @override
  DataRow? getRow(int index) {

    assert(index >= 0);
    if (index >= persone.length) throw 'index > _desserts.length';
    final dessert = persone[index];

    return DataRow2.byIndex(
        cells: [
          DataCell(Text(persone[index].id as String)),
          DataCell(Text(persone[index].nome as String)),
        ],

    );

  }

  @override
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => persone.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => _selectedCount;


  int _selectedCount = 0;

  Classe(this.persone);
}
