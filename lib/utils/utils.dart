import 'package:flutter/material.dart';

class Utils {
  static const double screenPadding = 10.0;
  static const double ticketWidth = 270;
  static const double ticketHeight = 120;
  static const List<DropdownMenuItem<String>> statusItems = [
    DropdownMenuItem(
      value: "To Do",
      child: Text("To Do"),
    ),
    DropdownMenuItem(
      value: "In Progress",
      child: Text("In Progress"),
    ),
    DropdownMenuItem(
      value: "Done",
      child: Text("Done"),
    )
  ];
}