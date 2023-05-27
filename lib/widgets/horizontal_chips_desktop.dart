import 'package:flutter/material.dart';

class HorizontalChipsDesktop extends StatelessWidget {
  const HorizontalChipsDesktop({
    super.key,
    required this.values,
  });

  final List values;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: values.map((data) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Chip(
            label: Text(
              data,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 51, 51, 51),
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
        );
      }).toList(),
    );
  }
}
