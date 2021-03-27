import 'package:flutter/material.dart';

class MyTheme
{
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xfff5efef),
    shadowColor: Color(0xffbdb8b8),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
      ),
      bodyText1: TextStyle(
        color: Colors.black,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xff37252c),
    shadowColor: Color(0xff442e36),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
      ),
      bodyText1: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}