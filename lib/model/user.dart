import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  final String userID;
  String email, userName, profileURL;
  DateTime createdAt, updatedAt;
  int seviye;

  User({@required this.userID, @required this.email});
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName ??
          email.substring(0, email.indexOf('@')) +
              randomSayiUret(), // boş değilse kullan boşsa bunu kullan
      'profileURL': profileURL ??
          'https://www.bluelife.mu/wp-content/uploads/2016/07/Empty-profile-photo.png',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'seviye': seviye ?? 1, // varsayılan değer atama şekli
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profileURL = map['profileURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        seviye = map['seviye'];

  @override
  String toString() {
    return 'User{userID: $userID, email: $email, userName: $userName, profileURL: $profileURL, createdAt: $createdAt, updatedAt: $updatedAt, seviye: $seviye}';
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999);
    return rastgeleSayi.toString();
  }
}
