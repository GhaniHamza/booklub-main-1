class LikeModel {
  String? like;
  String? id;

  LikeModel.fromJson(Map<String, dynamic> Json) {
    like = Json["like"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['like'] = like;
    return data;
  }
}
