import 'package:flutter/material.dart' show Color;

class Course {
  final String title, description, iconSrc,image;
  final Color color;

  Course({
    required this.title,
    this.description = '',
    this.image='medicine',
    this.iconSrc = "assets/icons/ios.svg",
    this.color = const Color(0xFF1713DB),
  });
}

final List<Course> courses = [
  Course(
    title: "Order Medicines by Prescription ",
    description: "Upload your prescription and get your medicines at your home seamlessly. You can use your rewards coins to order medicines."
  ),
  Course(
    title: "Book Appointment @ 20% off",
    iconSrc: "assets/icons/code.svg",
    image: 'hospital',
    description: "Book Your Appointment to our partner Hospitals and get up to 20% discount",
    color: const Color(0xFF007AEB),
  ),
  Course(
      title: "Get Exclusive Health Insurance offers @ 299Rs",
      description: "Based on your profile, you'll get exciting offers from our partner companies.",
      image: 'health'
  )
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
