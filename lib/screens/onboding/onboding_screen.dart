import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rive/rive.dart';
import 'package:rive_animation/loginn.dart';
import 'package:rive_animation/screens/entryPoint/entry_point.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../firebase_options.dart';
import 'components/animated_btn.dart';
import 'components/sign_in_dialog.dart';
import 'package:location/location.dart';

import 'components/sign_in_form.dart';


  Map UserDetails={
    'email':"",
    'phone':"",
    'name':"",
    'photoUrl':"",
    'rewardsPoints':0,
    'location_lat':"",
    'location_long':""

};



class OnbodingScreen extends StatefulWidget {
  const OnbodingScreen({super.key});

  @override
  State<OnbodingScreen> createState() => _OnbodingScreenState();
}

class _OnbodingScreenState extends State<OnbodingScreen> {

  bool isLoggedIn=false;

  Location location = new Location();

  bool _serviceEnabled=false;


  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );

    super.initState();
  }




  Future<void> _userSignIn(Map userDetails) async {


    var url = Uri.parse('http://43.204.171.36:8989/signIn');
    var body = jsonEncode(userDetails);
    var response = await http.post(url,body: body);



    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Logged In successfully"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("error"),
      ));
    }
  }

  fireBaseToUserDetails(result){
    UserDetails['email']=result.email.toString();
    UserDetails['name']=result.name.toString();
    UserDetails['photoUrl']=result.photoUrl.toString();
    _userSignIn(UserDetails);
  }

  void checkLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.containsKey('email');
    if(isLoggedIn){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EntryPoint(),
        ),
      );
    }
    else{
      googleLogin();
    }
    setState(() {

    });
  }

  googleLogin() async {
    print("googleLogin method Called");



    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var result = await _googleSignIn.signIn();
      if (result == null) {
        return;
      }
      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult =
      await FirebaseAuth.instance.signInWithCredential(credential);
      print("Result $result");
      // fireBaseToUserDetails(result);   //signIn function
      var email = result.email;

      var url = Uri.parse('http://43.204.171.36:8989/getPhone/$email');
      var response = await http.get(url);

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content:Text(response.body),
      // ));

      final SharedPreferences prefs = await SharedPreferences.getInstance();


      if(response.body=="null" || response.body=="\"null\"" || response.body == "\"\"")
      await _displayTextInputDialog(context,result.displayName.toString(),result.email.toString(),result.photoUrl.toString());
      else {
        await prefs.setString('name', result.displayName.toString());
        await prefs.setString('email', result.email.toString());
        await prefs.setString('pic', result.photoUrl.toString());
        await prefs.setString('phone', response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EntryPoint(),
          ),
        );
      }

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const EntryPoint(),
      //   ),
      // );







    } catch (error) {
      print("googleLogin method Called3");
      print(error);
    }
  }

  late RiveAnimationController _btnAnimationController;

  bool isShowSignInDialog = false;

  TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context,String name, String email , String photo) async {

     savePhone(String text) async{
       final SharedPreferences prefs = await SharedPreferences.getInstance();

       await prefs.setString('name', name);
       await prefs.setString('email', email);
       await prefs.setString('pic', photo);
       await prefs.setString('phone', text);
     }
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            height: 320,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 30),
                  blurRadius: 60,
                ),
                const BoxShadow(
                  color: Colors.black45,
                  offset: Offset(0, 30),
                  blurRadius: 60,
                ),
              ],
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Add Your Phone Number",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          child: TextField(
                                controller: _textFieldController,
                                decoration: InputDecoration(hintText: "phone"),
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 24),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await savePhone(_textFieldController.text);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => const EntryPoint(),
                              ),
                              );
                // Navigator.pop(context);
                          },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF77D8E),
                              minimumSize: const Size(double.infinity, 56),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                ),
                              ),
                            ),
                            icon: const Icon(
                              CupertinoIcons.arrow_right,
                              color: Color(0xFFFE0037),
                            ),
                            label: const Text("Sign In"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),



              ),
            ),
          ),
        );
        // AlertDialog(
        //   elevation: 50,
        //   backgroundColor: Colors.blue.shade100,
        //   title: Text('Please Add Your Phone Number'),
        //   content: TextField(
        //     controller: _textFieldController,
        //     decoration: InputDecoration(hintText: "phone"),
        //   ),
        //   actions: <Widget>[
        //     TextButton(
        //       child: Text('CANCEL'),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //     ),
        //     TextButton(
        //       child: Text('OK'),
        //       onPressed: () async {
        //         await savePhone(_textFieldController.text);
        //         Navigator.pop(context);
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => const EntryPoint(),
        //           ),
        //         );
        //         // Navigator.pop(context);
        //       },
        //     ),
        //   ],
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            left: 100,
            bottom: 100,
            child: Image.asset(
              "assets/Backgrounds/Spline.png",
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset(
            "assets/RiveAssets/shapes.riv",
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          AnimatedPositioned(
            top: isShowSignInDialog ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 260),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 320,
                      child: Column(
                        children: const [
                          Text(
                            "Hello 👋 Your Medical Assistance just a chat away!!",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        checkLogin();
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                          ""),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
