
class SurahModel {
  List<Data>? data;

  SurahModel({this.data});

  SurahModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

}



class Data {
  int? ayaNum;
  int? numOfAyahs;
  String? nameAr;
  String? nameEn;
  String? type;

  Data({
    required this.ayaNum,
    required this.numOfAyahs,
    required this.nameAr,
    required this.nameEn,
    required this.type,
  });

  Data.fromJson(Map<String, dynamic> json) {
    ayaNum = json['number'];
    numOfAyahs = json['numberOfAyahs'];
    nameAr = json['name'];
    nameEn = json['englishName'];
    type = json['revelationType'];

  }
}
