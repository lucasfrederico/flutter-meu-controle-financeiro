import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meu_controle_financeiro/models/debt.dart';
import 'package:meu_controle_financeiro/util/local-data-util.dart';

class DebtsPage extends StatefulWidget {
  @override
  _DebtsPageState createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  final NumberFormat numberFormat = NumberFormat('#,##0.00', 'pt_BR');
  final dateFormat = DateFormat("dd/MM/yyyy");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionEditingController =
      TextEditingController();

  final TextEditingController _valueEditingController = TextEditingController();

  final TextEditingController _dateToFinishEditingController =
      TextEditingController();

  LocalDataUtil<Debt> dataUtil = LocalDataUtil<Debt>("debts");

  Debt _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();
    reloadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.only(top: 10.0),
        itemCount: dataUtil.list.length,
        itemBuilder: buildItem,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: buildTextField(
                            "Descrição",
                            _descriptionEditingController,
                            TextInputType.text,
                            false,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: buildTextField(
                            "Valor",
                            _valueEditingController,
                            TextInputType.number,
                            false,
                            prefix: "R\$ ",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: buidDateTimeField(
                            "Data Fim",
                            _dateToFinishEditingController,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: RaisedButton(
                            child: Text("Salvar"),
                            onPressed: () {
                              submitSave();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildItem(context, index) {
    final item = dataUtil.list[index];

    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: ListTile(
        title: Text(item.description),
        subtitle: Text("R\$ ${numberFormat.format(item.value)}"),
        leading: CircleAvatar(
          child: Icon(
            Icons.call_received,
            color: Colors.red,
          ),
        ),
        trailing: Text("até ${dateFormat.format(item.dateToFinish)}"),
      ),
      onDismissed: (direction) {
        _lastRemoved = item;
        _lastRemovedPos = index;
        dataUtil.list.removeAt(index);

        setState(() {
          dataUtil.saveData();
        });

        final snack = SnackBar(
            content: Text("Dívida ${_lastRemoved.description} removida!"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                dataUtil.list.insert(_lastRemovedPos, _lastRemoved);
                setState(() {
                  dataUtil.saveData();
                });
              },
            ),
            duration: Duration(seconds: 2));

        Scaffold.of(context).showSnackBar(snack);
      },
    );
  }

  void submitSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final String description = _descriptionEditingController.text;
      final double value = double.parse(_valueEditingController.text);
      final DateTime dateToFinish =
          dateFormat.parse(_dateToFinishEditingController.text);

      final Debt objToSave = Debt(
          description: description, value: value, dateToFinish: dateToFinish);

      dataUtil.list.add(objToSave);
      setState(() {
        dataUtil.saveData();
      });
    }
  }

  void reloadData() {
    dataUtil.readData().then((data) {
      setState(() {
        dataUtil.list = Debt.parseJson(data);
      });
    });
  }
}

Widget buildTextField(String label, TextEditingController controller,
    TextInputType inputType, bool autofocus,
    {String prefix}) {
  return TextFormField(
    controller: controller,
    autofocus: autofocus,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      prefixText: prefix,
      focusedBorder: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
    ),
    keyboardType: inputType,
  );
}

Widget buidDateTimeField(String label, TextEditingController controller) {
  final format = DateFormat("dd/MM/yyyy");
  final dateNow = DateTime.now();

  return Column(children: <Widget>[
    DateTimeField(
      format: format,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      controller: controller,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime.utc(dateNow.year, dateNow.month, dateNow.day),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(3000));
      },
    ),
  ]);
}
