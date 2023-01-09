import 'package:booklub/Constance/app_color.dart';
import 'package:booklub/Constance/search.dart';
import 'package:booklub/GenresScreens/category_book.dart';
import 'package:booklub/GenresScreens/genres_all_page.dart';
import 'package:booklub/Model/BooksModel.dart';
import 'package:booklub/Model/genres_model.dart';
import 'package:booklub/pages/book_detail.dart';
import 'package:booklub/pages/free_book_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BooksModel> booksList = [];
  List<BooksModel> booksListDuplicate = [];
  List<GenresModel> genresDataList = [];
  List<BooksModel> freeBookList = [];

  Future<void> getData() async {
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("Generes").get();
    List<QueryDocumentSnapshot> docs = data.docs;
    docs.forEach((e) {
      genresDataList.add(
          GenresModel.fromJson(e.data() as Map<String, dynamic>)..id = e.id);
    });
    setState(() {});
  }

  Future<void> getBooksData() async {
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("books").get();
    List<QueryDocumentSnapshot> docs = data.docs;
    for (var e in docs) {
      booksList.add(
          BooksModel.fromJson(e.data() as Map<String, dynamic>)..id = e.id);
    }
    booksListDuplicate = booksList;
  }

  Future<void> getFreeBookData() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("books")
        .where("price", isEqualTo: "0")
        .get();
    List<QueryDocumentSnapshot> docs = data.docs;
    docs.forEach((e) {
      freeBookList.add(
          BooksModel.fromJson(e.data() as Map<String, dynamic>)..id = e.id);
    });
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getBooksData();
    getFreeBookData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 58),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "BookLub",
                style: TextStyle(
                  fontSize: width * .13,
                  color: AppColor.textColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat_Alternates",
                ),
              ),
            ),
            buildSearch(),
            // Padding(
            //   padding: const EdgeInsets.only(top: 23, left: 30, right: 30),
            //   child: TextField(
            //     onChanged: (value) {
            //       searchBook("");
            //       // final books1 = booksList.where((element) {
            //       //   final titleLower = element.bookname!.toLowerCase() +
            //       //       element.author!.toLowerCase();
            //       //   final searchLower = query1.toLowerCase();
            //       //
            //       //   return titleLower.contains(searchLower);
            //       // }).toList();
            //       //
            //       // setState(() {
            //       //   // query = query1;
            //       //   booksListDuplicate = books1;
            //       // });
            //     },
            //     decoration: InputDecoration(
            //       contentPadding: const EdgeInsets.only(left: 52),
            //       hintText: "Search Books, Authors, or ISBN",
            //       hintStyle: const TextStyle(color: AppColor.lightGreyColor),
            //       border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(100)),
            //       focusColor: AppColor.lightGreyColor.withOpacity(0.1),
            //       fillColor: AppColor.lightGreyColor.withOpacity(0.1),
            //       filled: true,
            //       enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide.none,
            //           borderRadius: BorderRadius.circular(100)),
            //       focusedBorder: OutlineInputBorder(
            //           borderSide: BorderSide.none,
            //           borderRadius: BorderRadius.circular(100)),
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 15,
            ),
            Divider(
              thickness: 1,
              color: AppColor.lightGreyColor.withOpacity(0.1),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Genres",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(0xff424242),
                        fontFamily: "SF_Pro_Text"),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return GenresAll();
                        },
                      ));
                    },
                    child: const Text(
                      "View All",
                      style: TextStyle(color: AppColor.lightGreyColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                      genresDataList.length,
                      (index) => InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return CategoryBookScreen(
                                    title: genresDataList[index].name,
                                    bookID: genresDataList[index].id,
                                  );
                                },
                              ));
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(left: index == 0 ? 30 : 15),
                              decoration: BoxDecoration(
                                  color: const Color(0xffFFF8EA),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 17, vertical: 10),
                                child: Text(
                                  genresDataList[index].name ?? "",
                                  style: const TextStyle(
                                      color: AppColor.lightGreyColor),
                                ),
                              ),
                            ),
                          )),
                  const SizedBox(
                    width: 30,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Free Books",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "acumin-pro-cufonfonts",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return FreeBookScreen(
                            freeBooksList: freeBookList,
                          );
                        },
                      ));
                    },
                    child: const Text(
                      "View All",
                      style: TextStyle(color: AppColor.lightGreyColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            freeBookList.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                          children: List.generate(
                              freeBookList.length,
                              (index) => InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return BookDetailScreen(
                                            author: freeBookList[index].author,
                                            image: freeBookList[index].image,
                                            method: freeBookList[index].method,
                                            name: freeBookList[index].bookname,
                                            price: freeBookList[index].price,
                                            userId: freeBookList[index].userid,
                                            discription:
                                                freeBookList[index].discription,
                                            bookCategoryName:
                                                freeBookList[index]
                                                    .bookCategoryName,
                                          );
                                        },
                                      ));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 20),
                                      width: 105,
                                      height: 145,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            offset: const Offset(-2, 3),
                                            spreadRadius: 5,
                                            blurRadius: 10,
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(18),
                                        color: Colors.pinkAccent,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.network(
                                          freeBookList[index].image ?? "",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ))),
                    ),
                  )
                : Container(
                    width: width,
                    height: 80,
                    alignment: Alignment.center,
                    child: Text("No Free Books Are Available!!"),
                  ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Best Selling",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: "acumin-pro-cufonfonts",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            booksListDuplicate.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: booksListDuplicate.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return BookDetailScreen(
                                  author: booksListDuplicate[index].author,
                                  image: booksListDuplicate[index].image,
                                  method: booksListDuplicate[index].method,
                                  name: booksListDuplicate[index].bookname,
                                  price: booksListDuplicate[index].price,
                                  userId: booksListDuplicate[index].userid,
                                  discription:
                                      booksListDuplicate[index].discription,
                                  bookCategoryName: booksListDuplicate[index]
                                      .bookCategoryName,
                                );
                              },
                            ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              booksListDuplicate[index].image ?? "",
                              width: 200,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(child: Text("No books are available!!")),
                  ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }

  Widget buildSearch() => SearchWidget(
        text: "",
        onChanged: searchBook,
        hintText: "Search Books, Authors, or ISBN",
      );

  void searchBook(String query1) {
    setState(() {
      final books1 = booksList.where((element) {
        final titleLower =
            element.bookname!.toLowerCase() + element.author!.toLowerCase();
        final searchLower = query1.toLowerCase();

        return titleLower.contains(searchLower);
      }).toList();
      booksListDuplicate = books1;
    });
  }
}
