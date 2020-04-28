import 'package:flutterlovers/locator.dart';
import 'package:flutterlovers/model/user_model.dart';
import 'package:flutterlovers/services/auth_base.dart';
import 'package:flutterlovers/services/fake_auth_service.dart';
import 'package:flutterlovers/services/firebase_auth_service.dart';

enum AppMode {DEBUG, RELEASE}

class UserRepository implements AuthBase {

  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<User> currentUser() async {
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthService.currentUser();
    }else{
      return await _firebaseAuthService.currentUser();
    }
  }

  @override
  Future<bool> signOut() async {
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthService.signOut();
    }else{
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<User> signInAnonymously() async {
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthService.signInAnonymously();
    }else{
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<User> signInWithGoogle() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthService.signInWithGoogle();
    }else{
      return await _firebaseAuthService.signInWithGoogle();
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthService.signInWithFacebook();
    }else{
      return await _firebaseAuthService.signInWithFacebook();
    }
  }

  @override
  Future<User> createUserWithEmailandPassword(String email, String sifre) async {
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthService.createUserWithEmailandPassword(email, sifre);
    }else{
      return await _firebaseAuthService.createUserWithEmailandPassword(email, sifre);
    }
  }

  @override
  Future<User> signInWithEmailandPassword(String email, String sifre) async {
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthService.signInWithEmailandPassword(email, sifre);
    }else{
      return await _firebaseAuthService.signInWithEmailandPassword(email, sifre);
    }
  }

}