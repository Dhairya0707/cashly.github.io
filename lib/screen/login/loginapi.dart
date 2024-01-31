import 'package:cashly/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class LoginApi {
  showsnackbar(context, String txt) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
      duration: const Duration(milliseconds: 2500),
      showCloseIcon: true,
    ));
  }

  logintoapp(context, TextEditingController controller) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final firebasemsg = FirebaseMessaging.instance;
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    var box = Hive.box("hivebox");

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (controller.text.isNotEmpty) {
        try {
          box.put("name", controller.text);
          box.put("isLogin", true);
          box.put("fcmtoken", await firebasemsg.getToken());

          DocumentReference data = await firestore.collection("users").add({});
          box.put("docid", data.id);
          await firestore.collection("users").doc(data.id).set({
            "name": controller.text,
            "fcmtoken": await firebasemsg.getToken(),
            "docid": data.id,
            "time": DateTime.now()
          });
          box.put("isLogin", true);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AuthGate()),
          );
          // print(data.id);
          showsnackbar(context, "Successfully Enter !");
        } on FirebaseException catch (e) {
          showsnackbar(context, e.toString());
        }
      } else {
        showsnackbar(context, "something went wrong try again");
      }
    } else {
      showsnackbar(context, "Give notification permission for proceed");
      logintoapp(context, controller);
    }
  }
}
