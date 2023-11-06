


class Modello {
  static final Modello _singleton = Modello._internal();

  factory Modello() {
    return _singleton;
  }

  Modello._internal();


   String? token=null;
   String? token_type=null;
   int? expiration=null;
   //le faccio statiche ???

}

