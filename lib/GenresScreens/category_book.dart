import 'package:booklub/Constance/app_color.dart';
import 'package:booklub/Model/BooksModel.dart';
import 'package:booklub/pages/book_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryBookScreen extends StatefulWidget {
  String? title;
  String? bookID;
  CategoryBookScreen({this.title, this.bookID});

  @override
  State<CategoryBookScreen> createState() => _CategoryBookScreenState();
}

class _CategoryBookScreenState extends State<CategoryBookScreen> {
  List<BooksModel> fictionList = [];

  Future<void> getData() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("books")
        .where("categoryid", isEqualTo: widget.bookID)
        .get();

    List<QueryDocumentSnapshot> doc = data.docs;

    for (var element in doc) {
      fictionList
          .add(BooksModel.fromJson(element.data() as Map<String, dynamic>));
    }
    setState(() {});
  }

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
        body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 55, left: 25),
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset("assets/images/Group 3884.svg")),
                Padding(
                  padding: EdgeInsets.only(left: width * .25),
                  child: Text(widget.title ?? "",
                      style: const TextStyle(
                          fontSize: 20, fontFamily: "Acumin-Pro")),
                )
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
          fictionList.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: fictionList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 4,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return BookDetailScreen(
                                author: fictionList[index].author,
                                image: fictionList[index].image,
                                method: fictionList[index].method,
                                name: fictionList[index].bookname,
                                price: fictionList[index].price,
                                userId: fictionList[index].userid,
                                discription: fictionList[index].discription,
                                bookCategoryName:
                                    fictionList[index].bookCategoryName,
                              );
                            },
                          ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(2, 2),
                                    spreadRadius: 8,
                                    blurRadius: 15,
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  fictionList[index].image ?? "",
                                  width: width * .5,
                                  height: height * .25,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fictionList[index].bookname ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: "SF_Pro_Text",
                                    ),
                                  ),
                                  Text(
                                    fictionList[index].author ?? "",
                                    style: const TextStyle(
                                        fontSize: 14, color: Color(0xff929292)),
                                  ),
                                  Text(
                                    "RM ${fictionList[index].price ?? " "}",
                                    style: const TextStyle(
                                        color: AppColor.blueColor),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              : SizedBox(
                  width: width,
                  height: height - 170,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "No book available!!",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )
        ],
      ),
    ));
  }
}
