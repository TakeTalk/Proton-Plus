import 'dart:convert';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:rive/rive.dart';
import 'package:rive_animation/constants.dart';
import 'package:rive_animation/screens/home/home_screen.dart';
import 'package:rive_animation/utils.dart';
import 'package:rive_animation/utils/rive_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../../model/menu.dart';
import 'check.dart';
import 'components/menu_btn.dart';
import 'components/side_bar.dart';

Map UserDetails={
  'email':"",
  'phone':"",
  'name':"",
  'photoUrl':"",
  'rewardsPoints':0,
  'location_lat':"",
  'location_long':""

};

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});
  // _nameRetriever() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final name = prefs.getString('name') ?? '';
  //   final school = prefs.getString('email') ?? '';
  //
  //   print(name);
  //   print(school);
  // }

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {


  bool isPlaying = false;

  final controller = ConfettiController();

  double? lat;

  double? long;

  String address = "";


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location services are disabled.'),
      ));
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        fireBaseToUserDetails(0,0);
        Fluttertoast.showToast(
            msg: "You have to be granted permission for the location",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.red,
            fontSize: 16.0
        );
        Geolocator.openLocationSettings();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      fireBaseToUserDetails(0,0);
      Fluttertoast.showToast(
          msg: "You have to be granted permission for the location",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.red,
          fontSize: 16.0
      );
      Geolocator.openLocationSettings();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }


  getLatLong() {
    Future<Position> data = _determinePosition();
    data.then((value) {
      print("value $value");
      setState(() {
        lat = value.latitude;
        long = value.longitude;
        fireBaseToUserDetails(lat,long);
        Fluttertoast.showToast(
            msg: lat.toString()+" "+long.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      });

      // getAddress(value.latitude, value.longitude);
    }).catchError((error) {
      print("Error $error");
    });
  }

  //fot sign in api

  Future<void> _userSignIn(Map userDetails) async {


    var url = Uri.parse('http://43.204.171.36:8989/signIn');
    var body = jsonEncode(userDetails);
    var response = await http.post(url,body: body,headers: { 'Content-type': 'application/json'});


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

  fireBaseToUserDetails(double? lat,double? long) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserDetails['email']=prefs.getString('email');
    UserDetails['name']=prefs.getString('name');
    UserDetails['phone']=prefs.getString('phone');
    UserDetails['photoUrl']=prefs.getString('pic');
    UserDetails['location_lat'] = lat.toString();
    UserDetails['location_long'] = long.toString();
    savePic(prefs.getString('pic'));
    _userSignIn(UserDetails);
  }



  bool isSideBarOpen = false;

  Menu selectedBottonNav = bottomNavItems.first;
  Menu selectedSideMenu = sidebarMenus.first;

  late SMIBool isMenuOpenInput;

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
      });
    }
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        getLatLong();
        break;
      case AppLifecycleState.inactive:
      // widget is inactive
        break;
      case AppLifecycleState.paused:
      // widget is paused
        break;
      case AppLifecycleState.detached:
      // widget is detached
        break;
    }
  }


  @override
  void initState() {
    getLatLong();
    controller.addListener(() {
      if (controller.state == ConfettiControllerState.playing) {
        setState(() {
          isPlaying = true;
        });
      } else {
        setState(() {
          isPlaying = false;
        });
      }
    });
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(
        () {
          setState(() {});
        },
      );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  void helpRewards() async {
    controller.play();
    Dialogs.materialDialog(
      color: Colors.white,
      msg: 'Congratulations, you won 500 points',
      title: 'Congratulations',
      context: context,
    );

    await Future.delayed(Duration(milliseconds: 1200));


    // Navigator.of(context).pop();
    // Navigator.pop(context);
    controller.stop();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor2,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          AnimatedPositioned(
            width: 288,
            height: MediaQuery.of(context).size.height,
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 0 : -288,
            top: 0,
            child: SideBar(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(
                  1 * animation.value - 30 * (animation.value) * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: const ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                  child: HomePage(),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 220 : 0,
            top: 16,
            child: MenuBtn(
              press: () {

                // helpRewards();


                isMenuOpenInput.value = !isMenuOpenInput.value;

                if (_animationController.value == 0) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }

                setState(
                  () {
                    isSideBarOpen = !isSideBarOpen;
                  },
                );
              },
              riveOnInit: (artboard) {
                final controller = StateMachineController.fromArtboard(
                    artboard, "State Machine");

                artboard.addController(controller!);

                isMenuOpenInput =
                    controller.findInput<bool>("isOpen") as SMIBool;
                isMenuOpenInput.value = true;
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child:ConfettiWidget(
              confettiController: controller,
              shouldLoop: true,
              blastDirectionality: BlastDirectionality.explosive,
              //blastDirection: pi,
              emissionFrequency: 0.5,
              // numberOfParticles: 10,
              // maxBlastForce: 10,
              gravity: 1,
              // colors: [
              //   Colors.green,
              //   Colors.black,
              //   Colors.red,
              // ],
              // createParticlePath: (size) {
              //   double degToRad(double deg) => deg * (pi / 180.0);
              //
              //   const numberOfPoints = 5;
              //   final halfWidth = size.width / 2;
              //   final externalRadius = halfWidth;
              //   final internalRadius = halfWidth / 2.5;
              //   final degreesPerStep = degToRad(360 / numberOfPoints);
              //   final halfDegreesPerStep = degreesPerStep / 2;
              //   final path = Path();
              //   final fullAngle = degToRad(360);
              //   path.moveTo(size.width, halfWidth);
              //
              //   for (double step = 0; step < fullAngle; step += degreesPerStep) {
              //     path.lineTo(halfWidth + externalRadius * cos(step),
              //         halfWidth + externalRadius * sin(step));
              //     path.lineTo(
              //         halfWidth + internalRadius * cos(step + halfDegreesPerStep),
              //         halfWidth + internalRadius * sin(step + halfDegreesPerStep));
              //   }
              //   path.close();
              //   return path;
              // },
            ),
          ),
        ],
      ),
    );
  }

}
