
class Modello {
  Modello? _instanza= null;


  _Modello() {
    // TODO: implement _Modello
    throw UnimplementedError();
  }

  Modello? getModello(){
    if (_instanza==null){
      _instanza=_Modello();
    }
    return _instanza;
  }

}


String? token=null;
String? token_type=null;
int? expiration=null;