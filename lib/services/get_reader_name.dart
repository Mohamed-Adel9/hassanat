
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hasanat/models/reader_name_model.dart';

class ReaderNameServices {
  Future<List<ReaderName>> getReaderName() async {
    try {
      String jsonString = await rootBundle.loadString('assets/json/reader.json');
      List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.map((item) => ReaderName.fromJson(item)).toList();
    } catch (e) {
      throw Exception("Error reading JSON file: $e");
    }
  }
}