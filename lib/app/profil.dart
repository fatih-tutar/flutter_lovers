import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterlovers/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:flutterlovers/common_widget/social_log_in_button.dart';
import 'package:flutterlovers/viewmodel/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController _controllerUserName;
  File _profilFoto;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerUserName.dispose();
    super.dispose();
  }

  void _kameradanFotoCek() async {
    var _yeniResim = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _profilFoto = _yeniResim;
      Navigator.of(context).pop();
    });
  }

  void _galeridenResimSec() async {
    var _yeniResim = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilFoto = _yeniResim;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    _controllerUserName.text = _userModel.user.userName;
    print("Profil sayfasındaki user değerleri : " + _userModel.user.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _cikisIcinOnayIste(context),
            child: Text(
              "Çıkış",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 170,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.camera),
                                  title: Text("Kameradan Çek"),
                                  onTap: () {
                                    _kameradanFotoCek();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text("Galeriden Seç"),
                                  onTap: () {
                                    _galeridenResimSec();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    backgroundImage: _profilFoto == null
                        ? NetworkImage(_userModel.user.profileURL)
                        : FileImage(_profilFoto),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _userModel.user.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "E-posta",
                    hintText: "E-posta",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerUserName,
                  decoration: InputDecoration(
                    labelText: "Kullanıcı Adı",
                    hintText: "Kullanıcı Adı",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SocialLogInButton(
                  butonText: "Değişiklikleri Kaydet",
                  butonColor: Colors.blue,
                  onPressed: () {
                    _userNameGuncelle(context);
                    _profilFotoGuncelle(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    var sonuc = await _userModel.signOut();
    return sonuc;
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin misiniz?",
      icerik: "Çıkmak istediğinizden emin misiniz?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);
    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  void _userNameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.user.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.user.userID, _controllerUserName.text);
      if (updateResult == true) {
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "Kullanıcı adı değiştirildi.",
          anaButonYazisi: "Tamam",
        ).goster(context);
      } else {
        _controllerUserName.text = _userModel.user.userName;
        PlatformDuyarliAlertDialog(
          baslik: "Hata",
          icerik: "Kullanıcı adı zaten kullanımda, farklı bir kullanıcı adı deneyiniz.",
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    }
  }

  void _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    if(_profilFoto != null){
      var url = await _userModel.uploadFile(_userModel.user.userID, "profil_foto", _profilFoto);
      print("gelen url : " + url);
      if(url != null){
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "Profil fotoğrafınız güncellendi.",
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    }
  }
}
