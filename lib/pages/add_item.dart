import 'dart:io';
import 'package:booklub/Constance/app_color.dart';
import 'package:booklub/Model/genres_model.dart';
import 'package:booklub/pages/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  TextEditingController bookNameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  FirebaseAuth userId = FirebaseAuth.instance;
  bool isLoading = false;
  File? _imageFileList;
  String booksVal = "";
  String bookID = "";
  String bookCategoryName = "";
  final mountainsRef = FirebaseStorage.instance.ref(
      "books/${DateTime.now().minute + DateTime.now().second + DateTime.now().millisecond}.jpg");
  String uploadPath = "";
  String imageUrl = "";

  List<String> chooseDetailMethod = [
    "MEET-UP",
    "MAILING",
  ];

  String chooseDetailMethodValue = "";

  List<GenresModel> booksList = [];

  Future<void> getData() async {
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("Generes").get();
    List<QueryDocumentSnapshot> docs = data.docs;
    for (var e in docs) {
      booksList.add(
        GenresModel.fromJson(e.data() as Map<String, dynamic>)..id = e.id,
      );
    }
    setState(() {});
  }

  uploadImage() async {
    isLoading = true;
    if (_imageFileList != null) {
      await mountainsRef.putFile(_imageFileList!);
      imageUrl = await mountainsRef.getDownloadURL();
    }

    print(imageUrl);
  }

  addDataToGenres(String? bookId, String? bookName, String? discription,
      String? method, String? image) async {
    CollectionReference users = FirebaseFirestore.instance.collection('books');
    users.add({
      "categoryid": bookId,
      "bookCategoryName":
          bookCategoryName == "" ? "Psychology" : bookCategoryName,
      "bookname": bookName,
      "discription": discription,
      "method": method,
      "image": image,
      "views": 0,
      "price": priceController.text,
      "userid": userId.currentUser?.uid,
      "author": authorController.text,
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chooseDetailMethodValue = chooseDetailMethod.first;
    getData().then((value) {
      booksVal = booksList.first.name!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: !isLoading
            ? SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: width,
                    color: AppColor.editScreenGreyColor,
                    child: Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (bookNameController.text == "") {
                                      Fluttertoast.showToast(
                                          msg: "Please Enter book Detail");
                                    } else if (detailsController.text == "") {
                                      Fluttertoast.showToast(
                                          msg: "Please Enter Detail");
                                    } else if (authorController.text == "") {
                                      Fluttertoast.showToast(
                                          msg: "Please Enter Author Name");
                                    } else if (priceController.text == "") {
                                      Fluttertoast.showToast(
                                          msg: "Please Enter Price In RM");
                                    } else if (_imageFileList == null) {
                                      Fluttertoast.showToast(
                                          msg: "Please Select Image");
                                    } else {
                                      uploadImage().then((value) {
                                        addDataToGenres(
                                          booksVal == "Psychology"
                                              ? "2Mx22zcwthTmPSbQpcQd"
                                              : bookID,
                                          bookNameController.text,
                                          detailsController.text,
                                          chooseDetailMethodValue,
                                          imageUrl,
                                        );
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return const BottomNavigation();
                                          },
                                        ));
                                        bookID = "";
                                        bookNameController.text = "";
                                        detailsController.text = "";
                                        imageUrl = "";
                                        // chooseDetailMethodValue = "";
                                        Fluttertoast.showToast(
                                            msg: "Book Uploaded!!");
                                        setState(() {
                                          isLoading = false;
                                        });
                                      });
                                    }
                                  });
                                },
                                child: const Text(
                                  "Post",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                          ],
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, top: 20),
                    child: Text(
                      "Book Genre:",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Acumin-Pro",
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  booksVal != ""
                      ? Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          color: AppColor.editScreenGreyColor,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: DropdownButton<String>(
                              value: booksVal,
                              isExpanded: true,
                              icon: SvgPicture.asset(
                                  "assets/images/dropdown_arrow.svg"),
                              elevation: 16,
                              style: const TextStyle(color: Colors.white),
                              underline: const SizedBox(),
                              onChanged: (String? value) {
                                setState(() {
                                  booksVal = value!;
                                  for (var i = 0; i < booksList.length; i++) {
                                    var tempValue = booksList[i].name;
                                    if (booksVal == tempValue) {
                                      bookID = booksList[i].id!;
                                      bookCategoryName = booksList[i].name!;
                                    }
                                  }
                                });
                              },
                              items: booksList
                                  .map(
                                    (map) => DropdownMenuItem(
                                      value: map.name,
                                      child: Text(
                                        map.name ?? "",
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, top: 20),
                    child: Text(
                      "Book title:",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Acumin-Pro",
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: bookNameController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 20, top: 10, bottom: 10),
                        hintText: "write book title",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffE9E9E9),
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffE9E9E9),
                            )),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, top: 20),
                    child: Text(
                      "Details:",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Acumin-Pro",
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: detailsController,
                      maxLines: 18,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 20, top: 20),
                        hintText: "write book title",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffE9E9E9),
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffE9E9E9),
                            )),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, top: 20),
                    child: Text(
                      "Author:",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Acumin-Pro",
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: authorController,
                      // maxLines: 18,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 20, top: 20),
                        hintText: "Author",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffE9E9E9),
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffE9E9E9),
                            )),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, top: 20),
                    child: Text(
                      "Price:",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Acumin-Pro",
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 20, top: 20),
                        hintText: "Price In RM",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffE9E9E9),
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffE9E9E9),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    color: AppColor.editScreenGreyColor,
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownButton<String>(
                        value: chooseDetailMethodValue,
                        isExpanded: true,
                        icon: SvgPicture.asset(
                            "assets/images/dropdown_arrow.svg"),
                        elevation: 16,
                        style: const TextStyle(color: Colors.white),
                        underline: const SizedBox(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            chooseDetailMethodValue = value!;
                          });
                        },
                        items: chooseDetailMethod
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 30, top: 20),
                    child: Text(
                      "Add blog image:",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Acumin-Pro",
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final PickedFile? photo = await ImagePicker()
                          .getImage(source: ImageSource.gallery);
                      _imageFileList = File(photo!.path);
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 30, top: 20),
                      width: width * .40,
                      height: height * .065,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _imageFileList == null
                            ? AppColor.editScreenGreyColor.withOpacity(0.4)
                            : AppColor.editScreenGreyColor,
                      ),
                      child: Text(
                        "Choose image",
                        style: TextStyle(
                          color: _imageFileList == null
                              ? AppColor.editScreenGreyColor
                              : Colors.black,
                          fontSize: 15,
                          fontFamily: "Acumin-Pro",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 15),
                    child: Text(_imageFileList?.path ?? ""),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ))
            : const Center(child: CircularProgressIndicator()));
  }
}
