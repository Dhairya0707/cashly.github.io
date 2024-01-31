// ignore: file_names
import 'dart:math';
import 'package:cashly/api/msg.dart';
import 'package:cashly/screen/gameroom/GameAuthGate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CreateApi {
  static String? _uniqueCode;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var box = Hive.box("hivebox");

  static String generateRandomCode() {
    const chars = '0123456789';
    final random = Random();
    String code = '';
    for (int i = 0; i < 8; i++) {
      code += chars[random.nextInt(chars.length)];
    }
    return code;
  }

  static Future<String> getUniqueCode() async {
    if (_uniqueCode == null) {
      do {
        _uniqueCode = generateRandomCode();
        final usersRef = FirebaseFirestore.instance.collection('users');
        final doc = usersRef.doc(_uniqueCode);
        final docSnapshot = await doc.get();
        if (docSnapshot.exists) {
          _uniqueCode = null;
        }
      } while (_uniqueCode == null);
    }
    return _uniqueCode!;
  }

  Future<double> getbankamount(code, context) async {
    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection('game').doc(code).get();
    double bankAmount = docSnapshot['Bank'];
    return bankAmount;
  }

  Future<double> getplayeramount(code, context) async {
    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection('game').doc(code).get();
    double bankAmount = docSnapshot["player"];
    return bankAmount;
  }

  create(TextEditingController bankController,
      TextEditingController playerController, context) async {
    //
    String code = await getUniqueCode();
    DocumentReference game =
        firestore.collection("game").doc(await getUniqueCode());
    // check conditions
    if (bankController.text.isNotEmpty &&
        double.tryParse(bankController.text) != null &&
        double.parse(bankController.text) > 0 &&
        playerController.text.isNotEmpty &&
        double.tryParse(playerController.text) != null &&
        double.parse(playerController.text) > 0) {
      double enteredBank = double.parse(bankController.text);
      double enteredPlayer = double.parse(playerController.text);
      // firebase data work
      await game.set({
        "Bank": enteredBank,
        "player": enteredPlayer,
        "id": await getUniqueCode(),
        "onwerid": box.get("docid"),
        "onwername": box.get("name"),
        "time": DateTime.now()
      });
      await game.collection("userlist").doc(box.get("docid")).set({
        "name": box.get("name"),
        "id": box.get("docid"),
        "amount": await getplayeramount(await getUniqueCode(), context),
        "isowner": true,
        "isBank": false
      });
      await game.collection("userlist").doc("Bank").set({
        "name": "Bank",
        "id": "Bank",
        "amount": await getbankamount(await getUniqueCode(), context),
        "ownername": box.get("name"),
        "isowner": false,
        "isBank": true,
        "ownerid": box.get("docid"),
      });
      game.collection("transactions").doc().set({
        "amount": await getbankamount(await getUniqueCode(), context),
        "to": "Bank",
        "from": "Bank",
        "time": DateTime.now()
      });
      FirebaseApi().makelocalhistroy(code, box.get("name"));
      FirebaseApi().showsnackbar(context, "Successfully Created");
      FirebaseApi().track_even("created room: $code");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => GameAuthGate(
                    code: code,
                  )),
          (route) => false);
    } else {
      FirebaseApi().showsnackbar(context,
          "Invalid input. Please enter valid numbers for both Bank and Player");
    }
  }
}
