class ReaderName {
  String? identifier;
  String? name;

  ReaderName({
    this.identifier,
    this.name,
  });

  ReaderName.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    name = json['name'];
  }
}
