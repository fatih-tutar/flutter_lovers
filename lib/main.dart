import 'package:flutter/material.dart';
import 'package:flutterlovers/landing_page.dart';
import 'package:flutterlovers/locator.dart';
import 'package:flutterlovers/services/firebase_auth_service.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Lovers",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: LandingPage(),
    );
  }
}
