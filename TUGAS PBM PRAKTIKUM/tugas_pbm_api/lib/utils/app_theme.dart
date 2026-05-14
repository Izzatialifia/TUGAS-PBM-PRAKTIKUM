import 'package:flutter/material.dart';

class AppTheme {
  static const Color gold = Color(0xFFD4AF37);
  static const Color black = Color(0xFF121212);
  static const Color white = Colors.white;

  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: black,

    appBarTheme: const AppBarTheme(
      backgroundColor: black,
      elevation: 0,
      centerTitle: true,
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: gold,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade900,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    ),
  );
}