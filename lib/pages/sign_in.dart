import 'package:booklub/Model/user_model.dart';
import 'package:booklub/pages/bottom_navigation.dart';
import 'package:booklub/pages/profile_screen.dart';
import 'package:booklub/pages/recover_password.dart';
import 'package:booklub/pages/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth.dart';

List<UserModel> currentUser = [];
String userId = "";

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  signInWithGoogle() async {
    try {
      var credential = await Auth().signInWithGoogle();

      saveInfo(credential);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  saveInfo(UserCredential credential) {
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
              builder: (BuildContext context) => BottomNavigation()),
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

  signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _controllerEmail.text, password: _controllerPassword.text)
          .then((value) async {
        getUserDataById(FirebaseAuth.instance.currentUser?.uid);

        // if (credential.user?.uid != null) {
        //   saveInfo(credential);
        // }
        // saveInfoSignup(credential);
        userId = userList[0].uid ?? "";
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigation()),
        ).then((res) => initState());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          errorMessage = "No user found for that email";
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          errorMessage = "Wrong password provided for that user.";
        });
      } else {
        setState(() {
          errorMessage = e.message;
        });
      }
    }
  }

  static Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false, bool isNumber = false, int lines = 1}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
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

  Widget _errorMessage() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Text(
        errorMessage == '' ? '' : 'Oops! $errorMessage',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 68, 117, 116),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)))),
            onPressed: signInWithEmailAndPassword,
            child: const Text(
              'Login to Account',
              style: TextStyle(
                color: Colors.white,
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 40,
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'BookLub',
                      style: TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                          fontSize: 52),
                    )),
                const SizedBox(
                  height: 40,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(10),
                    child: const Text('Login',
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 32,
                            fontWeight: FontWeight.bold))),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: _entryField('Email', _controllerEmail),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: _entryField('Password', _controllerPassword,
                      isPassword: true),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const RecoverPassword();
                        }));
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Color.fromARGB(255, 68, 117, 116),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                _errorMessage(),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: _submitButton()),
                const SizedBox(
                  height: 10,
                ),
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
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton.icon(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(double.maxFinite, 50)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
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
                const SizedBox(
                  height: 65,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Don't have an account?",
                        style:
                            TextStyle(color: Color.fromARGB(255, 26, 26, 26)),
                      ),
                      TextButton(
                          onPressed: (() => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return const SignUp();
                                  },
                                ),
                              )),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          )),
                    ],
                  ),
                ),
              ],
            )));
  }
}
