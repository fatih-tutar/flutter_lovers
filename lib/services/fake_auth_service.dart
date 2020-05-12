import 'package:flutterlovers/model/user.dart';
import 'package:flutterlovers/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userID = "54561165103";
  @override
  Future<User> currentUser() async {
    return await Future.value(User(userID: userID, email: "fakeuser@fake.com"));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<User> signInAnonymously() async {
    return await Future.delayed(Duration(seconds: 2),
        () => User(userID: userID, email: "fakeuser@fake.com"));
  }

  @override
  Future<User> signInWithGoogle() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () =>
            User(userID: "google_user_id_123456", email: "fakeuser@fake.com"));
  }

  @override
  Future<User> signInWithFacebook() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => User(
            userID: "facebook_user_id_123456", email: "fakeuser@fake.com"));
  }

  @override
  Future<User> createUserWithEmailandPassword(
      String email, String sifre) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () =>
            User(userID: "created_user_id_123456", email: "fakeuser@fake.com"));
  }

  @override
  Future<User> signInWithEmailandPassword(String email, String sifre) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () =>
            User(userID: "signed_user_id_123456", email: "fakeuser@fake.com"));
  }
}
