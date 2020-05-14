import 'package:flutter/material.dart';
import 'package:flutterlovers/locator.dart';
import 'package:flutterlovers/model/user.dart';
import 'package:flutterlovers/repository/user_repository.dart';

enum AllUserViewState{Idle, Loaded, Busy}

class AllUserViewModel with ChangeNotifier{

  AllUserViewState _state = AllUserViewState.Idle;
  List<User> _tumKullanicilar;
  User _enSonGetirilenUser;
  static final sayfaBasinaGonderiSayisi = 7;
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  UserRepository _userRepository = locator<UserRepository>();
  List<User> get kullanicilarListesi => _tumKullanicilar;
  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserViewModel(){
    _tumKullanicilar = [];
    _enSonGetirilenUser = null;
    getUserWithPagination(_enSonGetirilenUser, false);
  }

  //refresh ve sayfalama için
  //yeni elemanlar getir true yapılır
  //ilk açılış için yenielemanlar için false değer verilir
  getUserWithPagination(User enSonGetirilenUser, bool yeniElemanlarGetiriliyor) async {

    if(_tumKullanicilar.length > 0){
      _enSonGetirilenUser = _tumKullanicilar.last;
      print("En son getirilen user name : " +_enSonGetirilenUser.userName);
    }

    if(yeniElemanlarGetiriliyor){

    }else{
      state = AllUserViewState.Busy;
    }

    var yeniListe = await _userRepository.getUserwithPagination(_enSonGetirilenUser, sayfaBasinaGonderiSayisi);

    if(yeniListe.length < sayfaBasinaGonderiSayisi){
      _hasMore = false;
    }

    yeniListe.forEach((usr) => print("Getirilen user name : "+ usr.userName));

    _tumKullanicilar.addAll(yeniListe);
    state = AllUserViewState.Loaded;
  }

  Future<void> dahaFazlaUserGetir() async {
    print("Daha fazla user getir tetiklendi - viewmodeldeyiz");
    if(_hasMore) {
      getUserWithPagination(_enSonGetirilenUser, true);
    }else {
      print("Daha fazla eleman yok o yüzden çağırmayacak");
    }
    await Future.delayed(Duration(seconds: 2));
  }

  Future<Null> refresh() async{
    _hasMore = true;
    _enSonGetirilenUser = null;
    _tumKullanicilar = [];
    getUserWithPagination(_enSonGetirilenUser, true);
  }
}