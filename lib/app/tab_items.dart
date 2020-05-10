import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem {Kullanicilar, Konusmalarim, Profil}

class TabItemData{
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.Konusmalarim  : TabItemData("Konuşmalarım", Icons.chat),
    TabItem.Kullanicilar  : TabItemData("Rehber", Icons.supervised_user_circle),
    TabItem.Profil        : TabItemData("Profil", Icons.person),
  };
}