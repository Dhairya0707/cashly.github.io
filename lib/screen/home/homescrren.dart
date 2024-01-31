import 'package:cashly/api/msg.dart';
import 'package:cashly/screen/about/about.dart';
import 'package:cashly/screen/create/create.dart';
import 'package:cashly/screen/create/createapi.dart';
import 'package:cashly/screen/gameroom/GameAuthGate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  bool isclose = true;
  var box = Hive.box("hivebox");

  Future<bool> checkCodeExists(String code) async {
    if (code.length == 8 &&
        RegExp(r'^[0-9]+$').hasMatch(code) &&
        int.tryParse(code) != null &&
        int.parse(code) >= 0) {
      // Check if document exists in Firestore
      var document =
          await FirebaseFirestore.instance.collection('game').doc(code).get();
      return document.exists;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  bool ischeck = Hive.box("hivebox").containsKey("histroylist");
  List arrya = Hive.box("hivebox").get("histroylist") ?? [];

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    String capitalizedString = capitalizeFirstLetter(box.get("name"));
    @override
    void initState() {
      super.initState();
      arrya = Hive.box("hivebox").get("histroylist") ?? [];
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          scrolledUnderElevation: 0,
          toolbarHeight: deviceHeight * 0.12,
          title: SearchBar(
            textStyle: const MaterialStatePropertyAll(
                TextStyle(fontFamily: "Jost", fontWeight: FontWeight.bold)),
            onChanged: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  isclose = false;
                } else {
                  isclose = true;
                }
              });
            },
            controller: controller,
            leading: const DrawerButton(),
            elevation: const MaterialStatePropertyAll(3),
            trailing: [
              isclose
                  ? CircleAvatar(
                      child: Text(capitalizedString[0]),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          controller.clear();
                          isclose = true;
                        });
                      },
                      icon: const Icon(Icons.close_rounded))
            ],
            hintText: "Enter Code",
            hintStyle: const MaterialStatePropertyAll(
                TextStyle(fontFamily: "Jost", fontWeight: FontWeight.w600)),
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Histroy",
                        style: TextStyle(
                            fontFamily: "Jost", fontWeight: FontWeight.w500)),
                  ],
                ),
                const Gap(20),
                SizedBox(
                    height: deviceHeight * 0.7,
                    child: ischeck
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: arrya.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // String formattedTime = DateFormat('h:mm a')
                                    //     .format(arrya[index]["time"]);

                                    DateTime itemTime = arrya[index]["time"];
                                    DateTime currentTime = DateTime.now();

                                    Duration difference =
                                        currentTime.difference(itemTime);

                                    String displayText;
                                    if (difference.inHours > 24) {
                                      // Format and display the time
                                      displayText =
                                          DateFormat('h:mm a').format(itemTime);
                                    } else {
                                      // Display a different text or leave it empty
                                      // displayText = "24 hours ago";
                                      displayText =
                                          DateFormat('d/M/y').format(itemTime);
                                    }
                                    return ListTile(
                                      onTap: () async {
                                        // FirebaseApi().track_even(
                                        //     "joined stored id : ${arrya[index]["id"]}");
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GameAuthGate(
                                                        code: arrya[index]
                                                            ["id"])),
                                            (route) => false);
                                      },
                                      leading: const CircleAvatar(
                                        child:
                                            Icon(Icons.videogame_asset_rounded),
                                      ),
                                      title: Text(arrya[index]["id"],
                                          style: const TextStyle(
                                              fontFamily: "Jost",
                                              fontWeight: FontWeight.w600)),
                                      subtitle: Text(
                                          "created by ${arrya[index]["owner"]}",
                                          style: const TextStyle(
                                              fontFamily: "Jost",
                                              fontWeight: FontWeight.w500)),
                                      trailing: Text(displayText,
                                          style: const TextStyle(
                                              fontFamily: "Jost",
                                              fontWeight: FontWeight.w600)),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        : const Text("no history found"))
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: isclose
          ? FloatingActionButton.extended(
              onPressed: () async {
                // Hive.box("hivebox").delete("histroylist");
                // setState(() {});
                if (await FirebaseApi().checknet(context)) {
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateScreen()));
                } else {
                  // ignore: use_build_context_synchronously
                  FirebaseApi().checkInternetConnection(context);
                }
              },
              label: const Text("Create",
                  style: TextStyle(
                      fontFamily: "Jost", fontWeight: FontWeight.w600)),
              icon: const Icon(Icons.create),
            )
          : FloatingActionButton.extended(
              onPressed: () async {
                if (await FirebaseApi().checknet(context)) {
                  FirebaseFirestore firestore = FirebaseFirestore.instance;
                  var box = Hive.box("hivebox");
                  bool exists = await checkCodeExists(controller.text);
                  DocumentReference game =
                      firestore.collection("game").doc(controller.text);
                  // ignore: use_build_context_synchronously

                  if (exists) {
                    await game
                        .collection("userlist")
                        .doc(box.get("docid"))
                        .set({
                      "name": box.get("name"),
                      "id": box.get("docid"),
                      // ignore: use_build_context_synchronously
                      "amount": await CreateApi()
                          .getplayeramount(controller.text, context),
                      "isowner": false,
                      "isBank": false
                    });
                    DocumentSnapshot docSnapshot = await FirebaseFirestore
                        .instance
                        .collection('game')
                        .doc(controller.text)
                        .get();
                    FirebaseApi().makelocalhistroy(
                        controller.text, docSnapshot["onwername"]);
                    // FirebaseApi()
                    //     .track_even("joined room room: ${controller.text}");
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GameAuthGate(
                                  code: controller.text,
                                )),
                        (route) => false);
                  } else {
                    // ignore: use_build_context_synchronously
                    FirebaseApi().showsnackbar(
                        context, "Invalid code or does not exist");
                  }
                } else {
                  // ignore: use_build_context_synchronously
                  await FirebaseApi().checkInternetConnection(context);
                }
              },
              label: const Text("Join",
                  style: TextStyle(
                      fontFamily: "Jost", fontWeight: FontWeight.w600)),
              icon: const Icon(Icons.group),
            ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Cashly",
                  style: TextStyle(
                      fontFamily: "Jost", fontWeight: FontWeight.w700),
                  textScaleFactor: 1.8,
                ),
              ],
            )),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                "Name",
                style:
                    TextStyle(fontFamily: "Jost", fontWeight: FontWeight.w600),
                textScaleFactor: 1,
              ),
              subtitle: Text(
                box.get("name"),
                style: const TextStyle(
                    fontFamily: "Jost", fontWeight: FontWeight.w600),
                textScaleFactor: 1.5,
              ),
            ),

            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
              title: const Text(
                "About",
                style:
                    TextStyle(fontFamily: "Jost", fontWeight: FontWeight.w600),
                textScaleFactor: 1,
              ),
              subtitle: const Text(
                "about the cashly app",
                style:
                    TextStyle(fontFamily: "Jost", fontWeight: FontWeight.w600),
                textScaleFactor: 1.5,
              ),
            ),
            const Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ListTile(
                    leading: Icon(Icons.phone_android_rounded),
                    title: Text(
                      "Made In India 🇮🇳",
                      style: TextStyle(
                          fontFamily: "Jost", fontWeight: FontWeight.w600),
                      textScaleFactor: 1.2,
                    ),
                    subtitle: Text(
                      "Made with ❤ by Dhairya",
                      style: TextStyle(fontFamily: "Jost"),
                    ),
                  ),
                  Gap(10)
                ],
              ),
            ),

            ///
          ],
        ),
      ),
    );
  }
}
