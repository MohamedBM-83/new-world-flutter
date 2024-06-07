import 'package:flutter/material.dart';
import 'package:newworld/services/user_preferences.dart';

class NetfilmTheme {
  // Instance unique privée de ListToWatch pour le modèle Singleton.
  static final NetfilmTheme _instance = NetfilmTheme._internal();

  // Factory constructor retournant l'instance unique.
  factory NetfilmTheme() {
    return _instance;
  }

  // Constructeur privé pour l'initialisation de l'instance Singleton.
  NetfilmTheme._internal();

    /// Thème spécifique pour la TabBar
  static ThemeData theme() {
    return ThemeData(
      fontFamily: 'Muli',
      inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: UserPreferences().mainTextColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                style: BorderStyle.solid,
                color: UserPreferences().mainTextColor),
          )),
      primaryColor: UserPreferences().backgroundColor,
      tabBarTheme: TabBarTheme(
        labelColor: UserPreferences().mainTextColor,
        unselectedLabelColor: UserPreferences().mainTextColor.withOpacity(0.7),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: UserPreferences().mainTextColor,
            width: 3.0,
          ),
        ),
      ),
    );
  }
}