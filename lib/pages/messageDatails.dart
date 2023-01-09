import 'dart:io';
import 'package:booklub/Model/chats_model.dart';
import 'package:booklub/Model/user_model.dart';
import 'package:booklub/data.dart';
import 'package:booklub/pages/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MessageDetails extends StatefulWidget {
  String? userId;
  String? senderId;
  String? otherUserId;
  String? userName;

  MessageDetails({this.userId, this.senderId, this.otherUserId, this.userName});

  @override
  State<MessageDetails> createState() => _MessageDetailsState();
}

class _MessageDetailsState extends State<MessageDetails> {
  TextEditingController messageController = TextEditingController();
  CollectionReference chatData = FirebaseFirestore.instance.collection('chats');

  // final Stream<QuerySnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('chats').snapshots();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? tempOtherUserId;

  List<Map<String, dynamic>> m1 = [];
  final ScrollController _scrollController = ScrollController();
  File? imageFile;
  String imageUrl = "";

  Future<void> uploadImage() async {
    if (imageFile != null) {
      final storageRef = FirebaseStorage.instance.ref(
          "chatImage/${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.jpg");
      UploadTask uploadTask = storageRef.putFile(imageFile!);
      var dowurl = await (await uploadTask).ref.getDownloadURL();
      imageUrl = dowurl.toString();
    }
  }

  List<UserModel> userList = [];
  String? headerName;
  String? otherUserImage;
  String? myImage;

  Future<dynamic> getUserData() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: widget.otherUserId)
        .get();

    List<QueryDocumentSnapshot> docs = data.docs;
    for (var e in docs) {
      userList.add(
        UserModel.fromJson(e.data() as Map<String, dynamic>)..id = e.id,
      );
    }
    setState(() {});
  }

  void sendMessage() {
    chatData
        // .doc("${currentUser[0].uid}_${widget.userId!}")
        .doc(widget.userId)
        .collection("messages")
        .add({
      "messageId": const Uuid().v1(),
      'sender': currentUser[0].uid,
      'receiver': tempOtherUserId,
      'message': messageController.text,
      'messageType': "sender",
      'created': FieldValue.serverTimestamp(),
      "image": imageUrl,
      // "createdOn":
      //     "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}::${DateTime.now().millisecond}::${DateTime.now().millisecond}}"
    });

    // chatData.doc("${currentUser[0].uid}_${widget.userId!}").set({
    chatData.doc(widget.userId).set({
      "lastMessage": messageController.text,
      "lastMessageTime": DateTime.now(),
      // "id": "${currentUser[0].uid}_${widget.userId!}",
      "id": "${widget.userId}",
      "senderId": currentUser[0].uid,
      // "receiverId": widget.userId,
      "receiverId": tempOtherUserId,
      "user": [
        currentUser[0].uid,
        // widget.userId!,
        tempOtherUserId!,
      ]
    });
  }

  @override
  void initState() {
    tempOtherUserId = widget.otherUserId;
    getUserData().then((value) {
      headerName = userList[0].name ?? "";
      otherUserImage = userList[0].profilePic ?? "";
      // myImage = _firebaseAuth.currentUser!.photoURL;
      myImage = currentUser[0].profilePic;
    });

    m1.add({
      "msg":
          "Hi! I am interested in this book. Can you send me more pictures of the book?",
      "send": 1
    });
    super.initState();
    // storeData();
    // splitUserId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFFF2D4),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: SvgPicture.asset(
              "assets/images/back-arrow.svg",
              height: 35,
              // width: 34.41,
            ),
          ),
        ),
        leadingWidth: 34.41,
        centerTitle: true,
        elevation: 0,
        title: Text(
          headerName ?? "",
          style: const TextStyle(
              fontSize: 15,
              color: Color(0xff49B2B0),
              decoration: TextDecoration.underline),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(widget.userId)
                  .collection("messages")
                  .orderBy("created", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      reverse: true,
                      itemCount: dataSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChatModel currentMessage = ChatModel.fromJson(
                          dataSnapshot.docs[index].data()
                              as Map<String, dynamic>,
                        );
                        print(currentMessage.id);
                        var senderId = widget.userId!.split("_")[1];
                        return currentUser[0].uid == currentMessage.sender
                            ? Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    currentMessage.message!.length > 40
                                        ? Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xffF5F5F5),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                currentMessage.message ?? "",
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xff52596B),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xffF5F5F5),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              currentMessage.message ?? "",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xff52596B),
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(120),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(120),
                                        child: Image.network(
                                          myImage ??
                                              "https://www.grouphealth.ca/wp-content/uploads/2018/05/placeholder-image.png",
                                          fit: BoxFit.fill,
                                          width: 35,
                                          height: 35,
                                        ),
                                      ),
                                    ),
                                    //     : ClipRRect(
                                    //   borderRadius: BorderRadius.circular(6),
                                    //   child: Image.file(
                                    //     File(
                                    //       m1[m1.length - 1 - index]["image"].toString(),
                                    //     ),
                                    //     height: 164,
                                    //     width: 117,
                                    //     fit: BoxFit.cover,
                                    //   ),
                                    // ),

                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    currentMessage.message!.length > 40
                                        ? Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(120),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(120),
                                                child: Image.network(
                                                  otherUserImage ??
                                                      "https://www.grouphealth.ca/wp-content/uploads/2018/05/placeholder-image.png",
                                                  fit: BoxFit.fill,
                                                  width: 35,
                                                  height: 35,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(120),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(120),
                                              child: Image.network(
                                                otherUserImage ??
                                                    "https://www.grouphealth.ca/wp-content/uploads/2018/05/placeholder-image.png",
                                                fit: BoxFit.fill,
                                                width: 35,
                                                height: 35,
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF5F5F5),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        currentMessage.message ?? "",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xff52596B),
                                        ),
                                      ),
                                    )
                                    //     : ClipRRect(
                                    //   borderRadius: BorderRadius.circular(6),
                                    //   child: Image.file(
                                    //     File(
                                    //       m1[m1.length - 1 - index]["image"].toString(),
                                    //     ),
                                    //     height: 164,
                                    //     width: 117,
                                    //     fit: BoxFit.cover,
                                    //   ),
                                    // ),
                                    ,
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text("Please Check Your Internet Connection"));
                  } else {
                    return const Center(
                      child: Text("Say Hii !"),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          // Container(
          //   color: Colors.green[200],
          //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          //   child: Row(
          //     children: [
          //       Flexible(
          //           child: TextField(
          //         controller: messageController,
          //         decoration: const InputDecoration(
          //             hintText: "Enter Messagr", border: InputBorder.none),
          //       )),
          //       IconButton(
          //           onPressed: () {
          //             storeChatData();
          //           },
          //           icon: Icon(Icons.send))
          //     ],
          //   ),
          // )
          Container(
            height: 40,
            margin:
                const EdgeInsets.only(bottom: 8, top: 10, left: 18, right: 18),
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
                    controller: messageController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 8),
                        border: InputBorder.none,
                        hintText: "Type a message"),
                  ),
                ),
                messageController.text.isEmpty
                    ? GestureDetector(
                        onTap: () async {
                          PickedFile? pickedFile = await ImagePicker().getImage(
                            source: ImageSource.gallery,
                            // maxWidth: 1800,
                            // maxHeight: 1800,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              imageFile = File(pickedFile.path);
                              m1.add({"image": imageFile?.path, "send": 0});
                            });
                            uploadImage();
                            if (imageUrl != "") {
                              sendMessage();
                            }
                          }
                        },
                        child: const Icon(
                          Icons.camera_alt,
                          color: Color(0xff878F93),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          m1.add({"msg": messageController.text, "send": 0});
                          if (imageUrl == "") {
                            sendMessage();
                          }
                          messageController.text = "";
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
      ),
    );
  }
}
