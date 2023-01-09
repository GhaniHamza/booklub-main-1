class FirebaseUser {
  String? uid;
  final String? name;
  final String? username;

  //code firebaseauth excemption
  FirebaseUser({this.uid, this.name, this.username});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'username': username,
      };
}
