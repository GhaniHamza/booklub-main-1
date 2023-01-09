class BooksModel {
  String? image;
  String? bookCategoryName;
  String? bookname;
  String? categoryid;
  String? discription;
  String? method;
  String? price;
  String? userid;
  String? author;
  String? id;
  int? views;

  BooksModel(
      {this.image,
      this.bookname,
      this.bookCategoryName,
      this.categoryid,
      this.discription,
      this.method,
      this.price,
      this.userid,
      this.author,
      this.views});

  BooksModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    bookname = json['bookname'];
    bookCategoryName = json['bookCategoryName'];
    categoryid = json['categoryid'];
    discription = json['discription'];
    method = json['method'];
    price = json['price'];
    userid = json['userid'];
    views = json['views'];
    author = json['author'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['bookname'] = bookname;
    data['bookCategoryName'] = bookCategoryName;
    data['categoryid'] = categoryid;
    data['discription'] = discription;
    data['method'] = method;
    data['price'] = price;
    data['userid'] = userid;
    data['views'] = views;
    data['author'] = author;
    return data;
  }
}
