import 'package:booklub/Constance/app_color.dart';
import 'package:booklub/pages/messageDatails.dart';
import 'package:booklub/pages/messageScreen.dart';
import 'package:booklub/pages/rating_screen.dart';
import 'package:booklub/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatefulWidget {
  String? image;
  String? name;
  String? author;
  String? price;
  String? method;
  String? userId;
  String? discription;
  String? bookCategoryName;

  BookDetailScreen({
    this.image,
    this.name,
    this.author,
    this.price,
    this.method,
    this.userId,
    this.discription,
    this.bookCategoryName,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 55),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppColor.lightGreyColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(100)),
                        child: Image.asset(
                          "assets/images/detail_back_arrow.png",
                          width: 15,
                          height: 15,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                          widget.image!,
                          width: 200,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Text(
                widget.name ?? "",
                style: const TextStyle(
                  fontFamily: "SF_Pro_Text",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            width: 1,
                            color: AppColor.lightGreyColor.withOpacity(0.2))),
                    child: Row(
                      children: [
                        const Text(
                          "Genre",
                          style: TextStyle(
                              fontFamily: "SF_Pro_Text", fontSize: 16),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          widget.bookCategoryName ?? "",
                          style: const TextStyle(
                            fontFamily: "SF_Pro_Text",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${widget.discription}",
                style: const TextStyle(
                  height: 1.7,
                  fontFamily: "SF_Pro_Text",
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Deals Method",
                style: TextStyle(
                  fontFamily: "SF_Pro_Text",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                          color: AppColor.blueColor,
                          borderRadius: BorderRadius.circular(100)),
                      child: Image.asset(
                        "assets/images/Location.png",
                        width: 15,
                        height: 20,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.method ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: width,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("PRICE"),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "RM ${widget.price}",
                    style: const TextStyle(
                      color: AppColor.blueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return RatingScreen(
                            userId: widget.userId,
                            Image: widget.image!,
                          );
                        },
                      ));
                    },
                    child: Container(
                      width: width * .3,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.blueColor,
                      ),
                      child: const Text(
                        "Rate",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return MessageDetails(
                            userId: "${currentUser[0].uid}_${widget.userId}",
                            otherUserId: widget.userId,
                            senderId: currentUser[0].uid,
                            // receiverId: ,
                          );
                        },
                      ));
                    },
                    child: Container(
                      width: width * .3,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.blueColor,
                      ),
                      child: const Text(
                        "Contact Seller",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
