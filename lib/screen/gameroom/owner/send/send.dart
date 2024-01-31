import 'package:cashly/api/msg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:slide_to_act/slide_to_act.dart';

// ignore: must_be_immutable
class SenderScreen extends StatefulWidget {
  String to;
  String from;
  String roomid;
  String fromid;
  String toid;
  SenderScreen(
      {super.key,
      required this.to,
      required this.from,
      required this.fromid,
      required this.roomid,
      required this.toid});

  @override
  State<SenderScreen> createState() => _SenderScreenState();
}

class _SenderScreenState extends State<SenderScreen> {
  TextEditingController controller = TextEditingController();
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    print(widget.toid);
    print(widget.fromid);
  }

  Future<void> _performTransaction(BuildContext context) async {
    if (controller.text.isNotEmpty &&
        double.tryParse(controller.text) != null &&
        double.parse(controller.text) > 0) {
      // start from her
      // isloading = true;
      setState(() {});
      if (await FirebaseApi().checknet(context)) {
        try {
          // Access Firestore and perform transaction
          // await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot fromUserRef = await FirebaseFirestore.instance
              .collection('game')
              .doc(widget.roomid)
              .collection("userlist")
              .doc(widget.fromid)
              .get();
          print(widget.fromid);
          DocumentSnapshot toUserRef = await FirebaseFirestore.instance
              .collection('game')
              .doc(widget.roomid)
              .collection("userlist")
              .doc(widget.toid)
              .get();

          // Check if the fromUser has sufficient balance
          if (fromUserRef['amount'] >= int.parse(controller.text)) {
            await FirebaseFirestore.instance
                .collection('game')
                .doc(widget.roomid)
                .collection("userlist")
                .doc(widget.toid)
                .update({
              "amount": toUserRef['amount'] + int.parse(controller.text)
            });
            await FirebaseFirestore.instance
                .collection('game')
                .doc(widget.roomid)
                .collection("userlist")
                .doc(widget.fromid)
                .update({
              "amount": fromUserRef['amount'] - int.parse(controller.text)
            });
            FirebaseFirestore.instance
                .collection('game')
                .doc(widget.roomid)
                .collection("transactions")
                .doc()
                .set({
              "amount": int.parse(controller.text),
              "to": widget.to,
              "from": widget.from,
              "time": DateTime.now()
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Done transaction.'),
                duration: Duration(seconds: 1),
              ),
            );
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Not enough balance for the transaction.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        } catch (error) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Transaction failed: $error'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        // ignore: use_build_context_synchronously
        FirebaseApi().checkInternetConnection(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid positive number.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Send Money",
            style: TextStyle(
                fontFamily: "Jost",
                // color: Colors.black,
                fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.wallet_rounded),
                  ),
                  title: Text(
                    widget.to,
                    style: const TextStyle(fontFamily: "Jost"),
                  ),
                  subtitle: Text(
                    "From ${widget.from}",
                    style: const TextStyle(fontFamily: "Jost"),
                  ),
                ),
              ),
              const Gap(10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Amount",
                    textScaleFactor: 1.2,
                    style: TextStyle(
                        fontFamily: "Jost", fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.attach_money_rounded),
                  title: TextField(
                    controller: controller,
                    style: const TextStyle(
                        fontFamily: "Jost", fontWeight: FontWeight.w600),
                    enableSuggestions: false,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SlideAction(
                      onSubmit: () async {
                        await _performTransaction(context);
                      },
                      borderRadius: 20,
                      innerColor: Colors.deepPurple.shade200,
                      outerColor: Colors.deepPurple,
                      submittedIcon: const Icon(
                        Icons.payments_rounded,
                        opticalSize: 10,
                      ),
                      child: const Text(
                        "Slide To Pay",
                        // ignore: deprecated_member_use
                        textScaleFactor: 1.6,
                        style: TextStyle(
                            fontFamily: "Jost", fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
