import 'package:flutter/material.dart';
import 'package:cuentas_bancarias/infraestructure/cuenta_sqflite_repository.dart';
import 'package:cuentas_bancarias/infraestructure/database_provider.dart';
import 'package:cuentas_bancarias/model/cuenta.dart';
import 'package:cuentas_bancarias/components/reusable_card.dart';
import 'package:cuentas_bancarias/components/icon_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cuentas_bancarias/app_constants.dart';
CuentaSqfliteRepository cuentaRepository = CuentaSqfliteRepository(DatabaseProvider.get);
final List<String> choices = const <String> [
  'Grabar Transaccion & Regresar',
  'Cancelar'
];
enum Transaccion { deposito, retiro }

const mnuSave = 'Grabar Transaccion & Regresar';
const mnuBack = 'Cancelar';

class CuentaTransaccion extends StatefulWidget {
  final Cuenta cuenta;
  CuentaTransaccion(this.cuenta);

  @override
  State<StatefulWidget> createState() => CuentaTransaccionState(cuenta);
}

class CuentaTransaccionState extends State<CuentaTransaccion> {
  Cuenta cuenta;
  int cantidad=0;
   Transaccion selectedTransaccion;
  CuentaTransaccionState(this.cuenta);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TRANSACCION para : '+cuenta.numero),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        selectedTransaccion = Transaccion.deposito;
                      });
                    },
                    color: selectedTransaccion == Transaccion.deposito
                        ? kActiveCardColor
                        : kInactiveCardColor,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.mars,
                      label: 'DEPOSITO',
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        selectedTransaccion = Transaccion.retiro;
                      });
                    },
                    color: selectedTransaccion == Transaccion.retiro
                        ? kActiveCardColor
                        : kInactiveCardColor,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.venus,
                      label: 'RETIRO',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReusableCard(
              color: kActiveCardColor,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'CANTIDAD',
                    style: kLabelTextStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        cantidad.toString(),
                        style: kNumberTextStyle,
                      ),
                      Text(
                        ' Soles',
                        style: kLabelTextStyle,
                      )
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      inactiveTrackColor: Color(0xFF8D8E98),
                      activeTrackColor: Colors.white,
                      thumbColor: Color(0xFFEB1555),
                      overlayColor: Color(0x15EB1555),
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 30.0),
                    ),
                    child: Slider(
                      value: cantidad.toDouble(),
                      min: 0.0,
                      max: 3000.0,
                      onChanged: (double newValue) {
                        setState(() {
                          cantidad = newValue.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          )

 

        ],
      ),
    );
  }

  void select (String value) async {
   
    switch (value) {
      case mnuSave:
        save();
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
      updateMonto();
      cuentaRepository.update(cuenta);
    }
    
    Navigator.pop(context, true);
  }

  void updateMonto() {
   // int cantidad=int.parse(cantidadController.text);
    if (selectedTransaccion == Transaccion.deposito)
     {     cuenta.monto = cuenta.monto+cantidad;
          cuenta.numdep=cuenta.numdep+1;
     }
    if (selectedTransaccion == Transaccion.retiro)
        if (cuenta.monto>=cantidad) 
          { cuenta.monto = cuenta.monto-cantidad;
            cuenta.numret=cuenta.numret+1;
          }
  }

}
