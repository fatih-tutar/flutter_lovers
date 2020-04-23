import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlovers/common_widget/social_log_in_button.dart';
import 'package:flutterlovers/locator.dart';
import 'package:flutterlovers/model/user_model.dart';
import 'package:flutterlovers/services/auth_base.dart';
import 'package:flutterlovers/services/firebase_auth_service.dart';

class SignInPage extends StatelessWidget {

  final Function(User) onSingIn;
  AuthBase authService = locator<FirebaseAuthService>();

  SignInPage({Key key, @required this.onSingIn}) : super(key: key);

  Future<void> _misafirGirisi() async {
    User _user =await authService.signInAnonymously();
    onSingIn(_user);
    print("oturum açan user id"+_user.userID.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Lovers"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Oturum Açın",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            SizedBox(
              height: 8,
            ),
            SocailLoginButton(
              butonText: "Gmail ile Giriş Yap",
              butonColor: Colors.white,
              textColor: Colors.black87,
              butonIcon: Image.asset("images/google-logo.png"),
              onPressed: () {},
            ),
            SocailLoginButton(
              butonText: "Facebook ile Giriş Yap",
              butonIcon: Image.asset("images/facebook-logo.png"),
              onPressed: () {},
              butonColor: Color(0xFF334D92),
            ),
            SocailLoginButton(
              onPressed: () {},
              butonIcon: Icon(
                Icons.email,
                size: 32,
                color: Colors.white,
              ),
              butonText: "Email ve Şifre ile Giriş Yap",
            ),
            SocailLoginButton(
              onPressed: _misafirGirisi,
              butonColor: Colors.teal,
              butonIcon: Icon(
                Icons.supervised_user_circle,
                color: Colors.white,
                size: 32,
              ),
              butonText: "Misafir Girişi",
            ),
          ],
        ),
      ),
    );
  }
}
