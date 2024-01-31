import 'package:cashly/api/msg.dart';
import 'package:cashly/screen/login/loginapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseApi().checkInternetConnection(context);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    // double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome to Cashly",
          // style: Theme.of(context).textTheme.titleLarge,
          style: TextStyle(fontFamily: 'Jost', fontWeight: FontWeight.bold),
          // ignore: deprecated_member_use
          textScaleFactor: 1.2,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Gap(deviceHeight * 0.1),
              TextField(
                controller: _controller,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) {
                      if (newValue.text.isNotEmpty) {
                        return TextEditingValue(
                          text: newValue.text.substring(0, 1).toUpperCase() +
                              newValue.text.substring(1).toLowerCase(),
                          selection: newValue.selection,
                        );
                      }
                      return newValue;
                    },
                  ),
                ],
                style: const TextStyle(
                    fontFamily: "Jost", fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                    filled: true,
                    hintText: "Enter your name",
                    hintStyle: TextStyle(fontFamily: "Jost"),
                    prefixIcon: Icon(Icons.person)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await LoginApi().logintoapp(context, _controller);
          setState(() {});
        },
        label: const Text("Next",
            style: TextStyle(fontFamily: 'Jost', fontWeight: FontWeight.w600)),
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

openErrorSnackBar(context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(text),
    duration: const Duration(milliseconds: 2500),
  ));
}
