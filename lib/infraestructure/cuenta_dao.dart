import 'package:cuentas_bancarias/infraestructure/dao.dart';
import 'package:cuentas_bancarias/model/cuenta.dart';

class CuentaDao implements Dao<Cuenta> {
  final tableName = 'cuenta';
  final columnId = 'id';
  final _columnNumero = 'numero';
  final _columnMonto = 'monto';
  final _columnNumDep = 'numdep';
  final _columnNumRet = 'numret';


  @override
  String get createTableQuery =>
    "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY,"
    " $_columnNumero TEXT,"
    " $_columnMonto INTEGER,"
    " $_columnNumDep INTEGER,"
    " $_columnNumRet INTEGER)";

  @override
  Cuenta fromMap(Map<String, dynamic> query) {
    Cuenta cuenta = Cuenta(query[_columnNumero],query[_columnMonto],query[_columnNumDep], query[_columnNumRet]);
    return cuenta;
  }

  @override
  Map<String, dynamic> toMap(Cuenta cuenta) {
    return <String, dynamic>{
       _columnNumero: cuenta.numero,
       _columnMonto: cuenta.monto,
      _columnNumDep: cuenta.numdep,
      _columnNumRet: cuenta.numret
    };
  }

  Cuenta fromDbRow(dynamic row) {
    return Cuenta.withId(row[columnId], row[_columnNumero],row[_columnMonto], row[_columnNumDep], row[_columnNumRet]);
  }

  @override
  List<Cuenta> fromList(result) {
    List<Cuenta> cuentas = List<Cuenta>();
    var count = result.length;
    for (int i = 0; i < count; i++) {
      cuentas.add(fromDbRow(result[i]));
    }
    return cuentas;
  }
}
