import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class cMyApp extends StatelessWidget {
  const cMyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Confetti Animation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ConfettiController();
  bool isplaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      if (controller.state == ConfettiControllerState.playing) {
        setState(() {
          isplaying = true;
        });
      } else {
        setState(() {
          isplaying = false;
        });
      }
    });
  }

  void help() async {
    controller.play();

    await Future.delayed(Duration(seconds: 1));
      controller.stop();
  }

  bool _visible = false;

  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                help();
                _toggle();
              },
              child: Text(isplaying ? "Stop" : "Play"),
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: controller,
          shouldLoop: false,
          blastDirectionality: BlastDirectionality.explosive,

          //blastDirection: pi,
          emissionFrequency: 0.5,
          gravity: 1.0,
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
        // btn1(context)
        Visibility(
          child: Text("Invisible"),
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible:_visible,
        )
      ],
      
    );
  }

  Widget btn1(BuildContext context) {
    return Visibility(

        child : MaterialButton(
          minWidth: 300,
          color: Colors.grey[300],
          onPressed: () => Dialogs.materialDialog(
            color: Colors.white,
            msg: 'Congratulations, you won 500 points',
            title: 'Congratulations',
            lottieBuilder: Lottie.asset(
              'assets/cong_example.json',
              fit: BoxFit.contain,
            ),
            dialogWidth: kIsWeb ? 0.3 : null,
            context: context,
            actions: [
              IconsButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'Claim',
                iconData: Icons.done,
                color: Colors.blue,
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ],
          ),
          child: Text("Show animations Material Dialog"),
        )
    );
  }
}
