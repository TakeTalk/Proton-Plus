import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class question extends StatefulWidget {
  const question({Key? key}) : super(key: key);

  @override
  State<question> createState() => _questionState();
}

class _questionState extends State<question> {
  bool? heart = false,brainNuro = false,brain = false,laungs = false,liver = false,bones = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "what kind of issues you have ?",
            style: TextStyle(
              fontSize: 24,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 80),
          CheckboxListTile(
            title: const Text("Cardiatic issues"),
            value: heart,
            onChanged: (bool? value) {
              setState(() {
              heart = value;
            });
            },
          ),
          CheckboxListTile(
            title: const Text("Neurological disfunction"),
            value: brainNuro,
            onChanged: (bool? value) {
              setState(() {
                brainNuro = value;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("Brain issues"),
            value: brain,
            onChanged: (bool? value) {
              setState(() {
                brain = value;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("Are you smoker ?"),
            value: laungs,
            onChanged: (bool? value) {
              setState(() {
                laungs = value;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("Are you alcoholic ?"),
            value: liver,
            onChanged: (bool? value) {
              setState(() {
                liver = value;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("Have you any ortho pedic issues"),
            value: bones,
            onChanged: (bool? value) {
              setState(() {
                bones = value;
              });
            },
          ),
          ElevatedButton(
            child: const Text("next"),
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF000C56),
            ), onPressed: () {
              // save()
          },
          ),
          ],
        ),
        ),
      ),
      ),
    );
  }


}
