import 'package:flutterlovers/model/user.dart';

abstract class DBBase {
  Future<bool> saveUser(User user);
  Future<User> readUser(String userID);
  Future<bool> updateUserName(String userID, String yeniUserName);
}
