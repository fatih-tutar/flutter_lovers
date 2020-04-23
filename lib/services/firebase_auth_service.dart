import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterlovers/model/user_model.dart';
import 'package:flutterlovers/services/auth_base.dart';

class FirebaseAuthService implements AuthBase{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> currentUser() async {
    try{
      FirebaseUser user = await _firebaseAuth.currentUser();
      return _userfromFirebase(user);
    }catch(e){
      print("HATA CURRENT USER" + e.toString());
      return null;
    }
  }

  User _userfromFirebase(FirebaseUser user){
    if(user == null)
      return null;
    return User(userID: user.uid);
  }

  @override
  Future<User> signInAnonymously() async {
    try{
      AuthResult sonuc = await _firebaseAuth.signInAnonymously();
      return _userfromFirebase(sonuc.user);
    }catch(e){
      print("anonim giriş hata :" + e.toString());
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try{
      await _firebaseAuth.signOut();
      return true;
    }catch(e){
      print("Sign out hata : " + e.toString());
      return false;
    }
  }

}