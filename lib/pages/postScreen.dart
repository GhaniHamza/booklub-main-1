import 'package:booklub/Model/like_model.dart';
import 'package:booklub/pages/add_post.dart';
import 'package:booklub/pages/comment_screen.dart';
import 'package:booklub/pages/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List postAddedData = [];
  Widget? printDate;
  List<bool> isLike = [];
  List<String> postId = [];
  List<dynamic> likesList = [];
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isSetImage = false;
  bool? isImageCheck;

  @override
  void initState() {
    // getPostData();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
            height: 164,
            width: double.infinity,
            color: const Color(0xffE0CDF4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Post",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                      fontFamily: "AcuminPro"),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddPost(),
                    ));
                    // Future.delayed(
                    //   Duration.zero,
                    //   () async {
                    //     // postData.clear();
                    //     QuerySnapshot data = await FirebaseFirestore.instance
                    //         .collection("posts")
                    //         .orderBy("time", descending: true)
                    //         .get();
                    //     List<QueryDocumentSnapshot> docs = data.docs;
                    //     docs.forEach((e) {
                    //       postAddedData.add(e.data());
                    //     });
                    //     // postData = postAddedData;
                    //     setState(() {});
                    //   },
                    // );
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffD3C2E6),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Color(0xff5F6D86),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                  return ListView.builder(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    itemCount: dataSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> currentMessage =
                          dataSnapshot.docs[index].data()
                              as Map<String, dynamic>;
                      isImageCheck = likeImagecheck(currentMessage);
                      printDate = buildDate(currentMessage["time"].toDate());
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              currentMessage["profile"]
                                          .toString()
                                          .contains("assets") ==
                                      true
                                  ? CircleAvatar(
                                      backgroundImage: AssetImage(
                                          currentMessage["profile"].toString()),
                                      backgroundColor: Colors.amber,
                                    )
                                  : CircleAvatar(
                                      // maxRadius: 30,
                                      backgroundImage: NetworkImage(
                                          currentMessage["profile"].toString()),
                                      // backgroundImage:   AssetImage(
                                      //     postData[index]["profile"].toString()),
                                      backgroundColor: Colors.amber,
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    currentMessage["user"],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "AcuminPro",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  printDate!,
                                ],
                              )),
                              // const Icon(
                              //   Icons.more_vert_outlined,
                              //   color: Color(0xff52596B),
                              // )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            currentMessage["Description"].toString(),
                            style: const TextStyle(
                                fontSize: 15, fontFamily: "AcuminPro"),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          currentMessage["Image"] != null
                              ? SizedBox(
                                  height: 165,
                                  width: double.infinity,
                                  child: currentMessage["Image"]
                                              .toString()
                                              .contains("assets") ==
                                          true
                                      ? Image.asset(
                                          currentMessage["Image"].toString())
                                      : Image.network(
                                          currentMessage["Image"].toString()),
                                )
                              : Container(),
                          currentMessage["Image"] != null
                              ? const SizedBox(
                                  height: 10,
                                )
                              : Container(),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  if (currentMessage["likes"] != null) {
                                    List<dynamic> likeList =
                                        currentMessage["likes"];
                                    bool isLike = false;
                                    int index1 = 0;
                                    for (var i = 0; i < likeList.length; i++) {
                                      var tempValue = likeList[i];
                                      if (tempValue == currentUser[0].uid) {
                                        isLike = true;
                                        index1 = i;
                                      }
                                    }
                                    if (isLike) {
                                      likeList.removeAt(index1);
                                      addLikeData(dataSnapshot.docs[index].id,
                                          likeList);
                                      isImageCheck = false;
                                      setState(() {});
                                    } else {
                                      likeList.add(currentUser[0].uid);
                                      addLikeData(dataSnapshot.docs[index].id,
                                          likeList);
                                      isImageCheck = true;
                                      setState(() {});
                                    }
                                  } else {
                                    List<dynamic> likeList = [];
                                    likeList.add(currentUser[0].uid);
                                    addLikeData(
                                        dataSnapshot.docs[index].id, likeList);
                                    isImageCheck = true;
                                    setState(() {});
                                  }
                                },
                                child: isImageCheck!
                                    ? SvgPicture.asset(
                                        "assets/images/post_like.svg",
                                        width: 23,
                                        height: 23,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.asset(
                                        "assets/images/heart.png",
                                        width: 23,
                                        height: 23,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                              const SizedBox(
                                width: 14,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return CommentScreen(
                                        discription:
                                            currentMessage["Description"]
                                                .toString(),
                                        bookImage:
                                            currentMessage["Image"].toString(),
                                        dateTime: printDate!,
                                        headerImage: currentMessage["profile"]
                                            .toString(),
                                        headerName:
                                            currentMessage["user"].toString(),
                                        documentId: dataSnapshot.docs[index].id,
                                        isImageCheck: isImageCheck,
                                        currentMessage: currentMessage,
                                      );
                                    },
                                  ));
                                },
                                child: SvgPicture.asset(
                                  "assets/images/post_comment.svg",
                                  width: 23,
                                  height: 23,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                        ],
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> addLikeData(String postId, List<dynamic> likeList) async {
    await FirebaseFirestore.instance.collection("posts").doc(postId).update({
      "likes": likeList,
    });
  }

  bool likeImagecheck(currentMessage) {
    if (currentMessage["likes"] != null) {
      List<dynamic> likeList = currentMessage["likes"];
      bool isLike = false;
      for (var i = 0; i < likeList.length; i++) {
        var tempValue = likeList[i];
        if (tempValue == currentUser[0].uid) {
          isLike = true;
        }
      }
      if (isLike) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  Widget buildDate(date) {
    final dateFormatter = DateFormat('MMMM dd h:mm a');
    final dateString = dateFormatter.format(date);
    return Text(
      dateString,
      style: const TextStyle(
          fontSize: 13, color: Color(0xffAFAEAF), fontFamily: "AcuminPro"),
    );
  }
}
