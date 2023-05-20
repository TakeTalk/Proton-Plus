import 'package:flutter/material.dart';

class HorizontalChips extends StatelessWidget {
  const HorizontalChips({
    super.key,
    required this.values,
  });

  final List values;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
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
      ),
    );
  }
}