import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlovers/locator.dart';
import 'package:flutterlovers/model/user_model.dart';
import 'package:flutterlovers/services/auth_base.dart';
import 'package:flutterlovers/services/firebase_auth_service.dart';

class HomePage extends StatelessWidget {

  final Function onSignOut;
  AuthBase authService = locator<FirebaseAuthService>();
  final User user;

  HomePage({Key key, @required this.user, @required this.onSignOut}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: _cikisYap,
            child: Text(
              "Çıkış",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
        title: Text("Ana Sayfa"),
      ),
      body: Center(
        child: Text(
          "Hoşgeldiniz.\n\n${user.userID}",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Future<bool> _cikisYap() async {
    var sonuc = await authService.signOut();
    onSignOut();
    return sonuc;
  }
}
