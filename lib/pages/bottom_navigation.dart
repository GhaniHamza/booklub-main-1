import 'package:booklub/Model/user_model.dart';
import 'package:booklub/pages/add_item.dart';
import 'package:booklub/pages/profile_screen.dart';
import 'package:booklub/pages/home_screen.dart';
import 'package:booklub/pages/messageScreen.dart';
import 'package:booklub/pages/postScreen.dart';
import 'package:booklub/pages/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;
  static final List<Widget> widgetOptions = <Widget>[
    const HomeScreen(),
    const PostScreen(),
    const AddItemScreen(),
    MessageScreen(),
    ProfileScreen(),
  ];

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
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (userId != "") {
      getUserDataById(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: SizedBox(
        height: 75,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                  "assets/images/bottom_navigation_icon/selected_home.svg"),
              icon: SvgPicture.asset(
                  "assets/images/bottom_navigation_icon/unselected_home.svg"),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                  "assets/images/bottom_navigation_icon/selected_post.svg"),
              icon: SvgPicture.asset(
                  "assets/images/bottom_navigation_icon/unselected_post.svg"),
              label: 'Post',
            ),
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                    "assets/images/bottom_navigation_icon/selected_add.svg"),
                icon: SvgPicture.asset(
                    "assets/images/bottom_navigation_icon/Add 1.svg"),
                label: ""),
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                    "assets/images/bottom_navigation_icon/selected_message.svg"),
                icon: SvgPicture.asset(
                    "assets/images/bottom_navigation_icon/unselected_message.svg"),
                label: ""),
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                    "assets/images/bottom_navigation_icon/selected_profile.svg"),
                icon: SvgPicture.asset(
                    "assets/images/bottom_navigation_icon/unselected_profile.svg"),
                label: ""),
          ],
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
