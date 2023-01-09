import 'dart:io';
import 'package:booklub/Model/comment_messages_model.dart';
import 'package:booklub/pages/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class CommentScreen extends StatefulWidget {
  String? headerImage;
  String? headerName;
  Widget? dateTime;
  String? bookImage;
  String? discription;
  String? documentId;
  bool? isImageCheck;
  Map<String, dynamic>? currentMessage;
  QuerySnapshot? dataSnapshot;
  String? id;

  CommentScreen({
    this.headerImage,
    this.headerName,
    this.dateTime,
    this.bookImage,
    this.discription,
    this.documentId,
    this.isImageCheck,
    this.currentMessage,
    this.dataSnapshot,
    this.id,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  CollectionReference messages = FirebaseFirestore.instance.collection('posts');

  List<CommentMessagesModel> commentsList = [];
  File? imageFile;
  String imageUrl = "";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isImageCheck = false;

  sendCommentMessage() {
    posts.doc(widget.documentId).collection("commentMessages").add({
      "message": [
        currentUser[0].uid,
        commentController.text,
        // _firebaseAuth.currentUser!.photoURL,
        currentUser[0].profilePic,
        currentUser[0].name,
      ]
    });
  }

  getMessageData() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.documentId)
        .collection("commentMessages")
        .get();

    List<QueryDocumentSnapshot> docs = data.docs;
    for (var e in docs) {
      commentsList.add(
        CommentMessagesModel.fromJson(e.data() as Map<String, dynamic>)
          ..id = e.id,
      );
    }
    setState(() {});
  }

  Widget? time;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 65),
        child: StreamBuilder<QuerySnapshot>(
          stream: messages
              .doc(widget.documentId)
              .collection("commentMessages")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
              QuerySnapshot chatRoomSnapShot = snapshot.data as QuerySnapshot;

              isImageCheck = likeImagecheck(widget.currentMessage);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          "assets/images/message_back.svg",
                          width: 22,
                          height: 22,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(
                        width: 22,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          widget.headerImage ??
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTL_JlCFnIGX5omgjEjgV9F3sBRq14eTERK9w&usqp=CAU",
                          width: 50,
                          height: 50,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.headerName ?? "",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          widget.dateTime!,
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.discription ?? "",
                    // "So excited for this book!! :)",
                    style: TextStyle(
                      fontFamily: "Acumin-Pro",
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 165,
                    width: double.infinity,
                    child: Image.network(widget.bookImage ?? ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 10),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            if (widget.currentMessage!["likes"] != null) {
                              List<dynamic> likeList =
                                  widget.currentMessage!["likes"];
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
                                addLikeData(widget.documentId!, likeList);
                                isImageCheck = false;
                                setState(() {});
                              } else {
                                likeList.add(currentUser[0].uid);
                                addLikeData(widget.documentId!, likeList);
                                isImageCheck = true;
                                setState(() {});
                              }
                            } else {
                              List<dynamic> likeList = [];
                              likeList.add(currentUser[0].uid);
                              addLikeData(widget.documentId!, likeList);
                              isImageCheck = true;
                              setState(() {});
                            }
                          },
                          child: isImageCheck
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
                        SvgPicture.asset(
                          "assets/images/post_comment.svg",
                          width: 23,
                          height: 23,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 10),
                      itemCount: chatRoomSnapShot.docs.length,
                      itemBuilder: (context, index) {
                        String message =
                            chatRoomSnapShot.docs[index]["message"][1];
                        String image =
                            chatRoomSnapShot.docs[index]["message"][2];
                        String name =
                            chatRoomSnapShot.docs[index]["message"][3];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(120),
                                child: Image.network(
                                  image,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(message),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(
                        bottom: 8, top: 10, left: 18, right: 18),
                    padding: const EdgeInsets.only(left: 35, right: 15),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(
                            0.0,
                            9.0,
                          ),
                          blurRadius: 3.0,
                          spreadRadius: 0.5,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: commentController,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 8),
                                border: InputBorder.none,
                                hintText: "Type a message"),
                          ),
                        ),
                        // commentController.text.isEmpty
                        //     ? GestureDetector(
                        //         onTap: () async {
                        //           PickedFile? pickedFile =
                        //               await ImagePicker().getImage(
                        //             source: ImageSource.gallery,
                        //           );
                        //           if (pickedFile != null) {
                        //             setState(() {
                        //               imageFile = File(pickedFile.path);
                        //             });
                        //             if (imageUrl != "") {
                        //               sendCommentMessage();
                        //               // sendMessage();
                        //             }
                        //           }
                        //         },
                        //         child: const Icon(
                        //           Icons.camera_alt,
                        //           color: Color(0xff878F93),
                        //         ),
                        //       )
                        //     :
                        GestureDetector(
                          onTap: () {
                            if (imageUrl == "") {
                              sendCommentMessage();
                            }
                            commentController.text = "";
                            setState(() {});
                          },
                          child: SvgPicture.asset(
                            "assets/images/send.svg",
                            height: 25,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> getMessageDataStrime(String doc) async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("posts")
        .doc(doc)
        .collection("commentMessages")
        .get();
    print(data.docs);

    QueryDocumentSnapshot docs = data.docs.first;
    return docs.data();
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
}
