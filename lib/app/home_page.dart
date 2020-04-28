import 'package:flutter/material.dart';
import 'package:flutterlovers/model/user_model.dart';
import 'package:flutterlovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final User user;

  HomePage({Key key, @required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: () => _cikisYap(context),
            child: Text(
              "Çıkış",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
        title: Text("Ana Sayfa"),
      ),
      body: Center(
        child: Text(
          "Hoşgeldiniz \n\n ${user.userID}",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    var sonuc = await _userModel.signOut();
    return sonuc;
  }
}
