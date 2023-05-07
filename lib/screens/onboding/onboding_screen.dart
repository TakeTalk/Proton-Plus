import 'dart:convert';
import 'dart:ui';

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
        print("googleLogin method Called1");
        return;
      }
      print("googleLogin method Called2");
      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult =
      await FirebaseAuth.instance.signInWithCredential(credential);
      print("Result $result");
      // fireBaseToUserDetails(result);   //signIn function

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('name', result.displayName.toString());
      await prefs.setString('email', result.email.toString());
      await prefs.setString('pic', result.photoUrl.toString());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EntryPoint(),
        ),
      );







    } catch (error) {
      print("googleLogin method Called3");
      print(error);
    }
  }

  late RiveAnimationController _btnAnimationController;

  bool isShowSignInDialog = false;


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
                          Text(
                            "Don’t skip design. Learn design and code, by building real apps with Flutter and Swift. Complete courses about the best tools.",
                          ),
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
                          "Purchase includes access to 30+ courses, 240+ premium tutorials, 120+ hours of videos, source files and certificates."),
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
