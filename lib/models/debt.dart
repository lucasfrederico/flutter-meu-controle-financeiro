import 'dart:convert';

class Debt {
  String description;
  double value;
  DateTime dateToFinish;

  Debt({this.description, this.value, this.dateToFinish});

  Debt.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    value = json['value'];
    dateToFinish = DateTime.parse(json['dateToFinish'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['value'] = this.value;
    data['dateToFinish'] = this.dateToFinish.toString();
    return data;
  }

  static List<Debt> parseJson(String response) {
    List<Debt> debts = new List<Debt>();
    List jsonParsed = json.decode(response.toString());
    for (int i = 0; i < jsonParsed.length; i++) {
      debts.add(Debt.fromJson(jsonParsed[i]));
    }
    return debts;
  }
}
