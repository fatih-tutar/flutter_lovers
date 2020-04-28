import 'package:flutter/material.dart';
import 'package:flutterlovers/common_widget/social_log_in_button.dart';
import 'package:flutterlovers/model/user_model.dart';
import 'package:flutterlovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

enum FormType {Register, Login}

class EmailveSifreLoginPage extends StatefulWidget {
  @override
  _EmailveSifreLoginPageState createState() => _EmailveSifreLoginPageState();
}

class _EmailveSifreLoginPageState extends State<EmailveSifreLoginPage> {

  String _email, _sifre;
  String _butonText, _linkText;
  var _formType = FormType.Login;
  final _formKey = GlobalKey<FormState>();

  _formSubmit() async {
    _formKey.currentState.save();
    debugPrint("email : "+_email+" şifre : "+_sifre);
    _email = _email.trim();
    final _userModel = Provider.of<UserModel>(context);
    if(_formType == FormType.Login){
      User _girisYapanUser = await _userModel.signInWithEmailandPassword(_email, _sifre);
      if(_girisYapanUser != null) print("Oturum açan user id : "+_girisYapanUser.userID.toString());
    }else{
      User _olusturulanUser = await _userModel.createUserWithEmailandPassword(_email, _sifre);
      if(_olusturulanUser != null) print("Kayıt açan user id : "+_olusturulanUser.userID.toString());
    }
  }

  void _degistir() {
    setState(() {
      _formType = _formType == FormType.Login ? FormType.Register : FormType.Login;
    });
  }

  @override
  Widget build(BuildContext context) {

    _butonText = _formType == FormType.Login ? "Giriş Yap " : "Kayıt Ol";
    _linkText = _formType == FormType.Login ? "Hesabınız yok mu? Kayıt olun." : "Hesabınız var mı? Giriş yapın.";

    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş / Kayıt"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    hintText: 'Email',
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (String girilenEmail){
                    _email = girilenEmail;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Şifre',
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (String girilenSifre){
                    _sifre = girilenSifre;
                  },
                ),
                SizedBox(
                  height:8,
                ),
                SocialLogInButton(
                  butonText: _butonText,
                  butonColor: Theme.of(context).primaryColor,
                  radius: 10,
                  onPressed: () => _formSubmit(),
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  onPressed: () => _degistir(),
                  child: Text(_linkText),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
