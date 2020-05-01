import 'package:flutter/cupertino.dart';
import 'package:flutterlovers/locator.dart';
import 'package:flutterlovers/model/user.dart';
import 'package:flutterlovers/services/auth_base.dart';
import 'package:flutterlovers/services/fake_auth_service.dart';
import 'package:flutterlovers/services/firebase_auth_service.dart';
import 'package:flutterlovers/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDbService _firestoreDbService = locator<FirestoreDbService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<User> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      return await _firebaseAuthService.currentUser();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<User> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithGoogle();
    } else {
      User _user = await _firebaseAuthService.signInWithGoogle();
      bool _sonuc = await _firestoreDbService.saveUser(_user);
      if (_sonuc) {
        return await _firestoreDbService.readUser(_user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithFacebook();
    } else {
      User _user = await _firebaseAuthService.signInWithFacebook();
      bool _sonuc = await _firestoreDbService.saveUser(_user);
      if (_sonuc) {
        return await _firestoreDbService.readUser(_user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<User> createUserWithEmailandPassword(
      String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createUserWithEmailandPassword(
          email, sifre);
    } else {
      User _user = await _firebaseAuthService.createUserWithEmailandPassword(email, sifre);
      bool _sonuc = await _firestoreDbService.saveUser(_user);
      if (_sonuc) {
        return await _firestoreDbService.readUser(_user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<User> signInWithEmailandPassword(String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmailandPassword(email, sifre);
    } else {
      try{
        User _user = await _firebaseAuthService.signInWithEmailandPassword(email, sifre);
        return await _firestoreDbService.readUser(_user.userID);
      }catch(e){
        debugPrint("repoda sig in user kısmında hata  var : "+e.toString());
      }
    }
  }
}
