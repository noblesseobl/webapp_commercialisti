


class Modello {
  static final Modello _singleton = Modello._internal();


  factory Modello() {
    return _singleton;
  }

  dispose(){
    token=null;
    token_type=null;
    expiration=null;
    dipendenteId=null;
    codiceUtente=null;
    nome=null;
    cognome=null;
    ufficioId=null;
    ufficioDescr=null;
    email=null;
    telefono=null;
    admin=true;
    studioId=null;
    studioNome=null;
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
  //bool? superAdmin=true;
  int? studioId=null;
  String? studioNome=null;
  //le faccio statiche ???

}

