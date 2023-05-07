import 'package:flutter/material.dart' show Color;

class Course {
  final String title, description, iconSrc;
  final Color color;

  Course({
    required this.title,
    this.description = '',
    this.iconSrc = "assets/icons/ios.svg",
    this.color = const Color(0xFF7553F6),
  });
}

final List<Course> courses = [
  Course(
    title: "Order Medicines by Prescription ",
    description: "Upload your prescription and get your required medicines at your home seamlessly .."
  ),
  Course(
    title: "Book Appointment",
    iconSrc: "assets/icons/code.svg",
    description: "Book Your Appointment to Appolo Hospital at 20% discount",
    color: const Color(0xFF80A4FF),
  ),
];

final List<Course> recentCourses = [
  Course(
    title: "New Chat",
    iconSrc: "assets/icons/code.svg",
  ),
  Course(
      title: "Order Medicine",
      color: const Color(0xFF9CC5FF),
  ),
  Course(
    title: "Book Appointment",
    iconSrc: "assets/icons/code.svg",
  ),
];
