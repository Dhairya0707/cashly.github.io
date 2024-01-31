import 'package:cashly/api/msg.dart';
import 'package:cashly/color_schemes.g.dart';
import 'package:cashly/firebase_options.dart';
import 'package:cashly/screen/home/homescrren.dart';
import 'package:cashly/screen/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initnoti();
  await Hive.initFlutter();
  await Hive.openBox('hivebox');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains("resumed")) {
        FirebaseApi().status(true);
      }
      if (message.toString().contains("paused")) {
        FirebaseApi().status(false);
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
        ),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        themeMode: ThemeMode.dark,
        home: const AuthGate());
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  var box = Hive.box("hivebox");

  @override
  void initState() {
    super.initState();
    FirebaseApi().checkInternetConnection(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (box.get("isLogin") ?? false) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
