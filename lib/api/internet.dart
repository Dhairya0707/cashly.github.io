import 'package:flutter/material.dart';

class InternetPage extends StatelessWidget {
  const InternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Text(
                  "No internet , please Try again by close and reopen the app",
                  style: TextStyle(
                      fontFamily: "Jost",
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.clip),
                  textScaleFactor: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
