import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sito_commercialisti/AggiustaSize.dart';
import 'package:sito_commercialisti/NavBar.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:sito_commercialisti/tabella/nav_helper.dart';

class HomePageSito extends StatefulWidget {
  HomePageSito();

  @override
  State<HomePageSito> createState() => HomePageSitoState();
}

class HomePageSitoState extends State<HomePageSito> {

  List<Persona> persone=  [Persona(1, "gionni"),Persona(2, "gianni"),Persona(3, "gino")];

  late Classe modello;

  int _rowsPerPage= 30;

  int? _sortColumnIndex;

  bool _sortAscending = true;



  @override
  Widget build(BuildContext context) {

    modello=Classe(persone, context);


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

      body: Container(
        child: PaginatedDataTable2(
          availableRowsPerPage: const [2, 5, 10, 30, 100],
          //horizontalMargin: 20,
          checkboxHorizontalMargin: 12,
          columnSpacing: 0,
          wrapInCard: false,
          renderEmptyRowsInTheEnd: false,
          header: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('PaginatedDataTable2'),
          ]),

          rowsPerPage: _rowsPerPage,
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),

          //autoRowsToHeight: getCurrentRouteOption(context) == autoRows,
          minWidth: 800,
          fit: FlexFit.tight,
          border: TableBorder(
              top: const BorderSide(color: Colors.black),
              bottom: BorderSide(color: Colors.grey[300]!),
              left: BorderSide(color: Colors.grey[300]!),
              right: BorderSide(color: Colors.grey[300]!),
              verticalInside: BorderSide(color: Colors.grey[300]!),
              horizontalInside: const BorderSide(color: Colors.grey, width: 1)),

          empty: Center(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.grey[200],
                  child: const Text('No data'))),

          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          sortArrowIcon: Icons.keyboard_arrow_up, // custom arrow
          sortArrowAnimationDuration:
          const Duration(milliseconds: 0),
          columns: _columns,
          source: getCurrentRouteOption(context) == noData
               ? Classe.empty(context)
               : modello,

          initialFirstRowIndex: 0,
          onRowsPerPageChanged: (value) {
            // No need to wrap into setState, it will be called inside the widget
            // and trigger rebuild
            //setState(() {
            _rowsPerPage = value!;
            print(_rowsPerPage);
            //});
          },

          onPageChanged: (rowIndex) {
            print(rowIndex / _rowsPerPage);
          },

        ),
      ),

    );
  }




  List<DataColumn> get _columns {
    return [
      DataColumn(
        label: const Text('Id'),
        // onSort: (columnIndex, ascending) =>
        //     sort<String>((d) => d.name, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('nome'),
        numeric: true,
        // onSort: (columnIndex, ascending) =>
        //     sort<num>((d) => d.calories, columnIndex, ascending),
      ),
    ];
  }
}


class Persona{
  int? id;
  String? nome;
  String? cognome;
  String? mail;
  String? telefono;
  bool selected=false;

  Persona(this.id, this.nome);


}


class Classe extends DataTableSource{

  Classe.empty(this.context){
    persone=[];
  }

  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = true;

  final BuildContext context;
  late List<Persona> persone;


  void sort<T>(Comparable<T> Function(Persona d) getField, bool ascending) {
    persone.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }



  void updateSelectedDesserts(RestorableDessertSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < persone.length; i += 1) {
      var dessert = persone[i];
      if (selectedRows.isSelected(i)) {
        dessert.selected = true;
        _selectedCount += 1;
      } else {
        dessert.selected = false;
      }
    }
    notifyListeners();
  }

  @override
  DataRow? getRow(int index, [Color? color]) {

    assert(index >= 0);
    if (index >= persone.length) throw 'index > persone.length';
    final dessert = persone[index];

    return DataRow2.byIndex(
        index: index,
        selected: dessert.selected,
        color: color != null
            ? MaterialStateProperty.all(color)
            : (hasZebraStripes && index.isEven
            ? MaterialStateProperty.all(Theme.of(context).highlightColor)
            : null),

        onSelectChanged: (value) {
          if (dessert.selected != value) {
            _selectedCount += value! ? 1 : -1;
            assert(_selectedCount >= 0);
            dessert.selected = value;
            notifyListeners();
          }ù

        },

        onTap: hasRowTaps
            ? () => _showSnackbar(context, 'Tapped on row ${dessert.id} ${dessert.nome}')
            : null,
        onDoubleTap: hasRowTaps
            ? () => _showSnackbar(context, 'Double Tapped on row ${dessert.id} ${dessert.nome}')
            : null,
        onLongPress: hasRowTaps
            ? () => _showSnackbar(context, 'Long pressed on row ${dessert.id} ${dessert.nome}')
            : null,
        onSecondaryTap: hasRowTaps
            ? () => _showSnackbar(context, 'Right clicked on row ${dessert.id} ${dessert.nome}')
            : null,
        onSecondaryTapDown: hasRowTaps
            ? (d) =>
            _showSnackbar(context, 'Right button down on row ${dessert.id} ${dessert.nome}')
            : null,

        cells: [
          DataCell(Text(persone[index].id.toString())),
          DataCell(Text(persone[index].nome!)),
        ],

    );

  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => persone.length;

  @override
  int get selectedRowCount => _selectedCount;


  int _selectedCount = 0;


  void selectAll(bool? checked) {
    for (final dessert in persone) {
      dessert.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? persone.length : 0;
    notifyListeners();
  }

  Classe(this.persone, this.context);
}

class RestorableDessertSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _dessertSelections.contains(index);

  /// Takes a list of [Dessert]s and saves the row indices of selected rows
  /// into a [Set].
  void setDessertSelections(List<Persona> desserts) {
    final updatedSet = <int>{};
    for (var i = 0; i < desserts.length; i += 1) {
      var dessert = desserts[i];
      if (dessert.selected) {
        updatedSet.add(i);
      }
    }
    _dessertSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _dessertSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _dessertSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _dessertSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _dessertSelections = value;
  }

  @override
  Object toPrimitives() => _dessertSelections.toList();
}





_showSnackbar(BuildContext context, String text, [Color? color]) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
    duration: const Duration(seconds: 1),
    content: Text(text),
  ));
}
