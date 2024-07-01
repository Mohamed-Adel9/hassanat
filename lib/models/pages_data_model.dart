class PagesModel {

  String? page;
  String? index;



  PagesModel(
      {
        this.page,
        this.index
        });

  PagesModel.fromJson(Map<String, dynamic> json) {

    page = json['page'];
    index = json['index'];

  }

}



