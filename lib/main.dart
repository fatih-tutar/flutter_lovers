import 'package:flutter/material.dart';
import 'package:flutterlovers/app/landing_page.dart';
import 'package:flutterlovers/locator.dart';
import 'package:flutterlovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => UserModel(),
      create: (context) => UserModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Lovers',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: LandingPage(),
      ),
    );
  }
}
