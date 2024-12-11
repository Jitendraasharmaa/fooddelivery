import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  Future signOut() async {
    await auth.signOut();
  }

  Future delete() async {
    User? user = FirebaseAuth.instance.currentUser;
    user?.delete();
  }
}
