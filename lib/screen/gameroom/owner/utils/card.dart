import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/adapters.dart';

// ignore: non_constant_identifier_names
Widget UserCard(deviceHeight, String roomid) {
  var box = Hive.box("hivebox");
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // cl1
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Current Balance",
                    style: TextStyle(
                        fontFamily: "Jost", fontWeight: FontWeight.w500),
                    // ignore: deprecated_member_use
                    textScaleFactor: 1.1,
                  ),
                  Icon(Icons.credit_card_rounded)
                ],
              ),
              Gap(deviceHeight * 0.005),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('game')
                        .doc(roomid)
                        .collection('userlist')
                        .doc(box.get("docid"))
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Text('User not found');
                      } else {
                        var amount = snapshot.data!['amount'];
                        return Text(
                          '\$ ${amount.toString()}',
                          style: const TextStyle(
                              fontFamily: "Jost", fontWeight: FontWeight.w700),
                          // ignore: deprecated_member_use
                          textScaleFactor: 2.5,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          //cl2

          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      Hive.box("hivebox").get("name"),
                      style: const TextStyle(
                          fontFamily: "Jost", fontWeight: FontWeight.w600),
                      // ignore: deprecated_member_use
                      textScaleFactor: 1.2,
                    ),
                    const Text(
                      "01/26",
                      style: TextStyle(
                          fontFamily: "Jost", fontWeight: FontWeight.w600),
                      // ignore: deprecated_member_use
                      textScaleFactor: 1.2,
                    )
                  ]),
            ],
          )
        ],
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Widget BankCard(deviceHeight, String roomid) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // cl1
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Current Balance",
                    style: TextStyle(
                        fontFamily: "Jost", fontWeight: FontWeight.w500),
                    // ignore: deprecated_member_use
                    textScaleFactor: 1.1,
                  ),
                  Icon(Icons.credit_card_rounded)
                ],
              ),
              Gap(deviceHeight * 0.006),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('game')
                        .doc(roomid)
                        .collection('userlist')
                        .doc("Bank")
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Text('User not found');
                      } else {
                        var amount = snapshot.data!['amount'];
                        return Text(
                          '\$ ${amount.toString()}',
                          style: const TextStyle(
                              fontFamily: "Jost", fontWeight: FontWeight.w700),
                          // ignore: deprecated_member_use
                          textScaleFactor: 2.5,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          //cl2

          const Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Cashly Bank",
                      style: TextStyle(
                          fontFamily: "Jost", fontWeight: FontWeight.w600),
                      // ignore: deprecated_member_use
                      textScaleFactor: 1.2,
                    ),
                    Text(
                      "01/26",
                      style: TextStyle(
                          fontFamily: "Jost", fontWeight: FontWeight.w600),
                      // ignore: deprecated_member_use
                      textScaleFactor: 1.2,
                    )
                  ]),
            ],
          )
        ],
      ),
    ),
  );
}
