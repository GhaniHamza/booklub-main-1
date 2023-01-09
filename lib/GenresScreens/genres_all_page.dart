import 'package:booklub/Constance/app_color.dart';
import 'package:booklub/GenresScreens/category_book.dart';
import 'package:booklub/Model/genres_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GenresAll extends StatefulWidget {
  @override
  State<GenresAll> createState() => _GenresAllState();
}

// FirebaseFirestore firestore = FirebaseFirestore.instance;
class _GenresAllState extends State<GenresAll> {
  bool isDataLoaded = false;

  List<GenresModel> booksList = [];
  List<GenresModel> genresDataList = [];

  Future<void> getBooksData() async {
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("books").get();
    List<QueryDocumentSnapshot> docs = data.docs;
    for (var e in docs) {
      booksList.add(
          GenresModel.fromJson(e.data() as Map<String, dynamic>)..id = e.id);
    }
    setState(() {});
  }

  // Future<void> getData() async {
  //   QuerySnapshot data = await FirebaseFirestore.instance
  //       .collection("books")
  //       .where("categoryid", isEqualTo: widget.bookID)
  //       .get();
  //
  //   List<QueryDocumentSnapshot> doc = data.docs;
  //
  //   for (var element in doc) {
  //     fictionList
  //         .add(BooksModel.fromJson(element.data() as Map<String, dynamic>));
  //   }
  //   setState(() {});
  // }

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

  List<Color> color = [
    Color(0xff0E6A500),
    Color(0xff229A46),
    Color(0xffEF4C45),
    Color(0xffB7143C),
    Color(0xffF46217),
    Color(0xffAB4B1A),
    Color(0xffF14B74),
    Color(0xff09ADE2),
    Color(0xffD36A43),
    Color(0xffEFBE40),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: !isDataLoaded
            ? SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 55, left: 25),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                                "assets/images/Group 3884.svg")),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Divider(
                    thickness: 1,
                    color: AppColor.lightGreyColor.withOpacity(0.2),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      "Genres",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color(0xff424242),
                          fontFamily: "SF_Pro_Text"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: genresDataList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return CategoryBookScreen(
                                  bookID: genresDataList[index].id,
                                  title: genresDataList[index].name,
                                );
                              },
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: color[index],
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(2, 2),
                                    spreadRadius: 7,
                                    blurRadius: 15,
                                    color: Colors.black.withOpacity(0.1)),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 25),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    genresDataList[index].name ?? "",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "SF_Pro_Text"),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(2, 3),
                                              blurRadius: 10,
                                              spreadRadius: 10,
                                              color:
                                                  Colors.black.withOpacity(0.1))
                                        ]),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          genresDataList[index].image ?? "",
                                          width: width * .25,
                                          height: height * .18,
                                          fit: BoxFit.fill,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        // child: ;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ))
            : const Center(child: CircularProgressIndicator()));
  }
}
