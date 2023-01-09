import 'package:booklub/Model/user_model.dart';
import 'package:booklub/pages/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RatingScreen extends StatefulWidget {
  String? userId;
  String? Image;
  RatingScreen({this.userId, this.Image});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  TextEditingController reviewController = TextEditingController();

  String? userProfile;
  String? userName;
  double ratingCount = 1;
  List<dynamic> userMap = [];
  bool isLoading = false;

  List<UserModel> userDataList = [];
  Future<void> getUserData() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: widget.userId)
        .get();
    List<QueryDocumentSnapshot> docs = data.docs;
    docs.forEach((e) {
      userDataList
          .add(UserModel.fromJson(e.data() as Map<String, dynamic>)..id = e.id);
    });
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData().then((value) {
      userProfile = userDataList[0].profilePic ??
          "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png";
      userName = userDataList[0].name;
      userMap = userDataList[0].reviews!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          height: height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 45, bottom: 15),
                    width: double.infinity,
                    color: const Color(0xffE0CDF4),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                "assets/images/rating_back.svg",
                                width: 20,
                                height: 20,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width * .25),
                          child: const Text(
                            "Write a review",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(
                                0xff183B3B,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(120),
                    child: Image.network(
                      userProfile ??
                          "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                      width: 150,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      "how was your experience with ${userName ?? ""}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: "Acumin Pro", fontSize: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    unratedColor: const Color(0xffF5F5F5),
                    glowColor: Colors.white,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) =>
                        Image.asset("assets/images/rating_star.png"),
                    onRatingUpdate: (rating) {
                      setState(() {
                        ratingCount = rating;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: const [
                        Text(
                          "Share your experience and help others!",
                          style: TextStyle(
                            color: Color(0xff183B3B),
                            fontFamily: "Acumin-Pro",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    height: 150,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffE9E9E9)),
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: reviewController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 1,
                      decoration: const InputDecoration(
                        hintText: "Write something...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: Color(0xff183B3B),
                            fontFamily: "AcuminPro"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 30,
          right: 30,
          child: GestureDetector(
            onTap: () {
              List<dynamic> reviewList1 = [];
              if (reviewController.text != "") {
                if (userMap != []) {
                  isLoading = true;
                  reviewList1 = userMap;
                  reviewList1.add({
                    "starCount": ratingCount,
                    "reviewText": reviewController.text,
                    "reviewerId": userId,
                    "bookImage": widget.Image
                  });
                  sveReviewData(widget.userId!, reviewList1).then((value) {
                    reviewList1.clear();
                    getUserData();
                    Navigator.pop(context);
                    isLoading = false;
                  });
                }
              } else {
                Fluttertoast.showToast(msg: "Please write something...");
              }
            },
            child: Container(
              width: width,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: const Color(0xffC2EFDF),
              ),
              child: !isLoading
                  ? const Text("Send Review")
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        )
      ]),
    );
  }

  Future<void> sveReviewData(String userID, List<dynamic> reviewList) async {
    await FirebaseFirestore.instance.collection("users").doc(userID).update({
      "reviews": reviewList,
    });
  }
}
