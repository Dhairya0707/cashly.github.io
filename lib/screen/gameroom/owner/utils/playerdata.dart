import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Playerdata {
  showplayerdata(roomid, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Alertdiolgeshow(
          roomid: roomid,
        );
      },
    );
  }
}

class Alertdiolgeshow extends StatefulWidget {
  final String roomid;
  const Alertdiolgeshow({super.key, required this.roomid});

  @override
  State<Alertdiolgeshow> createState() => _AlertdiolgeshowState();
}

class _AlertdiolgeshowState extends State<Alertdiolgeshow> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.width;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 50),
        child: AlertDialog(
          title: const Text(
            "Player Data",
            style: TextStyle(fontFamily: "Jost"),
          ),
          // icon: Icon(Icons.person),
          content: Column(
            children: [
              SizedBox(
                height: deviceHeight * 0.4,
                width: deviceWidth,
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('game')
                            .doc(widget.roomid)
                            .collection('userlist')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<QueryDocumentSnapshot> users =
                                snapshot.data!.docs;
                            return ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (BuildContext context, int index) {
                                return playerdata(
                                    users[index]["name"],
                                    users[index]["amount"].toString(),
                                    users[index]["isowner"]);
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget playerdata(String name, String amount, bool isowner) {
  bool isbank = false;
  if (name == "Bank") {
    isbank = true;
  } else {
    isbank = false;
  }
  return ListTile(
      leading: isbank
          ? const Icon(Icons.account_balance_rounded)
          : isowner
              ? const Icon(Icons.verified_rounded)
              : const Icon(Icons.person),
      title: Text(name),
      trailing: Text(
        "\$ $amount",
        // ignore: deprecated_member_use
        textScaleFactor: 1.5,
        style: const TextStyle(fontFamily: "Jost"),
      ));
}
