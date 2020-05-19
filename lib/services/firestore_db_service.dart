import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterlovers/model/konusma.dart';
import 'package:flutterlovers/model/mesaj.dart';
import 'package:flutterlovers/model/user.dart';
import 'package:flutterlovers/services/database_base.dart';

class FirestoreDbService implements DBBase {
  final Firestore _firebaseDB = Firestore.instance;

  @override
  Future<bool> saveUser(User user) async {
    await _firebaseDB
        .collection("users")
        .document(user.userID)
        .setData(user.toMap());

    DocumentSnapshot _okunanUser =
        await Firestore.instance.document("users/${user.userID}").get();

    Map _okunanUserBilgileriMap = _okunanUser.data;
    User _okunanUserBilgileriNesne = User.fromMap(_okunanUserBilgileriMap);
    //print("Okunan User Nesnesi : " + _okunanUserBilgileriNesne.toString());

    return true;
  }

  @override
  Future<User> readUser(String userID) async {
    DocumentSnapshot _okunanUser =
        await _firebaseDB.collection("users").document(userID).get();
    Map<String, dynamic> _okunanUserBilgileriMap = _okunanUser.data;

    User _okunanUserNesnesi = User.fromMap(_okunanUserBilgileriMap);
    //print("Okunan user nesnesi : " + _okunanUserNesnesi.toString());
    return _okunanUserNesnesi;
  }

  @override
  Future<bool> updateUserName(String userID, String yeniUserName) async {
    var users = await _firebaseDB
        .collection("users")
        .where("userName", isEqualTo: yeniUserName)
        .getDocuments();
    if (users.documents.length >= 1) {
      return false;
    } else {
      await _firebaseDB
          .collection("users")
          .document(userID)
          .updateData({'userName': yeniUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilFoto(String userID, String profilFotoURL) async {
    await _firebaseDB
        .collection("users")
        .document(userID)
        .updateData({'profileURL': profilFotoURL});
    return true;
  }

  @override
  Future<List<User>> getAllUser() async {
    QuerySnapshot querySnapshot =
        await _firebaseDB.collection("users").getDocuments();
    List<User> tumKullanicilar = [];
    for (DocumentSnapshot tekUser in querySnapshot.documents) {
      User _tekUser = User.fromMap(tekUser.data);
      tumKullanicilar.add(_tekUser);
    }
    //MAP METODU İLE de yapabilirsin yukarıdaki forun aynısını yapıyor bu satır
    //tumKullanicilar = querySnapshot.documents.map((tekSatir) => User.fromMap(tekSatir.data)).toList();
    return tumKullanicilar;
  }

  @override
  Future<List<Konusma>> getAllConversations(String userID) async {
    QuerySnapshot querySnapshot =  await _firebaseDB.collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .getDocuments();
    List<Konusma> tumKonusmalar = [];
    for(DocumentSnapshot tekKonusma in querySnapshot.documents){
      Konusma _tekKonusma = Konusma.fromMap(tekKonusma.data);
      tumKonusmalar.add(_tekKonusma);
    }
    return tumKonusmalar;
  }

  @override
  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID) {
    var snapShot = _firebaseDB
        .collection("konusmalar")
        .document(currentUserID + "--" + sohbetEdilenUserID)
        .collection("mesajlar")
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots();
    return snapShot.map((mesajListesi) => mesajListesi.documents
        .map((mesaj) => Mesaj.fromMap(mesaj.data))
        .toList());
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    var _mesajID = _firebaseDB.collection("konusmalar").document().documentID;
    var _myDocumentID = kaydedilecekMesaj.kimden + "--" + kaydedilecekMesaj.kime;
    var _receiverDocumentID = kaydedilecekMesaj.kime + "--" + kaydedilecekMesaj.kimden;
    var _kaydedilecekMesajMapYapisi = kaydedilecekMesaj.toMap();
    await _firebaseDB
        .collection("konusmalar")
        .document(_myDocumentID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_kaydedilecekMesajMapYapisi);

    await _firebaseDB.collection("konusmalar").document(_myDocumentID).setData({
      "konusma_sahibi"      : kaydedilecekMesaj.kimden,
      "kimle_konusuyor"     : kaydedilecekMesaj.kime,
      "son_yollanan_mesaj"  : kaydedilecekMesaj.mesaj,
      "konusma_goruldu"     : false,
      "olusturulma_tarihi"  : FieldValue.serverTimestamp(),
    });

    _kaydedilecekMesajMapYapisi.update("bendenMi", (deger) => false);

    await _firebaseDB
        .collection("konusmalar")
        .document(_receiverDocumentID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_kaydedilecekMesajMapYapisi);

    await _firebaseDB.collection("konusmalar").document(_receiverDocumentID).setData({
      "konusma_sahibi"      : kaydedilecekMesaj.kime,
      "kimle_konusuyor"     : kaydedilecekMesaj.kimden,
      "son_yollanan_mesaj"  : kaydedilecekMesaj.mesaj,
      "konusma_goruldu"     : false,
      "olusturulma_tarihi"  : FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<DateTime> saatiGoster(String userID) async {
    await _firebaseDB.collection("server").document(userID).setData({
      "saat"    : FieldValue.serverTimestamp(),
    });
    var okunanMap = await _firebaseDB.collection("server").document(userID).get();
    Timestamp okunanTarih = okunanMap.data["saat"];
    return okunanTarih.toDate();
  }

  @override
  Future<List<User>> getUserwithPagination(User enSonGetirilenUser, int getirilecekElemanSayisi) async {
    QuerySnapshot _querySnapshot;
    List<User> _tumKullanicilar = [];
    if (enSonGetirilenUser == null) {
      _querySnapshot = await Firestore.instance
          .collection("users")
          .orderBy("userName")
          .limit(getirilecekElemanSayisi)
          .getDocuments();
    } else {
      _querySnapshot = await Firestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([enSonGetirilenUser.userName])
          .limit(getirilecekElemanSayisi)
          .getDocuments();
      await Future.delayed(Duration(seconds: 1));
    }
    for (DocumentSnapshot snap in _querySnapshot.documents) {
      User _tekUser = User.fromMap(snap.data);
      _tumKullanicilar.add(_tekUser);
    }
    return _tumKullanicilar;
  }

  Future<List<Mesaj>> getMessagewithPagination(String currentUserID, String sohbetEdilenUserID, Mesaj enSonGetirilenMesaj, int getirilecekElemanSayisi) async {
    QuerySnapshot _querySnapshot;
    List<Mesaj> _tumMesajlar = [];
    if (enSonGetirilenMesaj == null) {
      _querySnapshot = await Firestore.instance
          .collection("konusmalar")
          .document(currentUserID + "--" + sohbetEdilenUserID)
          .collection("mesajlar")
          .orderBy("date", descending: true)
          .limit(getirilecekElemanSayisi)
          .getDocuments();
    } else {
      _querySnapshot = await Firestore.instance
          .collection("konusmalar")
          .document(currentUserID + "--" + sohbetEdilenUserID)
          .collection("mesajlar")
          .orderBy("date", descending: true)
          .startAfter([enSonGetirilenMesaj.date])
          .limit(getirilecekElemanSayisi)
          .getDocuments();
      await Future.delayed(Duration(seconds: 1));
    }
    for (DocumentSnapshot snap in _querySnapshot.documents) {
      Mesaj _tekMesaj = Mesaj.fromMap(snap.data);
      _tumMesajlar.add(_tekMesaj);
    }
    return _tumMesajlar;
  }
}
