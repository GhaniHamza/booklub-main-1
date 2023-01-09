import 'package:booklub/firebase_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  FirebaseUser? _firebaseUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : null;
  }

  Stream<FirebaseUser?> get user {
    return _firebaseAuth.authStateChanges().map(_firebaseUser);
  }

  Future<void> sendRecoveryEmail({
    required String email,
  }) async {
    return await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email.trim());
  }

  Future signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(uid: null);
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String username,
    required String phone,
  }) async {
    var credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return credential;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
}
