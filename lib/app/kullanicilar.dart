import 'package:flutter/material.dart';
import 'package:flutterlovers/app/konusma.dart';
import 'package:flutterlovers/app/ornek_page_1.dart';
import 'package:flutterlovers/model/user.dart';
import 'package:flutterlovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    _userModel.getAllUser();
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcılar"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.title),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OrnekPage1()));
              }),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: _userModel.getAllUser(),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            var tumKullanicilar = sonuc.data;
            if (tumKullanicilar.length - 1 > 0) {
              return ListView.builder(
                itemCount: tumKullanicilar.length,
                itemBuilder: (context, index) {
                  var oankiUser = sonuc.data[index];
                  if (oankiUser.userID != _userModel.user.userID) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => Konusma(currentUser: _userModel.user, sohbetEdilenUser: oankiUser,),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(oankiUser.userName),
                        subtitle: Text(oankiUser.email),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(oankiUser.profileURL),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return Center(
                child: Text("Kayıtlı bir kullanıcı yok."),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
