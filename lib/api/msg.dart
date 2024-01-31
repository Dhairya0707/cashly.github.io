import 'dart:io';
import 'package:cashly/api/internet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FirebaseApi {
  final firebasemsg = FirebaseMessaging.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  initnoti() async {
    await firebasemsg.requestPermission();
    // final fcmtoken = await firebasemsg.getToken();
    // print(fcmtoken);
  }

  status(bool active) async {
    if (active) {
      await firestore
          .collection("active_user")
          .doc(Hive.box("hivebox").get("docid"))
          .set({
        "name": Hive.box("hivebox").get("name"),
        "id": Hive.box("hivebox").get("docid"),
        "time": DateTime.now().toString(),
      });
      await online_offline(true);
    }
    if (active == false) {
      await firestore
          .collection("active_user")
          .doc(Hive.box("hivebox").get("docid"))
          .delete();
      await lastseen();
      await online_offline(false);
    }
  }

  online_offline(bool check) async {
    await firestore
        .collection("users")
        .doc(Hive.box("hivebox").get("docid"))
        .update({"isonline": check});
  }

  lastseen() async {
    await firestore
        .collection("users")
        .doc(Hive.box("hivebox").get("docid"))
        .update({"lastseen": DateTime.now()});
  }

  track_even(String txt) async {
    await firestore
        .collection("users")
        .doc(Hive.box("hivebox").get("docid"))
        .collection("event")
        .doc()
        .set({
      "name": Hive.box("hivebox").get("name"),
      "id": Hive.box("hivebox").get("docid"),
      "time": DateTime.now(),
      "disp": txt
    });
  }

  showsnackbar(context, String txt) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
      duration: const Duration(milliseconds: 2500),
      showCloseIcon: true,
    ));
  }

  makelocalhistroy(
    String id,
    String owner,
  ) {
    List array = Hive.box("hivebox").get("histroylist") ?? [];
    array.add({"id": id, "owner": owner, "time": DateTime.now()});
    Hive.box("hivebox").put("histroylist", array);
  }

  Future<void> checkInternetConnection(context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const InternetPage()));
    }
  }

  Future<bool> checknet(context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return true;
    } on SocketException catch (_) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const InternetPage()));
      return false;
    }
  }
}
