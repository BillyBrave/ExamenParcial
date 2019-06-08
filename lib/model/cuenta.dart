class Cuenta {
  int _id;
  String _numero;
  int _monto;
  int _numdep;
  int _numret;

  Cuenta(this._numero,this._monto, this._numdep, this._numret);
  Cuenta.withId(this._id,this._numero, this._monto, this._numdep, this._numret);

  int get id => _id;
  String get numero => _numero;
  int get monto => _monto;
  int get numdep => _numdep;
  int get numret => _numret;
 
 
   set numero (String numero) {    
      _numero = numero;
  }
  set monto (int monto) {    
      _monto = monto;
  }

  set numdep (int numdep) {    
      _numdep = numdep;
  }

  set numret (int numret) {
      _numret = numret;
  }
}
