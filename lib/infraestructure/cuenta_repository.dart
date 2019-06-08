import 'package:cuentas_bancarias/infraestructure/database_provider.dart';
import 'package:cuentas_bancarias/model/cuenta.dart';

abstract class CuentaRepository {
  DatabaseProvider databaseProvider;
  Future<int> insert(Cuenta cuenta);
  Future<int> update(Cuenta cuenta);
  Future<int> delete(Cuenta cuenta);
  Future<List<Cuenta>> getList();
}