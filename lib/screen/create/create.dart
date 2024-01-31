import 'package:cashly/api/msg.dart';
import 'package:cashly/screen/create/createapi.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  TextEditingController amountcontroller = TextEditingController();
  TextEditingController pcontroller = TextEditingController();

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Room",
          style: TextStyle(fontFamily: "Jost", fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            child: SizedBox(
              height: deviceHeight * 0.87,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Fill Detials",
                          style: TextStyle(fontFamily: "Jost"),
                          textScaleFactor: 1.5,
                        )
                      ],
                    ),
                    Gap(deviceHeight * 0.090),
                    textinput(context, amountcontroller, "Enter Bank Amount",
                        const Icon(Icons.account_balance_rounded)),
                    Gap(deviceHeight * 0.075),
                    textinput(context, pcontroller, "Enter Each Player Amount",
                        const Icon(Icons.account_balance_wallet)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isloading
            ? () {}
            : () async {
                if (await FirebaseApi().checknet(context)) {
                  setState(() {
                    isloading = true;
                  });
                  // ignore: use_build_context_synchronously
                  CreateApi().create(amountcontroller, pcontroller, context);
                } else {
                  // ignore: use_build_context_synchronously
                  FirebaseApi().checkInternetConnection(context);
                }
              },
        label: const Text(
          "Create",
          style: TextStyle(fontFamily: "Jost", fontWeight: FontWeight.w600),
        ),
        icon: isloading
            ? const SizedBox(
                height: 20, width: 20, child: CircularProgressIndicator())
            : const Icon(Icons.add),
      ),
    );
  }

  Widget textinput(
      context, TextEditingController controller, String hinttext, Icon icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontFamily: "Jost", fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        filled: true,
        hintText: hinttext,
        hintStyle: const TextStyle(fontFamily: "Jost"),
        prefixIcon: icon,
      ),
      onChanged: (value) {},
    );
  }
}
