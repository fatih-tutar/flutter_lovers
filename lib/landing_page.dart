import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlovers/home_page.dart';
import 'package:flutterlovers/locator.dart';
import 'package:flutterlovers/model/user_model.dart';
import 'package:flutterlovers/services/auth_base.dart';
import 'package:flutterlovers/services/firebase_auth_service.dart';
import 'package:flutterlovers/sign_in_page.dart';

class LandingPage extends StatefulWidget {

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;
  AuthBase authService = locator<FirebaseAuthService>();

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        onSingIn: (user) {
          _updateUser(user);
        },
      );
    } else {
      return HomePage(
        user: _user,
        onSignOut: (){
          _updateUser(null);
        },
      );
    }
  }

  Future<void> _checkUser() async {
    _user = await authService.currentUser();
  }

  void _updateUser(User user){
    setState(() {
      _user = user;
    });
  }
}
