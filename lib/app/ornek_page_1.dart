import 'package:flutter/material.dart';
import 'package:flutterlovers/app/ornek_page_2.dart';

class OrnekPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Örnek Page 1"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.adb),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => OrnekPage2()));
              }),
        ],
      ),
      body: Center(
        child: Text("Örnek Page 1 Sayfası"),
      ),
    );
  }
}
