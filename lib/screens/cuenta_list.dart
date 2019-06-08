import 'package:flutter/material.dart';
import 'package:cuentas_bancarias/infraestructure/cuenta_sqflite_repository.dart';
import 'package:cuentas_bancarias/infraestructure/database_provider.dart';
import 'package:cuentas_bancarias/model/cuenta.dart';
import 'package:cuentas_bancarias/screens/cuenta_detail.dart';
import 'package:cuentas_bancarias/screens/cuenta_transaccion.dart';
class CuentaList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CuentaListState();
}

class CuentaListState extends State<CuentaList> {
  CuentaSqfliteRepository cuentaRepository = CuentaSqfliteRepository(DatabaseProvider.get);
  List<Cuenta> cuentas;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (cuentas == null) {
      cuentas = List<Cuenta>();
      getData();
    }
    return Scaffold(
      body: cuentaListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          navigateToDetail(Cuenta('',0,0,0));
        }
        ,
        tooltip: "Crear Nueva Cuenta",
        child: new Icon(Icons.add),
      ),
    );
  }
  
  ListView cuentaListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.green,
          elevation: 5.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColor(this.cuentas[position].monto),
              child:Text(position.toString()),
            ),
          title: Text(this.cuentas[position].numero.toString()),
          subtitle: Text(this.cuentas[position].monto.toString()),
          onTap: () {
            debugPrint("Tapped on " + (this.cuentas[position].id+1).toString());
            navigateToModify(this.cuentas[position]);
          },
          ),
        );
      },
    );
  }
  
  void getData() {    
      final cuentasFuture = cuentaRepository.getList();
      cuentasFuture.then((cuentaList) {
        setState(() {
          cuentas = cuentaList;
          count = cuentaList.length;
        });
        debugPrint("Items " + count.toString());
      });
  }

  Color getColor(int monto) {
    if  (monto<1000) 
      
        return Colors.red;
    else
        if (monto<5000)
            return Colors.orange;
        else
        
            return Colors.yellow;
    
    
  }

  void navigateToDetail(Cuenta cuenta) async {
    bool result = await Navigator.push(context, 
        MaterialPageRoute(builder: (context) => CuentaDetail(cuenta)),
    );
    if (result == true) {
      getData();
    }
  }
    void navigateToModify(Cuenta cuenta) async {
    bool result = await Navigator.push(context, 
        MaterialPageRoute(builder: (context) => CuentaTransaccion(cuenta)),
    );
    if (result == true) {
      getData();
    }
  }
}
