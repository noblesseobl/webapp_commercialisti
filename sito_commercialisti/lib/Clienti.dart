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


  final tableController = PagedDataTableController<String, int, Cliente>();

  List<Cliente> clienti=[];
  List<DipendenteDesignato> dipendenti=[];  //tiene tutti i dipendenti disponibili
  List<TipologiaCliente> tipoClienti=[];

  Modello modello=Modello();

  TipologiaCliente? dropdownValue2;
  TipologiaCliente? get $dropdownValue2 => null;

  // TipologiaCliente? dropdownValue;
  // TipologiaCliente? get $dropdownValue => null;





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

                        idGetter: (item) => item.clienteId,

                        controller: tableController,

                        fetchPage: (pageToken, pageSize, sortBy, filtering) async {

                          //richiama i dati dei clienti

                            clienti=[];
                            dipendenti=[];

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
                              print("");
                              for(var client in inspect){
                                  clienti.add(Cliente(client["clienteId"], client["codiceCliente"], client["studioId"], client["clienteNome"], client["clienteCognome"], client["email"], client["telefono"], TipologiaCliente(client["tipologiaClienteDescr"],client["tipologiaClienteId"]), List.empty()));
                              }
                            }
                            else {
                              print(response.reasonPhrase);
                            }

                            //raccogli i dati dei dipendenti

                            dipendentiGet();

                            //associa ad ogni cliente il dipendente corrispondente

                            for(Cliente cl in clienti){

                              http.StreamedResponse response = await getDipendentiPerCliente(cl.clienteId);
                              response.stream.asBroadcastStream();
                              var jsonData2=  jsonDecode(await response.stream.bytesToString());

                              var inspect2 = jsonData2['Dipendente'];

                              print(jsonData2);
                              print("");

                              cl.dipendentiDesignati=List.from(dipendenti);

                              if (response.statusCode == 200) {
                                for(var j in inspect2){
                                  for(DipendenteDesignato dd in cl.dipendentiDesignati){
                                    if(j["dipendenteId"]==dd.dipendenteId){
                                      dd.isChecked=true;
                                    }
                                  }
                                }
                              }
                              else {
                                print(response.reasonPhrase);
                              }
                            }

                            //tipologie clienti

                            tipoClienti=[];

                            http.StreamedResponse response3 = await categorieClientiGet();
                            response3.stream.asBroadcastStream();

                            var jsonData3=  jsonDecode(await response3.stream.bytesToString());

                            if (response3.statusCode == 200) {
                              for(var mex in jsonData3){
                                tipoClienti.add(TipologiaCliente(mex["tipologiaClienteDescr"], mex["tipologiaClienteId"], mex["dataUltimaModifica"]));
                              }
                            }
                            else {
                              print(response3.reasonPhrase);
                            }

                            String ciao="cuao";

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
                            cellBuilder: (item)=> Text(item.tipologiaCliente.nome),
                            sizeFactor: .1
                          ),

                          TableColumn(
                            title: "              ",
                            sizeFactor: .25,
                            cellBuilder: (item) => Row(
                                children: [

                                  Flexible(
                                    child: IconButton(
                                        onPressed: () async {

                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                                       //return popUp("edit", item);
                                                      List<DipendenteDesignato> updateDipendenti= List.from(item.dipendentiDesignati);

                                                      String nuovoNome=item.clienteNome;
                                                      String nuovoCognome=item.clienteCognome;
                                                      String nuovaEmail=item.email;
                                                      String nuovoNumero=item.telefono;
                                                      inizializzaDropDown2(item.tipologiaCliente);

                                                      return AlertDialog(
                                                        backgroundColor: Colors.deepPurple.shade100,
                                                        scrollable: true,
                                                        content: Form(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [

                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  SizedBox(width: 170,),
                                                                  Text("Modifica", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                                  SizedBox(width: 170,),
                                                                  SizedBox(height: 20,),
                                                                ],
                                                              ),

                                                              Text("Codice cliente: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                                              SizedBox(height: 5),
                                                              Text(item.codiceCliente),
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

                                                              //dropdown tipologia
                                                              Text("Tipologia: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                                              SizedBox(height: 5),
                                                              Container(
                                                                decoration:BoxDecoration(
                                                                    color: Colors.blueGrey.shade50,
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    border: Border.all(color: Colors.deepPurple.shade400)
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                                                  child: DropdownButtonHideUnderline(
                                                                    child: DropdownButton<TipologiaCliente>(
                                                                      items: tipoClienti!.map<DropdownMenuItem<TipologiaCliente>>((TipologiaCliente value){
                                                                        return DropdownMenuItem<TipologiaCliente>(
                                                                                        child: Text(value.nome, style: TextStyle(color: Colors.black),),
                                                                                        value: value,
                                                                                      );
                                                                      }).toList(),
                                                                      onChanged: (TipologiaCliente? value) {
                                                                        setState(() {
                                                                          dropdownValue2 = value;
                                                                        });
                                                                      },
                                                                      value: dropdownValue2,
                                                                      icon: const Icon(Icons.arrow_downward),
                                                                      elevation: 16,
                                                                      style:TextStyle(color: Colors.blueGrey.shade700, fontSize: 15),
                                                                      underline: Container(
                                                                        width: 100,
                                                                        height: 2,
                                                                        color: Colors.deepPurple.shade400,
                                                                      ),
                                                                      iconEnabledColor: Colors.deepPurple.shade400,
                                                                      iconDisabledColor: Colors.deepPurple.shade400,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 20),

                                                              //dipendenti designati checkbox

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
                                                                      children: updateDipendenti.map((dipendente) {
                                                                        return CheckboxListTile(
                                                                            activeColor: Colors.deepPurple.shade400,
                                                                            checkboxShape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(5)),
                                                                            value: dipendente.isChecked,
                                                                            title: Text(dipendente.dipendenteNome+ " "+dipendente.dipendenteCognome),
                                                                            onChanged: (val) {
                                                                              setState(() {
                                                                                dipendente.isChecked = val!;
                                                                              });
                                                                            });
                                                                      }).toList()),

                                                              ),


                                                              SizedBox(height: 50),


                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(5.0),
                                                                    child: ElevatedButton(

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

                                                                      onPressed:() async {
                                                                        try{


                                                                          var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Cliente/ClienteMng'));
                                                                          String tt=modello.token!;

                                                                          String designati="";
                                                                          for(DipendenteDesignato dd in updateDipendenti){
                                                                            if(dd.isChecked){
                                                                              designati=dd.dipendenteId.toString()+"|";
                                                                            }
                                                                          }
                                                                          designati=designati.substring(0,designati.length-2);

                                                                          request.bodyFields={
                                                                            "clienteId" : item.clienteId.toString(),
                                                                            "clienteNome": nuovoNome,
                                                                            "clienteCognome": nuovoCognome,
                                                                            "email": nuovaEmail,
                                                                            "telefono": nuovoNumero,
                                                                            "tipologiaClienteId": dropdownValue2!.idTipologia.toString(),
                                                                            "dipIds": designati,
                                                                            "tipoOperazione": "U",
                                                                            "utenteId": modello.dipendenteId.toString()
                                                                          };

                                                                          request.headers['Authorization'] = 'Bearer $tt';

                                                                          http.StreamedResponse response=await request.send();

                                                                          response.stream.asBroadcastStream();
                                                                          var jsonData=  jsonDecode(await response.stream.bytesToString());

                                                                          if(jsonData["retCode"]==0){
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(content: Text(jsonData["retDescr"].toString())),
                                                                            );
                                                                          }else{
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(content: Text("Qualcosa è andato storto durante la modifica!")),
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
                                                                      // {
                                                                      //   try{
                                                                      //
                                                                      //     http.StreamedResponse response=await updateCliente();
                                                                      //
                                                                      //     var jsonData= jsonDecode(await response.stream.bytesToString());
                                                                      //
                                                                      //     if (response.statusCode == 200) {
                                                                      //       Navigator.of(context).pop();
                                                                      //       ScaffoldMessenger.of(context).showSnackBar(
                                                                      //         SnackBar(content: Text(jsonData["retDescr"].toString())),
                                                                      //       );
                                                                      //       setState((){
                                                                      //         tableController.refresh();
                                                                      //       });
                                                                      //       print(jsonData);
                                                                      //
                                                                      //     }
                                                                      //     else {
                                                                      //       print(response.reasonPhrase);
                                                                      //     }
                                                                      //
                                                                      //     for (var dip in dipendentiDesignati){
                                                                      //       dip.isChecked=false;
                                                                      //     }
                                                                      //
                                                                      //   }catch(er){
                                                                      //     print(er);
                                                                      //     ScaffoldMessenger.of(context).showSnackBar(
                                                                      //       const SnackBar(content: Text('Errore del Server!')),
                                                                      //     );
                                                                      //   }
                                                                      // },

                                                                    ),
                                                                  ),



                                                                ],
                                                              ),



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

                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context){
                                                return StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState){
                                                      return AlertDialog(
                                                        backgroundColor: Colors.deepPurple.shade100,
                                                        scrollable: true,
                                                        content:Row(
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
                                                                    Text("${item.tipologiaCliente.nome}",  style: TextStyle( fontSize: 18)),
                                                                  ],
                                                                ),

                                                                SizedBox(height: 20,),
                                                                Text("Dipendenti designati: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                                                SizedBox(height: 10,),
                                                                Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: dipendenti.map( (dd) {
                                                                        if(dd.isChecked){
                                                                          return Text("- ${dd.dipendenteNome}"+" "+"${dd.dipendenteCognome}");
                                                                        }
                                                                        else return Text("");
                                                                      }
                                                                    ).toList()


                                                                ),


                                                                SizedBox(height: 20,),

                                                              ],
                                                            ),
                                                            SizedBox(width: 20),
                                                          ],
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
                                                            content: Column(
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
                                                                          String tt=modello!.token!;
                                                                          var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Cliente/ClienteMng'));
                                                                          request.bodyFields = {
                                                                            "clienteId" :item.clienteId.toString(),
                                                                            "tipoOperazione": "D",
                                                                            "utenteId": modello.dipendenteId.toString()
                                                                          };
                                                                          request.headers['Authorization'] = 'Bearer $tt';
                                                                          http.StreamedResponse response = await request.send();
                                                                          response.stream.asBroadcastStream();

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

                                                                        }

                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10,),
                                                              ],
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

                          Text("Clienti", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.grey.shade700) ),
                          Spacer(),
                          SizedBox(width: 30,),
                          ElevatedButton(

                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(20),
                              backgroundColor: Colors.purple.shade200,
                              shape: CircleBorder(),
                            ),

                            onPressed: () {

                            },
                            child: Icon(
                              Icons.add,
                              weight: 15,
                              color: Colors.black,
                              size: 20,
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


  void dipendentiGet() async {

    var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Studio/StudioDipendentiGet'));
    String tt=modello.token!;
    request.bodyFields={
       "studioId": modello!.studioId.toString(),
       "ufficioId": "-1"
    };

    request.headers['Authorization'] = 'Bearer $tt';
    http.StreamedResponse response = await request.send();
    response.stream.asBroadcastStream();

    var jsonData=  jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(jsonData);
      print("");
      for(var dip in jsonData){
        if(dip["superUser"]==false) {
          dipendenti.add(DipendenteDesignato(
              false, dip["dipendenteNome"], dip["dipendenteCognome"],
              dip["dipendenteId"]));
        }
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<http.StreamedResponse> getDipendentiPerCliente(int idCliente) async{
    String tt=modello.token!;
    var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Cliente/ClienteListGet'));
    request.bodyFields = {
      "studioId": modello.studioId.toString(),
      "clienteId": idCliente.toString(),
      "tipologiaClienteId": "null"
    };
    request.headers['Authorization'] = 'Bearer $tt';
    return request.send();
  }

  Future<http.StreamedResponse> categorieClientiGet() async {

    var request = http.Request('POST', Uri.parse('http://www.studiodoc.it/api/Tools/TipologiaClienteListGet'));
    String tt=modello.token!;
    request.bodyFields = {
      "studioId": modello!.studioId.toString(),
      "tipologiaClienteId": "null"};

    request.headers['Authorization'] = 'Bearer $tt';

    return request.send();

  }

  inizializzaDropDown2(TipologiaCliente item){
    for(TipologiaCliente tc in tipoClienti){
      if(tc.idTipologia==item.idTipologia){
        dropdownValue2=tc;
      }
    }
  }

  AlertDialog popUp(String tipo, Cliente? cliente){

    if(tipo=="edit") {
      return AlertDialog();

    }else if(tipo=="add"){
      return AlertDialog();

    }
    // else if(tipo=="read"){
    //   return AlertDialog();
    //
    // }
    else{
      return AlertDialog();

    }
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
  TipologiaCliente tipologiaCliente;
  List<DipendenteDesignato> dipendentiDesignati=[];

  Cliente(
      this.clienteId,
      this.codiceCliente,
      this.studioId,
      this.clienteNome,
      this.clienteCognome,
      this.email,
      this.telefono,
      this.tipologiaCliente,
      this.dipendentiDesignati
  );

}


