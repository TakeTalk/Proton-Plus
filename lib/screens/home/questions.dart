import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../reedem_coins.dart';
import 'package:http/http.dart' as http;
import '../../reedem_page.dart';
import '../../../utils.dart';

class question extends StatefulWidget {
  const question({Key? key}) : super(key: key);

  @override
  State<question> createState() => _questionState();
}


class _questionState extends State<question> with WidgetsBindingObserver {
  bool? heart = false,brainNuro = false,brain = false,laungs = false,liver = false,bones = false;

  final AppLifecycleObserver lifecycleObserver = AppLifecycleObserver();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(lifecycleObserver);
    super.dispose();
  }

  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     // Handle the resume event here
  //     print('App resumed');
  //     Fluttertoast.showToast(
  //         msg: "resumed",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.red,
  //         fontSize: 16.0
  //     );
  //   }
  // }

  void _navigateAndRefresh(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReedemPage(),
      ),
    );
    if(result == null){
      vouchure.change();
    }
  }

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
      _navigateAndRefresh(context);


    } else {
    throw Exception('Failed to upload file');
    }
    // });


    // type 'String' is not a subtype of type 'List<List<Object>>' in type cast

  }


}

class AppLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Handle the resume event here
      print('App resumed');
      vouchure.change();
    }
  }
}

class vouchure{
  static change(){
    ReedemCoins.vouchers = [
      ['Get 1 free Health checkup on Apollo Hospital', 600, 'assets/images/myntra.jpg'],
      [
        'Buy Medicines using Coins (1 coins = 1 INR)',
        1,
        'assets/images/almond.jpg'
      ],
      ['₹200 Off On Booking Narayana Hospital Appointment', 200, 'assets/images/tv.jpg'],
      [
        '₹4999 off on buying Health Insurance ',
        2000,
        'assets/images/healthinsuarance.jpg'
      ],
      [' Get Free Proton Membership worth ₹3999', 2000, 'assets/images/membership.jpg'],
      [
        '10% OFF on Booking Appointment @Apollo',
        250,
        'assets/images/myntra.jpg'
      ],
      ['Flat 10% OFF in Medical Equipment', 400, 'assets/images/eq.jpg'],
      [
        'Full Body Checkup  worth ₹7999',
        000,
        'assets/images/check.jpg'
      ],
    ];
  }
}