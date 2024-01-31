import 'package:cashly/screen/gameroom/owner/send/send.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class sheet {
  void showsheetforowner(BuildContext context, roomid) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return _buildBottomSheetContent(roomid, context);
      },
    );
  }

  void showsheetforuser(BuildContext context, roomid) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return _buildBottomSheetContentforuser(roomid, context);
      },
    );
  }
}

Widget _buildBottomSheetContent(roomid, context) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Choose an option to Send',
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: "Jost",
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        _buildList(roomid),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Back",
                  style: TextStyle(
                    fontFamily: "Jost",
                    fontWeight: FontWeight.bold,
                  ),
                ))
          ],
        )
      ],
    ),
  );
}

Widget _buildList(roomid) {
  return Expanded(
    child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('game')
          .doc(roomid)
          .collection('userlist')
          .where("id", isNotEqualTo: Hive.box("hivebox").get("docid"))
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              return sendlist(
                  users[index]['name'],
                  users[index]["isowner"],
                  users[index]['name'],
                  Hive.box("hivebox").get("name"),
                  users[index]['id'],
                  Hive.box("hivebox").get("docid"),
                  context,
                  roomid);
              //  playerdata(users[index]["name"],
              //     users[index]["amount"].toString(), users[index]["isowner"]);
            },
          );
        }
      },
    ),
  );
}

Widget _buildBottomSheetContentforuser(roomid, context) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Choose an option to Send',
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: "Jost",
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        _buildListforuser(roomid),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Back",
                  style: TextStyle(
                    fontFamily: "Jost",
                    fontWeight: FontWeight.bold,
                  ),
                ))
          ],
        )
      ],
    ),
  );
}

Widget _buildListforuser(roomid) {
  return Expanded(
    child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('game')
          .doc(roomid)
          .collection('userlist')
          .where("id", isNotEqualTo: "Bank")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              return sendlist(
                  users[index]['name'],
                  users[index]["isowner"],
                  users[index]['name'],
                  "Bank",
                  users[index]['id'],
                  "Bank",
                  context,
                  roomid);
              //  playerdata(users[index]["name"],
              //     users[index]["amount"].toString(), users[index]["isowner"]);
            },
          );
        }
      },
    ),
  );
}

Widget sendlist(String name, bool isowner, String to, String from, String toid,
    String fromid, context, String roomid) {
  bool isbank = false;
  if (name == "Bank") {
    isbank = true;
  } else {
    isbank = false;
  }
  return ListTile(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SenderScreen(
                  to: to,
                  from: from,
                  fromid: fromid,
                  roomid: roomid,
                  toid: toid)));
    },
    leading: CircleAvatar(
      child: isbank
          ? const Icon(Icons.account_balance_rounded)
          : isowner
              ? const Icon(Icons.verified_rounded)
              : const Icon(Icons.person),
    ),
    title: Text(
      name,
      style: const TextStyle(fontFamily: "Jost"),
    ),
    subtitle: Text(
      "send to $name",
      style: const TextStyle(fontFamily: "Jost"),
    ),
    // trailing: Icon(Icons.payments_outlined),
  );
}
