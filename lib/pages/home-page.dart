import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  double saldo = 1563.32232;

  final NumberFormat numberFormat = NumberFormat('#,##0.00', 'pt_BR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.green,
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.monetization_on, size: 70),
              title: Text(
                'Saldo Inicial do Mês:',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'R\$ ${numberFormat.format(saldo)}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ButtonBarTheme(
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('Próximos meses',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {},
                  ),
                ],
              ),
              data: ButtonBarThemeData(alignment: MainAxisAlignment.end),
            ),
          ],
        ),
      ),
    );
  }
}
