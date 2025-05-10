import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get appTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: LightColors.secondary,
        scaffoldBackgroundColor: LightColors.background,
        fontFamily: 'Poppins',
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: LightColors.primary,
        ),
        iconTheme: new IconThemeData(color: LightColors.icon),
        dividerColor: LightColors.diff3,
        shadowColor: LightColors.shadow,
        textTheme: TextTheme(
        ));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: DarkColors.secondary,
        scaffoldBackgroundColor: DarkColors.primary,
        fontFamily: 'Poppins',
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: DarkColors.primary,
        ),
        iconTheme: new IconThemeData(color: DarkColors.icon),
        dividerColor: DarkColors.diff3,
        shadowColor: DarkColors.shadow,
        textTheme: TextTheme(
        ));
  }
}
