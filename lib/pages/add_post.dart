import 'dart:io';
import 'package:booklub/Model/user_model.dart';
import 'package:booklub/pages/postScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController txt = TextEditingController();
  File? imageFile;
  var imageName;
  var imageLink;
  String? userId;
  bool? isloding = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(_firebaseAuth.currentUser?.uid)
    //     .get()
    //     .then((value) => {
    //           setState(() {
    //             // username = value["username"] ?? "Username";
    //             print(value);
    //           })
    //         });
    super.initState();
    getUserDataById();
  }

  String? username;
  String? uid;
  String? profilePic;

  List<UserModel> userList = [];

  getUserDataById() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: _firebaseAuth.currentUser?.uid)
        .get();

    List<QueryDocumentSnapshot> docs = data.docs;
    for (var e in docs) {
      userList.add(
        UserModel.fromJson(e.data() as Map<String, dynamic>)..id = e.id,
      );
    }
    setState(() {});
  }

  // Future<void> getUserData() async {
  //   return FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_firebaseAuth.currentUser?.uid)
  //       .get()
  //       .then((value) {
  //     username = value["username"];
  //     profilePic = value["profilePic"];
  //     uid = value["uid"];
  //     setState(() {});
  //   });
  // }

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  final Reference storageRef = FirebaseStorage.instance.ref(
      "posts/${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.jpg");

  Future<void> _postBook() async {
    setState(() {
      isloding = true;
    });
    try {
      // mountainImagesRef = storageRef.child(
      //     "posts/${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.jpg");
      await storageRef.putFile(imageFile!);
    } on FirebaseException catch (e) {
      print("Failed to store image ======================= $e");
    }

    imageLink = await storageRef.getDownloadURL();
    print(imageLink);
    setState(() {});
    posts
        .add({
          "Description": txt.text,
          "Image": imageLink,
          "userId": userList[0].uid,
          // "user": "Shima Alats",
          "user": userList[0].name,
          "time": DateTime.now(),
          "profile": userList[0].profilePic
        })
        // .add({
        //   "Description": "Falling in love with this book!!",
        //   "Image": "assets/images/book1.png",
        //   "userId": uid,
        //   "user": "Shima Alats",
        //   "time"
        //       "just now"
        //       "profile": "assets/images/profile.png"
        // })
        .then(
          (value) => print("Post Added"),
        )
        .catchError((error) => print("Failed to add post: $error"));
    setState(() {
      const snackBar = SnackBar(
        content: Text('Post added successfully'),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      isloding = false;

      Navigator.pop(context);
    });
  }

  Future<void> _uploadImg() async {
    setState(() {
      isloding = true;
    });
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);

      var t = imageFile?.path.split("/");
      imageName = t?.last;
      setState(() {});
    }
    setState(() {
      isloding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 45, bottom: 15),
            // height: 92,
            width: double.infinity,
            color: const Color(0xffE0CDF4),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffD3C2E6),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: Color(0xff5F6D86),
                    ),
                  ),
                ),
                const Spacer(),
                imageFile == null || imageFile?.path.isEmpty == true
                    ? Text(
                        "Post",
                        style: TextStyle(
                            fontSize: 15,
                            color: const Color(0xff183B3B).withOpacity(0.5),
                            fontFamily: "AcuminPro"),
                      )
                    : GestureDetector(
                        onTap: () {
                          _postBook();
                          // _postBook().then(
                          //   (value) => Navigator.of(context).pushReplacement(
                          //     MaterialPageRoute(
                          //       builder: (context) => const PostScreen(),
                          //     ),
                          //   ),
                          // );
                        },
                        child: isloding == false
                            ? const Text(
                                "Post",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff183B3B),
                                    fontFamily: "AcuminPro"),
                              )
                            : Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              ))
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        "What's on your mind?",
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff183B3B),
                            fontFamily: "AcuminPro"),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Container(
                    height: 207,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffE9E9E9)),
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: txt,
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
                  const SizedBox(
                    height: 14,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Attach an image",
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff183B3B),
                            fontFamily: "AcuminPro"),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  imageFile == null || imageFile?.path.isEmpty == true
                      ? _uploadImage()
                      : Container(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: const Color(0xffF5F6F7),
                              borderRadius: BorderRadius.circular(8)),
                          child: isloding == false
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "$imageName",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          overflow: TextOverflow.clip,
                                          color: Color(0xff183B3B),
                                          fontFamily: "AcuminPro",
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        imageFile = null;
                                        setState(() {});
                                      },
                                      child: const Icon(Icons.close),
                                    ),
                                  ],
                                )
                              : Center(child: CircularProgressIndicator()),
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _uploadImage() {
    return GestureDetector(
      onTap: () async {
        _uploadImg();
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            color: const Color(0xffF5F6F7),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/upload.svg",
              width: 18,
              height: 18,
              color: const Color(0xff373B47),
            ),
            const SizedBox(
              width: 6,
            ),
            const Text(
              "Upload image",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xff183B3B),
                fontFamily: "AcuminPro",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
