import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyColor {
  static const blue = Color.fromARGB(255, 28, 107, 172);
  static const green = Color.fromARGB(255, 65, 154, 160);
  static const yellow = Color.fromARGB(255, 239, 235, 198);
  static const red = Color.fromARGB(255, 174, 104, 92);
  static const dark = Color(0xFF4F4E4E);
  static const grey = Color(0xFFBCB6B6);
  static const lightGrey = Color(0xFFD9D9D9);
  static const white = Color(0xFFFFFFFF);
}

class Themes {
  static final light = ThemeData(
    fontFamily: 'Noto_Sans_JP',
    colorScheme: const ColorScheme.light(
      background: MyColor.lightGrey,
    ),
  );
  static final dark = ThemeData(
    fontFamily: 'Noto_Sans_JP',
    colorScheme: const ColorScheme.dark(
      background: MyColor.dark,
    ),
  );
}

class MyTextStyle {
  static const heading = TextStyle(fontSize: 32, fontWeight: FontWeight.w900);
  static const medium = TextStyle(fontSize: 24, fontWeight: FontWeight.w400);
  static const main = TextStyle(fontSize: 16, fontWeight: FontWeight.w300);
}
