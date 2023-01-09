class SingleBookModel {
  late String imgAssetPath;
  late String title;
  late String categorie;
}

class BookModel {
  late String imgAssetPath;
  late String title;
  late String description;
  late String categorie;
  late int rating;
}

List<BookModel> getBooks() {
  List<BookModel> books = <BookModel>[];
  BookModel bookModel = BookModel();

  //1
  bookModel.imgAssetPath = "images/ff.png";
  bookModel.title = "The little mermaid";
  bookModel.description = '''“The Little Mermaid” is a
 fairy tale written by the Danish author Hans
 Christian Andersen.''';
  bookModel.rating = 5;
  bookModel.categorie = "Fairy Tailes";

  books.add(bookModel);
  bookModel = BookModel();

  //1
  bookModel.imgAssetPath = "images/ff.png";
  bookModel.title = "Willows Of Fate";
  bookModel.description =
      '''Is there room in the hands of fate for free will?All her life, Desdemona has seen things others haven’t.''';
  bookModel.rating = 4;
  bookModel.categorie = "Drama";

  books.add(bookModel);
  bookModel = BookModel();

  return books;
}

List<SingleBookModel> getSingleBooks() {
  List<SingleBookModel> books = <SingleBookModel>[];
  SingleBookModel singleBookModel = SingleBookModel();

  //1
  singleBookModel.imgAssetPath = "images/book_cover.jpeg";
  singleBookModel.title = "Siz of crows";
  singleBookModel.categorie = "Classic";
  books.add(singleBookModel);

  singleBookModel = SingleBookModel();

  //2
  singleBookModel.imgAssetPath = "images/book_cover.jpeg";
  singleBookModel.title = "Tim of Witched";
  singleBookModel.categorie = "Anthology";
  books.add(singleBookModel);

  singleBookModel = SingleBookModel();

  //3
  singleBookModel.imgAssetPath = "images/book_cover.jpeg";
  singleBookModel.title = "Infinite futures";
  singleBookModel.categorie = "Mystery";
  books.add(singleBookModel);

  singleBookModel = SingleBookModel();

  //4
  singleBookModel.imgAssetPath = "images/book_cover.jpeg";
  singleBookModel.title = "Sun the moon";
  singleBookModel.categorie = "Romance";
  books.add(singleBookModel);

  singleBookModel = SingleBookModel();

  //1
  singleBookModel.imgAssetPath = "images/ff.png";
  singleBookModel.title = "Dancing with Tiger";
  singleBookModel.categorie = "Comic";
  books.add(singleBookModel);

  singleBookModel = SingleBookModel();

  return books;
}
