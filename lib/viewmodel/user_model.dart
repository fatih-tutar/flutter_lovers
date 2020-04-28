import 'package:flutter/material.dart';
import 'package:flutterlovers/locator.dart';
import 'package:flutterlovers/model/user_model.dart';
import 'package:flutterlovers/repository/user_repository.dart';
import 'package:flutterlovers/services/auth_base.dart';

enum ViewState {Idle, Busy}

class UserModel with ChangeNotifier implements AuthBase{
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  User _user;

  User get user => _user;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserModel(){
    currentUser();
  }

  @override
  Future<User> currentUser() async {
    try{
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      return _user;
    }catch(e){
      debugPrint("Viewmodeldeki currentuserda hata : "+e.toString());
      return null;
    }finally{
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try{
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _user = null;
      return sonuc;
    }catch(e){
      debugPrint("Viewmodeldeki currentuserda hata : "+e.toString());
      return false;
    }finally{
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> signInAnonymously() async {
    try{
      state = ViewState.Busy;
      _user = await _userRepository.signInAnonymously();
      return _user;
    }catch(e){
      debugPrint("Viewmodeldeki currentuserda hata : "+e.toString());
      return null;
    }finally{
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try{
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      return _user;
    }catch(e){
      debugPrint("Viewmodeldeki currentuserda hata : "+e.toString());
      return null;
    }finally{
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    try{
      state = ViewState.Busy;
      _user = await _userRepository.signInWithFacebook();
      return _user;
    }catch(e){
      debugPrint("\nFacebook Viewmodeldeki currentuserda hata : "+e.toString()+"\n");
      return null;
    }finally{
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> createUserWithEmailandPassword(String email, String sifre) async {
    try{
      state = ViewState.Busy;
      _user = await _userRepository.createUserWithEmailandPassword(email, sifre);
      return _user;
    }catch(e){
      debugPrint("Viewmodeldeki createUserWithEmailandPassword hata : "+e.toString());
      return null;
    }finally{
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithEmailandPassword(String email, String sifre) async {
    try{
      state = ViewState.Busy;
      _user = await _userRepository.signInWithEmailandPassword(email, sifre);
      return _user;
    }catch(e){
      debugPrint("Viewmodeldeki signInWithEmailandPassword hata : "+e.toString());
      return null;
    }finally{
      state = ViewState.Idle;
    }
  }
}