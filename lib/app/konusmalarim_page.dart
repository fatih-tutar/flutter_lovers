import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterlovers/app/sohbet_page.dart';
import 'package:flutterlovers/model/konusma.dart';
import 'package:flutterlovers/model/user.dart';
import 'package:flutterlovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KonusmalarimPage extends StatefulWidget {
  @override
  _KonusmalarimPageState createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage> {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Konuşmalar"),
      ),
      body: FutureBuilder<List<Konusma>>(
        future: _userModel.getAllConversations(_userModel.user.userID),
        builder: (context, konusmaListesi) {
          if (!konusmaListesi.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            var tumKonusmalar = konusmaListesi.data;
            if(tumKonusmalar.length > 0){
              return RefreshIndicator(
                onRefresh: _konusmalarimListesiniYenile,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var oankiKonusma = tumKonusmalar[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => SohbetPage(
                              currentUser: _userModel.user,
                              sohbetEdilenUser: User.idveResim(
                                  userID: oankiKonusma.kimle_konusuyor,
                                  profileURL: oankiKonusma.konusulanUserProfilURL),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(oankiKonusma.konusulanUserName,),
                        subtitle: Text(oankiKonusma.son_yollanan_mesaj),
                        trailing: Text(oankiKonusma.aradakiFark),
                        dense: false, //genel olarak list maddelerini küçültüyor daha tatlı bir görüntü oluyor
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.withAlpha(40),
                          backgroundImage: NetworkImage(
                              oankiKonusma.konusulanUserProfilURL),
                        ),
                      ),
                    );
                  },
                  itemCount: tumKonusmalar.length,
                ),
              );
            }else{
              return RefreshIndicator(
                onRefresh: _konusmalarimListesiniYenile,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.chat,
                            color: Theme.of(context).primaryColor,
                            size: 120,
                          ),
                          Text(
                            "Henüs konuşma yok.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 36),
                          )
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height - 150,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _konusmalarimiGetir() async {
    final _userModel = Provider.of<UserModel>(context);
    var konusmalarim = await Firestore.instance
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: _userModel.user.userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .getDocuments();
    for (var konusma in konusmalarim.documents) {
      print("Konuşma : " + konusma.data.toString());
    }
  }

  Future<Null> _konusmalarimListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
