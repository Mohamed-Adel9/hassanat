class AzkarModel {
  String? category;
  String? count;
  String? description;
  String? zekr;

  AzkarModel({
    this.category,
    this.count,
    this.description,
    this.zekr,
  });

  AzkarModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    count = json['count'];
    description = json['description'];
    zekr = json['zekr'];
  }
}
