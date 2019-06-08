import 'package:flutter/material.dart';
import 'package:cuentas_bancarias/infraestructure/cuenta_sqflite_repository.dart';
import 'package:cuentas_bancarias/infraestructure/database_provider.dart';
import 'package:cuentas_bancarias/model/cuenta.dart';

CuentaSqfliteRepository cuentaRepository = CuentaSqfliteRepository(DatabaseProvider.get);
final List<String> choices = const <String> [
  'Grabar Cuenta & Regresar',
  'Eliminar Cuenta',
  'Regresar a la lista'
];

const mnuSave = 'Grabar Cuenta & Regresar';
const mnuDelete = 'Eliminar Cuenta';
const mnuBack = 'Regresar a la lista';

class CuentaDetail extends StatefulWidget {
  final Cuenta cuenta;
  CuentaDetail(this.cuenta);

  @override
  State<StatefulWidget> createState() => CuentaDetailState(cuenta);
}

class CuentaDetailState extends State<CuentaDetail> {
  Cuenta cuenta;
  CuentaDetailState(this.cuenta);
  TextEditingController numeroController = TextEditingController();
  TextEditingController montoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
  //  nameController.text = cuenta.name;
  //  descriptionController.text = cuenta.description;
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Cuenta : ' + cuenta.numero.toString()),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: select,
            itemBuilder: (BuildContext context) {
              return choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding( 
        padding: EdgeInsets.only(top:35.0, left: 10.0, right: 10.0),
        child: ListView(children: <Widget>[Column(
        children: <Widget>[ 
          TextField(
            controller: numeroController,
            style: textStyle,
            onChanged: (value) => this.updateNumero(),
            decoration: InputDecoration(
              labelText: "Numero de Cuenta",
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:15.0, bottom: 15.0),
            child: TextField(
            controller: montoController,
            style: textStyle,
            onChanged: (value) => this.updateMonto(),
            decoration: InputDecoration(
              labelText: "Monto",
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              )
            ),
          )),
          //aqui van el deposito yr etiro
        ],
      )],)
      )
    );
  }

  void select (String value) async {
    int result;
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        Navigator.pop(context, true);
        if (cuenta.id == null) {
          return;
        }
        result = await cuentaRepository.delete(cuenta);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Cuenta"),
            content: Text("The Cuenta has been deleted"),
          );
          showDialog(
            context: context,
            builder: (_) => alertDialog);
          
        }
        break;
        case mnuBack:
          Navigator.pop(context, true);
          break;
      default:
    }
  }

  void save() {
    if (cuenta.id != null) {
      debugPrint('update');
      cuentaRepository.update(cuenta);
    }
    else {
      debugPrint('insert');
      cuentaRepository.insert(cuenta);
    }
    Navigator.pop(context, true);
  }

  void updateMonto() {
    cuenta.monto = int.parse(montoController.text);
  }

    void updateNumero() {
    cuenta.numero = numeroController.text;
  }
}
