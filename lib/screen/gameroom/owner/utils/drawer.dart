import 'package:cashly/api/msg.dart';
import 'package:cashly/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// ignore: camel_case_types
class Drawer_screen extends StatefulWidget {
  final String id;
  final String ownername;
  final String bankamount;
  final String playeramount;
  const Drawer_screen(
      {super.key,
      required this.id,
      required this.ownername,
      required this.bankamount,
      required this.playeramount});

  @override
  State<Drawer_screen> createState() => _Drawer_screenState();
}

// ignore: camel_case_types
class _Drawer_screenState extends State<Drawer_screen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var box = Hive.box("hivebox");

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Cashly",
                style:
                    TextStyle(fontFamily: "Jost", fontWeight: FontWeight.w700),
                textScaleFactor: 1.8,
              ),
            ],
          )),
          ListBody(
            children: [
              ListTile(
                leading: const Icon(Icons.room),
                title: const Text(
                  "Room Id",
                  style: TextStyle(
                      fontFamily: "Jost", fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1,
                ),
                subtitle: Text(
                  widget.id,
                  style: const TextStyle(
                      fontFamily: "Jost", fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1.5,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.face_rounded),
                title: const Text(
                  "Room Owner",
                  style: TextStyle(
                      fontFamily: "Jost", fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1,
                ),
                subtitle: Text(
                  widget.ownername,
                  style: const TextStyle(
                      fontFamily: "Jost", fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1.5,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.business_rounded),
                title: const Text(
                  "Bank Amount",
                  style: TextStyle(
                      fontFamily: "Jost", fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1,
                ),
                subtitle: Text(
                  "\$ ${widget.bankamount}",
                  style: const TextStyle(
                      fontFamily: "Jost", fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1.2,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.monetization_on),
                title: const Text(
                  "Each Player Amount",
                  style: TextStyle(
                      fontFamily: "Jost", fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1,
                ),
                subtitle: Text(
                  "\$ ${widget.playeramount}",
                  style: const TextStyle(
                      fontFamily: "Jost", fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1.2,
                ),
              ),
              ListTile(
                onTap: () {
                  FirebaseApi().track_even("exit from room : ${widget.id}");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthGate()),
                      (route) => false);
                },
                leading: const Icon(Icons.exit_to_app_rounded),
                title: const Text(
                  "Exit",
                  style: TextStyle(
                      fontFamily: "Jost", fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1,
                ),
                subtitle: const Text(
                  "Exit the Game Room",
                  style: TextStyle(
                      fontFamily: "Jost", fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1.1,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
