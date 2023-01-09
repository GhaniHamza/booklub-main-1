class UserModel {
  String? about;
  String? email;
  String? name;
  String? phone;
  String? uid;
  String? username;
  String? profilePic;
  String? id;
  List<dynamic>? reviews;

  UserModel.fromJson(Map<String, dynamic> json) {
    about = json['about'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    uid = json['uid'];
    username = json['username'];
    profilePic = json['profilePic'];
    if (json['reviews'] != null) {
      reviews = json["reviews"];
    }

    // if (json['reviews'] != null) {
    //   reviews = <UserReview>[];
    //   json['reviews'].forEach((v) {
    //     reviews!.add(UserReview.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['about'] = about;
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['uid'] = uid;
    data['username'] = username;
    data['profilePic'] = profilePic;
    if (reviews != null) {
      data['reviews'] = reviews;
    }
    // if (reviews != null) {
    //   data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class UserReview {
  String? bookImage;
  String? reviewText;
  String? reviewerId;
  double? starCount;

  UserReview.fromJson(Map<String, dynamic> Json) {
    Json["bookImage"] = bookImage;
    Json["reviewText"] = reviewText;
    Json["reviewerId"] = reviewerId;
    Json["starCount"] = starCount;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookImage'] = bookImage;
    data['reviewText'] = reviewText;
    data['reviewerId'] = reviewerId;
    data['starCount'] = starCount;
    return data;
  }
}
