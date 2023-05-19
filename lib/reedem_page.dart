import 'package:flutter/material.dart';
import 'package:rive_animation/reedem_coins.dart';

class ReedemPage extends StatefulWidget {
  const ReedemPage({super.key});

  @override
  State<ReedemPage> createState() => _ReedemPageState();
}

class _ReedemPageState extends State<ReedemPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                actions: [
                  IconButton(
                      onPressed: () {
                        _displayTextInputDialog(context);
                      },
                      icon: const Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white,
                      ))
                ],
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors:[Color(0xFF1B6BFF), Color(0xFF7BBFFF)],
                          stops: [0, 1],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight)),
                ),
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(170),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/dollar.png',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              '100',
                              style: TextStyle(
                                color: Color.fromARGB(255, 224, 225, 236),
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Coin Balance',
                          style: TextStyle(
                            color: Color.fromARGB(255, 251, 251, 251),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          '1 Proton Coins = 1 INR',
                          style: TextStyle(
                            color: Color.fromARGB(255, 248, 247, 249),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const TabBar(
                          indicatorColor: Color.fromARGB(255, 227, 172, 172),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          tabs: [
                            Tab(
                              text: "Reedem Coins",
                            )
                          ],
                        ),
                      ],
                    ))),
            body: Container(
              decoration: const BoxDecoration(
                  gradient: RadialGradient(
                focalRadius: 2,
                radius: 0.5,
                colors: [Color(0xFF5320FF), Colors.white],
                stops: [0, 2],
                center: Alignment.bottomLeft,
              )),
              child: TabBarView(children: [
                ReedemCoins(),
                ReedemCoins(),
              ]),
            ),
          )),
    );
  }
  Future<void> _displayTextInputDialog(BuildContext context) async {

    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            width: double.infinity,
            height: 200,
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
                      "Earn Coin",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      "You can earn coin from booking appointment You can earn coin from ",
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
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


