import 'package:booklub/Constance/app_color.dart';
import 'package:booklub/Model/BooksModel.dart';
import 'package:booklub/pages/book_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FreeBookScreen extends StatefulWidget {
  List<BooksModel>? freeBooksList;
  FreeBookScreen({
    this.freeBooksList,
  });

  @override
  State<FreeBookScreen> createState() => _FreeBookScreenState();
}

class _FreeBookScreenState extends State<FreeBookScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
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
                  child: const Text("Free Books",
                      style: TextStyle(fontSize: 20, fontFamily: "Acumin-Pro")),
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 35),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.freeBooksList!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 4,
                crossAxisSpacing: 30,
                mainAxisSpacing: 15,
              ),
              itemBuilder: (context, index) {
                var item = widget.freeBooksList![index];
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return BookDetailScreen(
                          author: item.author,
                          image: item.image,
                          method: item.method,
                          name: item.bookname,
                          price: item.price,
                          userId: item.userid,
                          discription: item.discription,
                          bookCategoryName: item.bookCategoryName,
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
                            item.image ?? "",
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
                              item.bookname ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: "SF_Pro_Text",
                              ),
                            ),
                            Text(
                              item.author ?? "",
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xff929292)),
                            ),
                            Text(
                              "RM ${item.price ?? " "}",
                              style: const TextStyle(color: AppColor.blueColor),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
