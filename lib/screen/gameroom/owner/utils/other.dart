import 'package:flutter/material.dart';

Widget playername(String name, Icon icon) {
  return Chip(
    label: Text(name),
    avatar: icon,
  );
}

Widget listtile(String to, String from, String amount) {
  return ListTile(
    title: Text(
      to,
      style: const TextStyle(fontFamily: "Jost"),
      textScaleFactor: 1.2,
    ),
    subtitle: Text(
      "$from give \$$amount to $to",
      style: const TextStyle(fontFamily: "Jost"),
      textScaleFactor: 1,
    ),
    trailing: Text(
      "\$$amount",
      style: const TextStyle(fontFamily: "Jost", fontWeight: FontWeight.w600
          // , color: Colors.green
          ),
      textScaleFactor: 1.5,
    ),
  );
}
