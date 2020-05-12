import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterlovers/app/sohbet_page.dart';
import 'package:flutterlovers/app/ornek_page_1.dart';
import 'package:flutterlovers/model/user.dart';
import 'package:flutterlovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatefulWidget {
  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  List<User> _tumKullanicilar;
  bool _isLoading = false;
  bool _hasMore = true;
  int _getirilecekElemanSayisi = 7;
  User _enSonGetirilenUser;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // bu sayede get userhemen değil build çalıştıktan context oluştuktan sonra çalışacak
      getUser();
    });

    _scrollController.addListener(() {
      if(_scrollController.offset >= _scrollController.position.minScrollExtent && !_scrollController.position.outOfRange){
        getUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rehber"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.title),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OrnekPage1()));
              }),
        ],
      ),
      body: _tumKullanicilar == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _kullaniciListesiniOlustur(),
    );
  }

  getUser() async {
    final _userModel = Provider.of<UserModel>(context);

    if (!_hasMore) {
      //getirilecek eleman kalmadıysa buranın çalışmasına izin vermiyor veritabanına gitmiyor boş yere
      print(
          "Getirilecek eleman kalmadı o yüzden firestore rahatsız edilmeyecek");
      return;
    }
    if (_isLoading) {
      // şu an veriler yüklenirken tekrar tekrar veritabanına erişmeye çalışıldığında buna izin vermeyecek bunlar hep performans
      return;
    }

    setState(() {
      _isLoading = true;
    });

    List<User> _users = await _userModel.getUserwithPagination(
        _enSonGetirilenUser, _getirilecekElemanSayisi);

    if (_enSonGetirilenUser == null) {
      _tumKullanicilar = [];
      _tumKullanicilar.addAll(_users);
    } else {
      _tumKullanicilar.addAll(_users);
    }

    if (_users.length < _getirilecekElemanSayisi) {
      _hasMore = false;
    }

    _enSonGetirilenUser = _tumKullanicilar.last;

    setState(() {
      _isLoading = false;
    });
  }

  _kullaniciListesiniOlustur() {
    if(_tumKullanicilar.length > 1){
      return RefreshIndicator(
        onRefresh: _kullaniciListesiRefresh,
        child: ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (index == _tumKullanicilar.length) {
              return _yeniElemanlarYuleniyorIndicator();
            }

            return _userListeElemaniOlustur(index);
          },
          itemCount: _tumKullanicilar.length + 1,
        ),
      );
    }else{
      return RefreshIndicator(
        onRefresh: _kullaniciListesiRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.supervised_user_circle,
                    color: Theme.of(context).primaryColor,
                    size: 120,
                  ),
                  Text(
                    "Henüs kullanıcı yok.",
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

  Widget _userListeElemaniOlustur(int index) {
    var _oankiUser = _tumKullanicilar[index];
    final _userModel = Provider.of<UserModel>(context);
    if(_oankiUser.userID == _userModel.user.userID){
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => SohbetPage(
              currentUser: _userModel.user,
              sohbetEdilenUser: _oankiUser,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(_oankiUser.userName),
          subtitle: Text(_oankiUser.email),
          leading: CircleAvatar(
            backgroundColor: Colors.grey.withAlpha(40),
            backgroundImage: NetworkImage(_oankiUser.profileURL),
          ),
        ),
      ),
    );
  }

  _yeniElemanlarYuleniyorIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Opacity(
          opacity: _isLoading ? 1 : 0,
          child: _isLoading ? CircularProgressIndicator() : null,
        ),
      ),
    );
  }

  Future<Null> _kullaniciListesiRefresh() async{
    _hasMore = true;
    _enSonGetirilenUser = null;
    getUser();
  }
}
