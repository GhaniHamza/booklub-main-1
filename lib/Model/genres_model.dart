class GenresModel {
  String? color;
  String? image;
  String? name;
  String? id;

  GenresModel({this.color, this.image, this.name});

  GenresModel.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    image = json['image'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color;
    data['image'] = image;
    data['name'] = name;
    return data;
  }
}
