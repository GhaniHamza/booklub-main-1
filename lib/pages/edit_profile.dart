import 'dart:io';
import 'package:booklub/pages/bottom_navigation.dart';
import 'package:booklub/pages/profile_screen.dart';
import 'package:booklub/pages/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerAbout = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String radioButtonItem = 'Male';
  String imageUrl = "";
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) => {
              setState(() {
                _controllerName.text = value["name"] ?? "Name";
                _controllerUsername.text = value["username"] ?? "Username";
                _controllerAbout.text = value["about"] ??
                    "Constantly traveling and keeping up to date with business related books.";
                _controllerEmail.text =
                    _firebaseAuth.currentUser?.email.toString() ??
                        "no email found";
                _controllerPhone.text = value["phone"] ?? "";
                radioButtonItem = value["gender"] ?? "";

                if (radioButtonItem == "Male") {
                  id = 1;
                } else {
                  id = 2;
                }
                imageUrl = value["profilePic"] ?? "";
              })
            });
  }

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75);
    Reference ref = FirebaseStorage.instance.ref().child(
        "${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.jpg");
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      setState(() {
        imageUrl = value;
      });
    });
  }

  saveInfo() {
    Map<String, String?> dataToSave = {
      'uid': userId,
      'imageUrl': imageUrl,
      "profilePic": imageUrl,
    };

    FirebaseFirestore.instance.collection('users').doc(userId).update({
      "profilePic": imageUrl,
      'phone': _controllerPhone.text,
      'username': _controllerUsername.text,
      'name': _controllerName.text,
      'email': _controllerEmail.text,
      'about': _controllerAbout.text,
      'gender': radioButtonItem,
    }).then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigation()),
      ).then((value) => setState(() {}));
    });

    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId)
    //     .set(dataToSave, SetOptions(merge: true))
    //     .then((value) => Navigator.push(
    //           context,
    //           MaterialPageRoute(builder: (context) => BottomNavigation()),
    //         ).then((value) => setState(() {})))
    //     .onError((error, stackTrace) => {errorMessage = error.toString()});
  }

  int id = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Edit Profile"),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        actions: [
          TextButton(onPressed: () => {saveInfo()}, child: Text('Done')),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: imageUrl == ""
                          ? const NetworkImage(
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                          : NetworkImage(imageUrl),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: () {
                      pickUploadImage();
                    },
                    child: const Text('Change Profile Photo',
                        style: TextStyle(
                          color: Color.fromARGB(255, 68, 117, 116),
                          fontWeight: FontWeight.bold,
                        ))),
                const Divider(height: 1),
                Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            const SizedBox(
                                width: 80,
                                child: Text(
                                  'Name',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(width: 20),
                            Expanded(
                                child: TextField(
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 236, 233, 233)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 236, 233, 233)),
                                ),
                              ),
                              controller: _controllerName,
                            )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const SizedBox(
                                width: 80,
                                child: Text(
                                  'Phone',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(width: 20),
                            Expanded(
                                child: TextField(
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 236, 233, 233)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 236, 233, 233)),
                                ),
                              ),
                              controller: _controllerPhone,
                            )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const SizedBox(
                                width: 80,
                                child: Text(
                                  'Username',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(width: 20),
                            Expanded(
                                child: TextField(
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 236, 233, 233)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 236, 233, 233)),
                                ),
                              ),
                              controller: _controllerUsername,
                            )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const SizedBox(
                                width: 80,
                                child: Text(
                                  'Email',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            const SizedBox(width: 20),
                            Expanded(
                                child: TextField(
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 236, 233, 233)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 236, 233, 233)),
                                ),
                              ),
                              controller: _controllerEmail,
                            )),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Radio(
                              value: 1,
                              groupValue: id,
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      const Color.fromARGB(255, 171, 11, 200)),
                              onChanged: (val) {
                                setState(() {
                                  radioButtonItem = 'Male';
                                  id = 1;
                                });
                              },
                            ),
                            const Text(
                              'Male',
                              style: TextStyle(fontSize: 14),
                            ),
                            Radio(
                              value: 2,
                              groupValue: id,
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      const Color.fromARGB(255, 171, 11, 200)),
                              onChanged: (val) {
                                setState(() {
                                  radioButtonItem = 'Female';
                                  id = 2;
                                });
                              },
                            ),
                            const Text(
                              'Female',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                          width: 80,
                          child: Text(
                            'About',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(width: 20),
                      Expanded(
                          child: TextField(
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(0, 227, 227, 227)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(0, 0, 187, 212)),
                          ),
                        ),
                        controller: _controllerAbout,
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Text(
                    errorMessage == '' ? '' : 'Oops! $errorMessage',
                    style: const TextStyle(color: Colors.red),
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
