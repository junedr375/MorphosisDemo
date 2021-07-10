import 'package:flutter/material.dart';

ThemeData appLightThemeData() {
  return ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Colors.black)),
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    textTheme: TextTheme(
      headline1: TextStyle(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
      headline3: TextStyle(
          color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
      bodyText1: TextStyle(
          color: Colors.grey[700], fontSize: 14, fontWeight: FontWeight.w500),
    ),
  );
}

ThemeData appDarkThemeData() {
  return ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        actionsIconTheme: IconThemeData(color: Colors.white)),
    scaffoldBackgroundColor: Colors.grey[900],
    backgroundColor: Colors.grey[900],
    textTheme: TextTheme(
      headline1: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
      headline3: TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      bodyText1: TextStyle(
          color: Colors.grey[200], fontSize: 14, fontWeight: FontWeight.w500),
    ),
  );
}

ThemeData getThemeData(BuildContext context) {
  return Theme.of(context);
}
