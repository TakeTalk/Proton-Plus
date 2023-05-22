import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rive_animation/main.dart';
import 'package:rive_animation/reedem_page.dart';
import 'package:rive_animation/screens/home/questions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/course.dart';
import '../entryPoint/chat/ChatScreen.dart';
import '../entryPoint/chat/chat.dart';
import 'components/course_card.dart';
import 'components/secondary_course_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? isVerified1 = false,isVerified2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Features",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: GestureDetector(
                  onDoubleTap: (){
                    logout(context);
                  },
                  child: Row(
                    children: courses
                        .map(
                          (course) => Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child:GestureDetector(
                          onTap: (){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(course.title.toString()),
                            ));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const question(),
                              ),
                            );
                            // _displayTextInputDialog(context);
                          },
                        child: CourseCard(
                          title: course.title,
                          iconSrc: course.iconSrc,
                          image: course.image,
                          color: course.color,
                          description: course.description,
                        ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Chats",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ...recentCourses
                  .map((course) => Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20),
                  child:GestureDetector(

                    onTap: (){
                      see(context);
                    },
                    child:SecondaryCourseCard(
                      title: course.title,
                      iconsSrc: course.iconSrc,
                      color: course.color,
                    ),
                  )) ,

              )

                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  void see(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    final school = prefs.getString('email') ?? '';

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text(name + " " + school),
    // ));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatApp(),
      ),
    );
  }

    Future<void> logout(BuildContext context) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("name");
      await prefs.remove("email");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("logging out"),
      ));
      await GoogleSignIn().disconnect();
      FirebaseAuth.instance.signOut();
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyApp()
            ),
        );
        SystemNavigator.pop();
      }
    }

  Future<void> _displayTextInputDialog(BuildContext context) async {

    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            height: 300,
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
                      "complete this ",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            title: const Text("heart"),
                            value: isVerified1,
                            onChanged: (bool? value) {
                              setState(() {
                                isVerified1 = value;
                              });
                            },
                            activeColor: Colors.orangeAccent,
                            checkColor: Colors.white,
                          ),
                          CheckboxListTile(
                            title: const Text("kidney"),
                            value: isVerified2,
                            onChanged: (bool? value) {
                              setState(() {
                                isVerified2 = value;
                              });
                            },
                            activeColor: Colors.orangeAccent,
                            checkColor: Colors.white,
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      child: const Text("Get Location"),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF000C56),
                      ), onPressed: () {  },
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
}
