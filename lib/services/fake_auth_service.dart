import 'package:flutterlovers/model/user_model.dart';
import 'package:flutterlovers/services/auth_base.dart';

class FakeAuthService implements AuthBase{

  String userID = "54545151686";

  @override
  Future<User> currentUser() async {
    return await Future.value(User(userID: userID));
  }

  @override
  Future<User> signInAnonymously() async {
    return await Future.delayed(Duration(seconds: 2), ()=>User(userID: userID));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }
}