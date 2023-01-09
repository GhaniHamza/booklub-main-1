import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final TextEditingController _controllerEmail = TextEditingController();
  bool isSent = false;
  String? errorMessage = '';

  Future<void> recoverPassword() async {
    try {
      setState(() {
        errorMessage = '';
      });
      await Auth()
          .sendRecoveryEmail(email: _controllerEmail.text)
          .then((value) => (setState(() {
                isSent = !isSent;
              })));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
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
          const SizedBox(
            height: 25,
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(children: <Widget>[
              const SizedBox(
                height: 90,
              ),
              !isSent
                  ? Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'BookLub',
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.bold,
                            fontSize: 52),
                      ))
                  : const SizedBox(height: 0),
              !isSent
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 90,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: const Text(
                                'Recover Password',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 26, 26, 26),
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Enter your registered email below to receive password reset code',
                              style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 14,
                                  height: 1.5),
                            ),
                            _entryField('', _controllerEmail),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Text(
                                errorMessage == '' ? '' : 'Oops! $errorMessage',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            Container(
                                height: 50,
                                width: double.maxFinite,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          const Color.fromARGB(
                                              255, 68, 117, 116),
                                        ),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8.0)))),
                                    onPressed: () => recoverPassword(),
                                    child: const Text(
                                      'Login to Account',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ))),
                            const SizedBox(
                              height: 30,
                            ),
                            TextButton(
                                onPressed: (() => Navigator.of(context).pop()),
                                child: const Text('Back',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(
                                            255, 68, 117, 116)))),
                          ]),
                    )
                  : Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 90,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: const Text(
                                'Sent Successfully',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 26, 26, 26),
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Password sent successfully to your Email please check your email and use the password',
                              style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 14,
                                  height: 1.5),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                                height: 50,
                                width: double.maxFinite,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          const Color.fromARGB(
                                              255, 68, 117, 116),
                                        ),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8.0)))),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text(
                                      'Back to Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ))),
                          ]),
                    )
            ])));
  }
}
