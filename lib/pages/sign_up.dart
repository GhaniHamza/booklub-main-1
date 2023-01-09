import 'package:booklub/Model/user_model.dart';
import 'package:booklub/firebase_user.dart';
import 'package:booklub/pages/bottom_navigation.dart';
import 'package:booklub/pages/profile_screen.dart';
import 'package:booklub/pages/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? errorMessage = '';
  bool agree = false;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirm = TextEditingController();

  saveInfo(UserCredential credential) async {
    Map<String, String?> dataToSave = {
      'uid': credential.user?.uid,
      'name': _controllerName.text,
      'phone': _controllerPhone.text,
      'username': _controllerUsername.text,
      'email': _controllerEmail.text,
      'about': "",
      "profilePic":
          "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png",
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(credential.user?.uid)
        .set(dataToSave, SetOptions(merge: true))
        .then((value) {
      getUserDataById(credential.user?.uid).then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavigation()));
      });
    });
  }

  saveInfoGoogle(UserCredential credential) {
    Map<String, String?> dataToSave = {
      'uid': credential.user?.uid,
      'name': credential.user?.displayName,
      'profilePic': credential.user?.photoURL,
    };
    FirebaseFirestore.instance
        .collection('users')
        .doc(credential.user?.uid)
        .set(dataToSave, SetOptions(merge: true))
        .then((value) {
      getUserDataById(credential.user?.uid).then((value) {
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => const BottomNavigation()),
          ModalRoute.withName('/'),
        );
      });
    });
  }

  List<UserModel> userList = [];

  Future<void> getUserDataById(id) async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: id)
        .get();

    List<QueryDocumentSnapshot> docs = data.docs;
    for (var e in docs) {
      userList.add(
        UserModel.fromJson(e.data() as Map<String, dynamic>)..id = e.id,
      );
    }
    currentUser = userList;
    userId = userList[0].uid ?? "";
    setState(() {});
  }

  signInWithGoogle() async {
    if (agree) {
      try {
        var credential = await Auth().signInWithGoogle();
        saveInfoGoogle(credential);
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        errorMessage = "Please agree on this";
      });
    }
  }

  Future createUser(FirebaseUser newUser) async {
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(newUser.uid);
    newUser.uid = newUser.uid;
    final json = newUser.toJson();
    await docUser.set(json).then((value) => {
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => BottomNavigation()),
            ModalRoute.withName('/'),
          )
        });
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (agree) {
      try {
        var password = "";
        if (_controllerConfirm.text == _controllerPassword.text && agree) {
          password = _controllerPassword.text;
          var credential = await Auth().createUserWithEmailAndPassword(
            email: _controllerEmail.text,
            password: password,
            username: _controllerUsername.text,
            phone: _controllerPhone.text,
            name: _controllerName.text,
          );
          if (credential.user?.uid != null) {
            saveInfo(credential);
          }
        } else {
          setState(() {
            errorMessage = "The password confirmation does not match";
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        errorMessage = "Please agree on this";
      });
    }
  }

  static Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false, bool isNumber = false, int lines = 1}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 15, color: Color(0xFF333333)),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: lines,
            controller: controller,
            obscureText: isPassword,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 17.0, horizontal: 10.0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 241, 242, 243))),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 241, 242, 243))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 241, 242, 243))),
                fillColor: const Color.fromARGB(255, 241, 242, 243),
                filled: true),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text('Sign up',
                  style: TextStyle(
                      color: Color.fromARGB(255, 79, 79, 79),
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: _entryField('Name', _controllerName),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: _entryField('Username', _controllerUsername),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: _entryField('Email', _controllerEmail),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: _entryField('Phone', _controllerPhone),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: _entryField('Password', _controllerPassword,
                  isPassword: true),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: _entryField('Confirm Password', _controllerConfirm,
                  isPassword: true),
            ),
            Row(
              children: [
                Material(
                  child: Checkbox(
                    value: agree,
                    shape: const CircleBorder(),
                    onChanged: (value) {
                      setState(() {
                        agree = value ?? false;
                      });
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  width: MediaQuery.of(context).size.width - 120,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                            text:
                                'I agree to all the statements included in the ',
                            style: TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(255, 26, 26, 26))),
                        TextSpan(
                            text: 'terms of service',
                            style: const TextStyle(
                                fontSize: 11,
                                decoration: TextDecoration.underline,
                                color: Color.fromARGB(255, 68, 117, 116)),
                            recognizer: TapGestureRecognizer()..onTap = () {}),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                errorMessage == '' ? '' : 'Oops! $errorMessage',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 68, 117, 116)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)))),
                  onPressed: createUserWithEmailAndPassword,
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ),
            const SizedBox(height: 10),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(children: <Widget>[
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(right: 20.0),
                        child: const Divider(
                          color: Color.fromARGB(255, 79, 79, 79),
                          height: 36,
                        )),
                  ),
                  const Text(
                    "OR",
                    style: TextStyle(fontSize: 13),
                  ),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 20.0),
                        child: const Divider(
                          color: Color.fromARGB(255, 79, 79, 79),
                          height: 36,
                        )),
                  ),
                ])),
            const SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(double.maxFinite, 50)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                    onPressed: signInWithGoogle,
                    icon: Container(
                        height: 30,
                        width: 26,
                        child: Image.network(
                            'http://pngimg.com/uploads/google/google_PNG19635.png',
                            fit: BoxFit.fitHeight)),
                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ))),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
