import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create a object based on firebase object
  Users _userFromFirebaseUser(User users) {
    return users != null ? Users(uid: users.uid) : null;
  }

  //auth user change stream

  Stream<Users> get users {
    return _auth.authStateChanges().map((_userFromFirebaseUser));
  }

  // anonymous signin

  // ignore: non_constant_identifier_names
  Future SignInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email
  Future signInwithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  //register

  Future signUpwithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      //create new doc for user with uid
      await DatabaseService(uid: user.uid)
          .storeUserCredentials(email, password);
      await DatabaseService(uid: user.uid)
          .updateUserData('0', 'New Crew Member', 100);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
