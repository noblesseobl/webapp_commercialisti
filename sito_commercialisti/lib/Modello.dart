


class Modello {
  static final Modello _singleton = Modello._internal();


  factory Modello() {
    return _singleton;
  }

  Modello._internal();


   String? token=null;
   String? token_type=null;
   int? expiration=null;
   int? dipendenteId=null;


  String? codiceUtente=null;
  String? nome=null;
  String? cognome=null;
  int? ufficioId=null;
  String? ufficioDescr=null;
  String? email=null;
  String? telefono=null;
  bool? admin=true;
  int? studioId=null;
  String? studioNome=null;
   //le faccio statiche ???

}

