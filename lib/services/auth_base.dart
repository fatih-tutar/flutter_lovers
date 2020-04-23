import 'package:flutterlovers/model/user_model.dart';

abstract class AuthBase{
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<bool> signOut();
}