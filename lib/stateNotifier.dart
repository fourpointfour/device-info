import 'package:flutter/material.dart';

class AppStateNotifier extends ChangeNotifier
{
  bool isDark = false;

  ThemeMode currentTheme()
  {
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void updateTheme(bool isDarkModeOn)
  {
    this.isDark = isDarkModeOn;
    notifyListeners();
  }
}