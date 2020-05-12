import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutterlovers/locator.dart';
import 'package:flutterlovers/model/konusma.dart';
import 'package:flutterlovers/model/mesaj.dart';
import 'package:flutterlovers/model/user.dart';
import 'package:flutterlovers/services/auth_base.dart';
import 'package:flutterlovers/services/fake_auth_service.dart';
import 'package:flutterlovers/services/firebase_auth_service.dart';
import 'package:flutterlovers/services/firebase_storage_service.dart';
import 'package:flutterlovers/services/firestore_db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDbService _firestoreDbService = locator<FirestoreDbService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;
  List<User> tumKullaniciListesi = [];

  @override
  Future<User> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      User _user = await _firebaseAuthService.currentUser();
      return await _firestoreDbService.readUser(_user.userID);
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
  Future<User> createUserWithEmailandPassword(String email, String sifre) async {
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
        User _user = await _firebaseAuthService.signInWithEmailandPassword(email, sifre);
        return await _firestoreDbService.readUser(_user.userID);
    }
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDbService.updateUserName(userID, yeniUserName);
    }
  }

  Future<String> uploadFile(String userID, String fileType, File profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return "Dosya indirme linki";
    } else {
      var profilFotoURL = await _firebaseStorageService.uploadFile(userID, fileType, profilFoto);
      await _firestoreDbService.updateProfilFoto(userID, profilFotoURL);
      return profilFotoURL;
    }
  }

  Future<List<User>> getAllUser() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      tumKullaniciListesi = await _firestoreDbService.getAllUser();

      return tumKullaniciListesi;
    }
  }

  Stream<List<Mesaj>> getMessages(String currentUserID, String sohbetEdilenUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _firestoreDbService.getMessages(currentUserID, sohbetEdilenUserID);
    }
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async{
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _firestoreDbService.saveMessage(kaydedilecekMesaj);
    }
  }

  Future<List<Konusma>> getAllConversations(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {

      DateTime _zaman = await _firestoreDbService.saatiGoster(userID);

      var konusmaListesi = await _firestoreDbService.getAllConversations(userID);
      for(var oankiKonusma in konusmaListesi){
        var userListesindekiKullanici = listedeUserBul(oankiKonusma.kimle_konusuyor);
        if(userListesindekiKullanici != null){
          print("VERİLER LOCAL CACHEDEN OKUNDU");
          oankiKonusma.konusulanUserName = userListesindekiKullanici.userName;
          oankiKonusma.konusulanUserProfilURL = userListesindekiKullanici.profileURL;

        }else{
          print("VERİLER VERİTABANINDAN OKUNDU");
          print("Aranılan user veritabanından getirilmemiştir o yüzden veritabanından bu değeri okumalıyız");
          var _veritabanindanOkunanUser = await _firestoreDbService.readUser(oankiKonusma.kimle_konusuyor);
          oankiKonusma.konusulanUserName = _veritabanindanOkunanUser.userName;
          oankiKonusma.konusulanUserProfilURL = _veritabanindanOkunanUser.profileURL;
        }
        timeagoHesapla(oankiKonusma, _zaman);
      }
      return konusmaListesi;
    }
  }

  User listedeUserBul(String userID){
    for(int i = 0; i < tumKullaniciListesi.length; i++){
      if(tumKullaniciListesi[i].userID == userID){
        return tumKullaniciListesi[i];
      }
    }
    return null;
  }

  void timeagoHesapla(Konusma oankiKonusma, DateTime zaman) {
    oankiKonusma.sonOkunmaZamani = zaman;
    timeago.setLocaleMessages("tr", timeago.TrMessages());
    var _duration = zaman.difference(oankiKonusma.olusturulma_tarihi.toDate());
    oankiKonusma.aradakiFark = timeago.format(zaman.subtract(_duration), locale: "tr");
  }

  Future<List<User>> getUserwithPagination(User enSonGetirilenUser, int getirilecekElemanSayisi) async{
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {

      List<User> _userList = await _firestoreDbService.getUserwithPagination(enSonGetirilenUser, getirilecekElemanSayisi);
      tumKullaniciListesi.addAll(_userList);

      return _userList;
    }
  }
}
