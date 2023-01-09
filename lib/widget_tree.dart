import 'package:booklub/auth.dart';
import 'package:booklub/firebase_user.dart';
import 'package:booklub/pages/bottom_navigation.dart';
import 'package:booklub/pages/home_screen.dart';
import 'package:booklub/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/profile_screen.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});
  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.data?.uid != null) {
          userId = snapshot.data?.uid ?? "";
          return BottomNavigation();
        } else {
          return SignIn();
        }
      },
    );
  }
}
