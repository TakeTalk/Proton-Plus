import 'package:flutter/material.dart';
import 'package:rive_animation/widgets/coupn_grid.dart';
import 'widgets/horizontal_chips.dart';

// ignore: must_be_immutable
class ReedemCoins extends StatefulWidget {
  ReedemCoins({super.key});
  bool value = false;

  final List<String> chipData = [
    'Hospital',
    'Medicines',
    'Insurance',
    'Food',
    'others',
  ];

   static dynamic vouchers = [
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

  @override
  State<ReedemCoins> createState() => _ReedemCoinsState();
}

class _ReedemCoinsState extends State<ReedemCoins> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        // HorizontalChips(
        //   values: widget.chipData,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
         
            
        
        
        ),
        // const Padding(
        //   padding: EdgeInsets.only(left: 10.0, bottom: 10, top: 20),
        //   child: Text(
        //     'Earn Coins',
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontSize: 25,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        Expanded(
          child: CoupnsGrid(
            datas: ReedemCoins.vouchers,
          ),
        ),
      ],
    );
  }
}
