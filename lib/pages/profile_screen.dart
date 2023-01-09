import 'package:booklub/Model/BooksModel.dart';
import 'package:booklub/Model/user_model.dart';
import 'package:booklub/auth.dart';
import 'package:booklub/pages/book_detail.dart';
import 'package:booklub/pages/edit_profile.dart';
import 'package:booklub/pages/sign_in.dart';
import 'package:booklub/resource/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:booklub/data.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});
  final User? user = Auth().currentUser;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<BookModel> books = <BookModel>[];
  List<SingleBookModel> singleeBooks = <SingleBookModel>[];
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late String username = "Username";
  late String about =
      "Constantly traveling and keeping up to date with business related books.";
  late String imageUrl = "";
  int reviewCount = 0;
  List<BooksModel> myBookList = [];

  @override
  void initState() {
    super.initState();
    getUserData();
    getMyBookData();
    books = getBooks();
    singleeBooks = getSingleBooks();
  }

  getMyBookData() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("books")
        .where("userid", isEqualTo: userId)
        .get();
    List<QueryDocumentSnapshot> docs = data.docs;
    docs.forEach((e) {
      myBookList.add(
          BooksModel.fromJson(e.data() as Map<String, dynamic>)..id = e.id);
    });
    setState(() {});
  }

  Future<void> getUserData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) => {
              setState(() {
                username = value["username"] ?? "Username";
                about = value["about"] ??
                    "Constantly traveling and keeping up to date with business related books.";
                imageUrl = value["profilePic"] ?? "";
                // value["reviews"] ?? ["data"];
              })
            })
        .onError((error, stackTrace) => {print(error.toString())});
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignIn()),
            (route) => false));
  }

  Widget _title() {
    return const Text('Your Profile');
  }

  Widget _signOutButton() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
        child: ElevatedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(
                  const Size(double.minPositive, 24)),
              backgroundColor:
                  MaterialStateProperty.all(Color.fromARGB(255, 245, 245, 245)),
            ),
            onPressed: () => {signOut()},
            child: const Text(
              'Logout',
              style: TextStyle(fontSize: 13, color: Colors.black),
            )));
  }

  Widget _sectionReciewTitle(String title, data) {
    return data["reviews"] != null
        ? Text(
            "$title (${data["reviews"].length})",
            style: const TextStyle(
              color: Color.fromARGB(255, 139, 139, 139),
              fontWeight: FontWeight.bold,
              fontSize: 21,
            ),
          )
        : Text(
            "$title (0)",
            style: const TextStyle(
              color: Color.fromARGB(255, 139, 139, 139),
              fontWeight: FontWeight.bold,
              fontSize: 21,
            ),
          );
  }

  myListingCount(title, count) {
    return Text(
      "$title ($count)",
      style: const TextStyle(
        color: Color.fromARGB(255, 139, 139, 139),
        fontWeight: FontWeight.bold,
        fontSize: 21,
      ),
    );
  }

  // Widget _sectionListingsCount(String title, data) {
  //   return data["reviews"] != null
  //       ? Text(
  //           "$title (${data["reviews"].length})",
  //           style: const TextStyle(
  //             color: Color.fromARGB(255, 139, 139, 139),
  //             fontWeight: FontWeight.bold,
  //             fontSize: 21,
  //           ),
  //         )
  //       : Text(
  //           "$title (0)",
  //           style: const TextStyle(
  //             color: Color.fromARGB(255, 139, 139, 139),
  //             fontWeight: FontWeight.bold,
  //             fontSize: 21,
  //           ),
  //         );
  // }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _title(),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          centerTitle: true,
          actions: [
            _signOutButton(),
          ],
        ),
        body: FutureBuilder(
          future: users.doc(userId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            if (snapshot.hasData && !snapshot.data!.exists) {
              return const Text("Document does not exist");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 4,
                            fit: FlexFit.tight,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(data["name"] ?? "",
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 38, 48, 81),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28)),
                                  const SizedBox(height: 8),
                                  data["about"] != null
                                      ? Text(data["about"],
                                          style: const TextStyle(
                                              fontSize: 12,
                                              height: 1.2,
                                              color: Color.fromARGB(
                                                  255, 193, 193, 193)))
                                      : const Text("")
                                ]),
                          ),
                          const SizedBox(width: 30),
                          Flexible(
                            flex: 2,
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: data["profilePic"] == ""
                                      ? const NetworkImage(
                                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                                      : NetworkImage(data["profilePic"]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text("${myBookList.length}",
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 139, 139, 139),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28)),
                                    const SizedBox(height: 10),
                                    const Text('Listings',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 206, 206, 206),
                                            fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(width: 25),
                                Column(
                                  children: [
                                    Text(
                                        data["reviews"] != null
                                            ? data["reviews"].length.toString()
                                            : "0",
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 139, 139, 139),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28)),
                                    const SizedBox(height: 10),
                                    const Text('Reviews',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 206, 206, 206),
                                            fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            const Size(double.minPositive, 44)),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromARGB(
                                            255, 222, 206, 241)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0)))),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return const EditProfile();
                                  })).then(
                                      (value) => {if (value) getUserData()});
                                },
                                child: const Text(
                                  'Edit profile',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ))
                          ],
                        )),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      alignment: Alignment.centerLeft,
                      child: myListingCount('Your listing', myBookList.length),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        height: 220,
                        child: ListView.builder(
                            itemCount: myBookList.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var item = myBookList[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return BookDetailScreen(
                                        author: item.author,
                                        image: item.image,
                                        method: item.method,
                                        name: item.bookname,
                                        price: item.price,
                                        userId: item.userid,
                                        discription: item.discription,
                                        bookCategoryName: item.bookCategoryName,
                                      );
                                    },
                                  ));
                                },
                                child: SingleBookTile(
                                  imgAssetPath: item.image ?? "",
                                ),
                              );
                            }),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      alignment: Alignment.centerLeft,
                      child: _sectionReciewTitle('Your reviews', data),
                    ),
                    data["reviews"] != null
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data["reviews"].length,
                            itemBuilder: (context, index) {
                              return BooksTile(
                                imgAssetPath: data["reviews"][index]
                                    ["bookImage"],
                                rating: data["reviews"][index]["starCount"],
                                title: data["reviews"][index]["reviewText"],
                                description: data["reviews"][index]
                                    ["reviewText"],
                              );
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("No Reviews!!"),
                              ],
                            ),
                          )
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

class BooksTile extends StatelessWidget {
  final String imgAssetPath, title, description;
  final double rating;
  BooksTile(
      {required this.rating,
      required this.description,
      required this.title,
      required this.imgAssetPath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 140,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                    boxShadow: [
                      const BoxShadow(
                        color: Color.fromARGB(255, 242, 242, 242),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ).scale(5)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 10, top: 6),
                      width: MediaQuery.of(context).size.width - 210,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              description,
                              maxLines: 4,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          StarRating(
                            rating: rating,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 130,
                        margin: const EdgeInsets.only(
                          left: 30,
                          top: 6,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imgAssetPath,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class SingleBookTile extends StatelessWidget {
  final imgAssetPath;
  SingleBookTile({required this.imgAssetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 214, 212, 212).withOpacity(0.3),
              spreadRadius: 8,
              blurRadius: 12,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: Container(
          child: Image.network(
            imgAssetPath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
