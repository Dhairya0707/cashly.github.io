// ignore: file_names
import 'package:cashly/screen/gameroom/owner/gameroom.dart';
import 'package:cashly/screen/gameroom/player/userspage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GameAuthGate extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final code;
  const GameAuthGate({super.key, required this.code});

  @override
  State<GameAuthGate> createState() => _GameAuthGateState();
}

class _GameAuthGateState extends State<GameAuthGate> {
  var box = Hive.box("hivebox");

  @override
  void initState() {
    super.initState();
    checkonwer();
    setState(() {});
  }

  checkonwer() async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('game')
        .doc(widget.code)
        .get();
    String ownerid = await docSnapshot['onwerid'];
    if (ownerid == box.get("docid")) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Gameroom(
                    roomid: widget.code,
                  )));
    } else {
      print("false you are not !");
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => User(
                    roomid: widget.code,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
