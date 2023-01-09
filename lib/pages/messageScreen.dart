import 'package:booklub/Model/chat_room_model.dart';
import 'package:booklub/Model/user_model.dart';
import 'package:booklub/pages/messageDatails.dart';
import 'package:booklub/pages/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageScreen extends StatefulWidget {
  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<UserModel> userList = [];
  String? senderId;
  String? splitUserId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSenderId().then((value) {
      // getUserData();
    });
  }

  Future<void> getSenderId() async {
    final prefs = await SharedPreferences.getInstance();
    senderId = prefs.getString('senderId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
            height: 200,
            width: double.infinity,
            color: const Color(0xffFFF2D4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Messages",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                      fontFamily: "AcuminPro"),
                ),
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chats")
                .where('user', arrayContains: currentUser[0].uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatRoomSnapShot =
                      snapshot.data as QuerySnapshot;
                  print(chatRoomSnapShot.docs.length);
                  return ListView.builder(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 10),
                    itemCount: chatRoomSnapShot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromJson(
                        chatRoomSnapShot.docs[index].data()
                            as Map<String, dynamic>,
                      )..id;

                      var data = chatRoomModel.id;
                      var userID = data!.split("_");
                      splitUserId = userID[1];
                      var receiverId = userID[0];
                      var printDate =
                          buildDate(chatRoomModel.lastMessageTime!.toDate());
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MessageDetails(
                                userId: data,
                                senderId: splitUserId,
                                otherUserId: receiverId == currentUser[0].uid
                                    ? splitUserId!
                                    : receiverId,
                              ),
                            ),
                          );
                        },
                        child: FutureBuilder(
                            future: getUserDataById(
                              receiverId == currentUser[0].uid
                                  ? splitUserId!
                                  : receiverId,
                            ),
                            builder: (context, snps) {
                              if (snps.hasData) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        maxRadius: 28,
                                        // backgroundColor: Colors.amber,
                                        backgroundImage: NetworkImage(
                                            (snps.data as Map?)?["profilePic"]),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            (snps.data as Map?)?["name"] ?? "",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "AcuminPro",
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            chatRoomModel.lastMessage ?? "",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xffAFAEAF),
                                              fontFamily: "AcuminPro",
                                            ),
                                          ),
                                        ],
                                      )),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          printDate,
                                          // const Text(
                                          //   "2:23 PM",
                                          //   style: TextStyle(
                                          //     fontSize: 12,
                                          //     fontFamily: "AcuminPro",
                                          //     color: Color(0xffAFAEAF),
                                          //   ),
                                          // ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          // Container(
                                          //   padding: const EdgeInsets.all(3),
                                          //   decoration: const BoxDecoration(
                                          //       color: Color(0xffFFDE94),
                                          //       shape: BoxShape.circle),
                                          //   child: const Text(
                                          //     "01",
                                          //     style: TextStyle(
                                          //         fontSize: 10,
                                          //         color: Colors.white),
                                          //   ),
                                          // )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }
                              return const Center(child: Text(""));
                            }),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text("No Chats !!"));
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ))
        ],
      ),
    );
  }

  Future<dynamic> getUserDataById(String senderId) async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: senderId)
        .get();
    print(data.docs);

    QueryDocumentSnapshot docs = data.docs.first;
    return docs.data();
  }

  Widget buildDate(date) {
    final dateFormatter = DateFormat('h:mm a');
    final dateString = dateFormatter.format(date);
    return Text(
      dateString,
    );
  }
}
