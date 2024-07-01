import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hasanat/models/pages_data_model.dart';
import 'package:hasanat/models/surah_data_model.dart';

class SurahData {

  Future<SurahModel> getSurahData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/quranData/quran_metadata/ayahs.json');
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return SurahModel.fromJson(jsonMap);
    } catch (e) {
      throw Exception("Error reading JSON file: $e");
    }
  }

  Future<List<PagesModel>> getPagesData(String fileName) async {
    // Load JSON file from assets
    String jsonString = await rootBundle.loadString('assets/quranData/quran_metadata/$fileName.json');

    // Parse JSON
    List<dynamic> jsonList = jsonDecode(jsonString);

    // Convert JSON to List<PagesModel>
    List<PagesModel> pagesModelList = jsonList.map((json) => PagesModel.fromJson(json)).toList();

    return pagesModelList;
  }
}