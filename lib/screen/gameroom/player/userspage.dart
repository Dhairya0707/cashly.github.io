import 'package:cashly/api/msg.dart';
import 'package:cashly/screen/gameroom/owner/bottomsheet/bottomsheet.dart';
import 'package:cashly/screen/gameroom/owner/utils/body.dart';
import 'package:cashly/screen/gameroom/owner/utils/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../owner/utils/card.dart';

class User extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final roomid;
  const User({super.key, required this.roomid});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  String id = "";
  String ownername = "";
  String bankamount = "";
  String playeramount = "";

  @override
  void initState() {
    super.initState();
    updatedrawerdata();
    FirebaseApi().track_even("enter to userpage code:  ${widget.roomid}");
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    // FirebaseApi().track_even("exit to userpage code:  ${widget.roomid}");
  }

  updatedrawerdata() async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('game')
        .doc(widget.roomid)
        .get();
    setState(() {
      id = docSnapshot["id"];
      ownername = docSnapshot["onwername"];
      bankamount = docSnapshot["Bank"].toString();
      playeramount = docSnapshot["player"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: const DrawerButton(),
      ),
      body: SizedBox(
        height: deviceHeight * 0.86,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //card
              Expanded(
                // height: deviceHeight * 0.3,
                flex: 1,
                child: UserCard(deviceHeight, widget.roomid),
              ),
              //rest of body
              Flexible(flex: 2, child: bodyscreen(widget.roomid, context))
            ],
          ),
        ),
      ),
      drawer: Drawer_screen(
        id: id,
        ownername: ownername,
        bankamount: bankamount,
        playeramount: playeramount,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          sheet().showsheetforowner(context, widget.roomid);
        },
        label: const Text(
          "Send",
          style: TextStyle(fontFamily: "Jost", fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.payments_outlined),
      ),
    );
  }
}
