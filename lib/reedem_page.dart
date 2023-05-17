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
                      color: Color.fromARGB(255, 208, 34, 34),
                    )),
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white,
                      ))
                ],
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors:[Color(0xffae7fe8), Color(0xff6653d0)],
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
                            ),
                            Tab(
                              text: "Earn Coins",
                            ),
                          ],
                        ),
                      ],
                    ))),
            body: Container(
              decoration: const BoxDecoration(
                  gradient: RadialGradient(
                focalRadius: 2,
                radius: 0.5,
                colors: [Color(0xfcea296a), Color(0xff001f30)],
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
}


