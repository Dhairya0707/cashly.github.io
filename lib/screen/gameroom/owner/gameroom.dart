import 'package:cashly/api/msg.dart';
import 'package:cashly/screen/gameroom/owner/bottomsheet/bottomsheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'utils/body.dart';
import 'utils/card.dart';
import 'utils/drawer.dart';

class Gameroom extends StatefulWidget {
  final roomid;
  const Gameroom({super.key, required this.roomid});

  @override
  State<Gameroom> createState() => _GameroomState();
}

class _GameroomState extends State<Gameroom> {
  String id = "";
  String ownername = "";
  String bankamount = "";
  String playeramount = "";

  @override
  void initState() {
    super.initState();
    updatedrawerdata();
    FirebaseApi().track_even("enter to onwerpage code:  ${widget.roomid}");
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    // FirebaseApi().track_even("exit to ownerpage code:  ${widget.roomid}");
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
    int currentPage = 0;
    PageController controller = PageController(initialPage: currentPage);

    return Scaffold(
      appBar: AppBar(
        leading: const DrawerButton(),
        actions: [
          IconButton(
              onPressed: () {
                controller.animateToPage(
                  controller.page!.toInt() == 0 ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.linear,
                );
              },
              icon: const Icon(Icons.swap_horiz_rounded))
        ],
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
                child: PageView(
                  controller: controller,
                  onPageChanged: (int page) {
                    setState(() {
                      currentPage = page;
                    });
                  },
                  children: [
                    UserCard(deviceHeight, widget.roomid),
                    BankCard(deviceHeight, widget.roomid)
                  ],
                ),
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
          if (controller.page!.toInt() == 0) {
            sheet().showsheetforowner(context, widget.roomid);
          } else {
            sheet().showsheetforuser(context, widget.roomid);
          }
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
