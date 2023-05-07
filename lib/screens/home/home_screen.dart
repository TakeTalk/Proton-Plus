import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rive_animation/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../go to get_lat_long_address.dart';
import '../../model/course.dart';
import '../entryPoint/chat/ChatScreen.dart';
import '../entryPoint/chat/chat.dart';
import 'components/course_card.dart';
import 'components/secondary_course_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
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
                            colorl: course.color,
                          ),
                        )) ,

                        )

                  .toList(),
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
                        child: CourseCard(
                          title: course.title,
                          iconSrc: course.iconSrc,
                          color: course.color,
                          description: course.description,
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
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
}
