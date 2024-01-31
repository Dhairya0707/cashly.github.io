import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Page",
          style: TextStyle(fontFamily: "Jost", fontWeight: FontWeight.bold),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 50,
                  ),
                ],
              ),
              Text("Cashly: Digitize Your Board Game Economy.",
                  style: TextStyle(
                      fontFamily: "Jost", overflow: TextOverflow.clip),
                  textScaleFactor: 1.6),
              Gap(25),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "About Cashly ",
                    style: TextStyle(
                        fontFamily: "Jost",
                        overflow: TextOverflow.clip,
                        fontWeight: FontWeight.bold),
                    textScaleFactor: 1.5,
                  ),
                ],
              ),
              Text(
                  "Cashly simplifies in-game transactions for board games, allowing players to focus on strategy and fun.",
                  style: TextStyle(
                      fontFamily: "Jost", overflow: TextOverflow.clip),
                  textScaleFactor: 1.2),
              Gap(25),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Key Features",
                    style: TextStyle(
                        fontFamily: "Jost",
                        overflow: TextOverflow.clip,
                        fontWeight: FontWeight.bold),
                    textScaleFactor: 1.5,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "• Easy Room Creation",
                        textScaleFactor: 1.1,
                        style: TextStyle(fontFamily: "Jost"),
                      ),
                      Text(
                        "• Secure In-Game Banking",
                        textScaleFactor: 1.1,
                        style: TextStyle(fontFamily: "Jost"),
                      ),
                      Text(
                        "• Real-Time Transaction Updates",
                        textScaleFactor: 1.1,
                        style: TextStyle(fontFamily: "Jost"),
                      ),
                    ],
                  ),
                ],
              ),
              Gap(25),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Developed by Dhairya Darji",
                    style: TextStyle(
                        fontFamily: "Jost",
                        overflow: TextOverflow.clip,
                        fontWeight: FontWeight.bold),
                    textScaleFactor: 1.5,
                  ),
                ],
              ),
              Text(
                "For more information or support,  \nvisit https://dhairyadarji.web.app/ or contact dhairyadarji025@gmail.com.",
                style: TextStyle(
                  fontFamily: "Jost",
                  overflow: TextOverflow.clip,
                ),
                textScaleFactor: 1.1,
              ),
              Gap(25),
              Row(
                children: [
                  Text(
                    "App Version: 1.0.0",
                    style: TextStyle(
                        fontFamily: "Jost", fontWeight: FontWeight.bold),
                    textScaleFactor: 1.5,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
