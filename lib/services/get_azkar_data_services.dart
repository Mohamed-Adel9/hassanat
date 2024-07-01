import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hasanat/models/azkar_model.dart';

class AzkarDataServices {
  Future<List<AzkarModel>> getAzkarData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/quranData/azkar.json');
      List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.map((item) => AzkarModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception("Error reading JSON file: $e");
    }
  }
}
