import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../reedem_coins.dart';
import 'package:http/http.dart' as http;
import '../../reedem_page.dart';

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

              reedemProces();

          },
          ),
          ],
        ),
        ),
      ),
      ),
    );
  }

  Future<void> reedemProces() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    var value = new Map();
    value["email"] = email;
    value["brain"] = (brain! || brainNuro!);
    value["heart"] = heart;
    value["lungs"] = laungs;
    value["liver"] = liver;
    value["kidney"] = false;
    value["ortho"] = bones;

    // {
    //   "email": "string",
    // "brain": false,
    // "heart": false,
    // "lungs": false,
    // "liver": false,
    // "kidney": false,
    // "ortho": false
    // }

    // var request = http.MultipartRequest(
    //   'POST',
    //   Uri.parse(),
    // );

    final response = await http.put(
      Uri.parse('http://43.204.171.36:8989/updateHealth/$email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(value),
    );

    // request.files.add(await http.MultipartFile.fromPath('file', result.path));

    // response.send().then((response) {
    if (response.statusCode == 200) {
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   content: Text(response.body),
                // ));
      ReedemCoins.vouchers = jsonDecode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ReedemPage(),
        ),
      );


    } else {
    throw Exception('Failed to upload file');
    }
    // });


    // type 'String' is not a subtype of type 'List<List<Object>>' in type cast

  }


}
