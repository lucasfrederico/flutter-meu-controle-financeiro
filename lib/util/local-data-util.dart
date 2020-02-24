import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalDataUtil<T> {
  List<T> list = [];
  String savedFileName;

  LocalDataUtil(this.savedFileName);

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/$savedFileName.json");
  }

  Future<File> saveData() async {
    String data = jsonEncode(list);

    final file = await getFile();
    return file.writeAsString(data);
  }

  Future<String> readData() async {
    try {
      final file = await getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
