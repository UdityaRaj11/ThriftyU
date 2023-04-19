import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:thriftyu/modal/user.dart';

class UserProvider with ChangeNotifier {
  String? id;

  String? get userId => id;

  Future<authUser> setUser(String? id) async {
    authUser? userProf;
    await FirebaseFirestore.instance.collection('user').doc(id).get().then(
      (value) {
        userProf = authUser(
          id: id.toString(),
          email: value['email'],
          name: value['username'],
          imageURL: value['image_url'],
          balance: value['balance'],
        );
      },
    );
    return userProf!;
  }
}
