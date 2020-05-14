import 'package:flutter/material.dart';
import 'package:flutterlovers/app/konusmalarim_page.dart';
import 'package:flutterlovers/app/kullanicilar.dart';
import 'package:flutterlovers/app/my_custom_bottom_navi.dart';
import 'package:flutterlovers/app/profil.dart';
import 'package:flutterlovers/app/tab_items.dart';
import 'package:flutterlovers/model/user.dart';
import 'package:flutterlovers/viewmodel/all_users_view_model.dart';
import 'package:flutterlovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Konusmalarim;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Konusmalarim: KonusmalarimPage(),
      TabItem.Kullanicilar: ChangeNotifierProvider(
        builder: (context) => AllUserViewModel(),
        child: KullanicilarPage(),
      ),
      TabItem.Profil: ProfilPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(
        sayfaOlusturucu: tumSayfalar(),
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }
        },
      ),
    );
  }
}
