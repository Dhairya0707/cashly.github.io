// import 'package:cashly/screen/gameroom/owner/utils/playerdata.dart';
import 'package:cashly/screen/gameroom/owner/utils/playerdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'other.dart';

Widget bodyscreen(String roomid, context) {
  return Column(
    children: [
      const Gap(20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            "Players",
            style: TextStyle(fontFamily: "Jost", fontWeight: FontWeight.w600),
            // ignore: deprecated_member_use
            textScaleFactor: 1.2,
          ),
          IconButton(
              onPressed: () {
                Playerdata().showplayerdata(roomid, context);
                // print("click");
              },
              icon: const Icon(Icons.error_outline_rounded))
        ],
      ),
      SizedBox(
        height: 70,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('game')
              .doc(roomid)
              .collection('userlist')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<QueryDocumentSnapshot> users = snapshot.data!.docs;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: playername(
                        users[index]['name'],
                        users[index]['isBank']
                            ? const Icon(Icons.account_balance_rounded)
                            : const Icon(Icons.person_rounded)),
                  );
                },
              );
            }
          },
        ),
      ),
      const Gap(20),
      const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Transaction",
            style: TextStyle(fontFamily: "Jost", fontWeight: FontWeight.w600),
            // ignore: deprecated_member_use
            textScaleFactor: 1.2,
          )
        ],
      ),
      // Gap(5),
      Expanded(
        // height: ,
        // fit: FlexFit.tight,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('game')
              .doc(roomid)
              .collection('transactions')
              .orderBy("time", descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<QueryDocumentSnapshot> users = snapshot.data!.docs;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: listtile(users[index]["to"], users[index]["from"],
                          users[index]["amount"].toString()));
                },
              );
            }
          },
        ),
      )
    ],
  );
}
