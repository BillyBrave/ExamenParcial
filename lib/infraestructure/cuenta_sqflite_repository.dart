import 'package:cuentas_bancarias/infraestructure/cuenta_dao.dart';
import 'package:cuentas_bancarias/infraestructure/cuenta_repository.dart';
import 'package:cuentas_bancarias/infraestructure/database_provider.dart';
import 'package:cuentas_bancarias/model/cuenta.dart';

class CuentaSqfliteRepository implements CuentaRepository {
  final dao = CuentaDao();

  @override
  DatabaseProvider databaseProvider;

  CuentaSqfliteRepository(this.databaseProvider);

  @override
  Future<int> insert(Cuenta cuenta) async {
    final db = await databaseProvider.db();
    var id = await db.insert(dao.tableName, dao.toMap(cuenta));
    return id;
  }

  @override
  Future<int> delete(Cuenta cuenta) async {
    final db = await databaseProvider.db();
    int result = await db.delete(dao.tableName,
        where: dao.columnId + " = ?", whereArgs: [cuenta.id]);
    return result;
  }

  @override
  Future<int> update(Cuenta cuenta) async {
    final db = await databaseProvider.db();
    int result = await db.update(dao.tableName, dao.toMap(cuenta),
        where: dao.columnId + " = ?", whereArgs: [cuenta.id]);
    return result;
  }

  @override
  Future<List<Cuenta>> getList() async {
    final db = await databaseProvider.db();
    var result = await db.rawQuery("SELECT * FROM cuenta");
    return dao.fromList(result);
  }
}