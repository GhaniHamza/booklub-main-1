class CommentMessagesModel {
  List<String>? message;

  String? id;

  CommentMessagesModel.fromJson(Map<String, dynamic> Json) {
    if (Json["message"]) {
      message = Json["message"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message;
    }
    return data;
  }
}
