// Importe shared_preferences pour le stockage persistant des données.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// UserPreferences utilise le modèle Singleton pour gérer les préférences.
///
/// Permet le stockage et la récupération persistants des préférences utilisateur.
class UserPreferences {
  // Instance unique privée de UserPreferences pour le modèle Singleton.
  static final UserPreferences _instance = UserPreferences._internal();

  // Factory constructor retournant l'instance unique.
  factory UserPreferences() {
    return _instance;
  }

  // Constructeur privé pour l'initialisation de l'instance Singleton.
  UserPreferences._internal();

  // Référence privée à SharedPreferences pour le stockage clé-valeur.
  SharedPreferences? _prefs;

  /// Initialise SharedPreferences. Doit être appelé avant toute opération.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Getter pour 'username'. Retourne la valeur ou null si non défini.
  String? get username {
    return _prefs?.getString('username');
  }

  /// Setter pour 'username'. Enregistre la valeur dans SharedPreferences.
  set username(String? value) {
    _prefs?.setString('username', value!);
  }

  /// Getter pour 'netflim_color'. Retourne la valeur ou null si non défini.
  Color get newworldColord {
    // Récupération de la valeur
    int? aColorStr = _prefs?.getInt('netflim_color');

    // Si valeur nulle par défaut on utilise le rouge Netflim
    aColorStr = aColorStr ?? Colors.green.value;

    return Color(aColorStr);
  }

  /// Setter pour 'netflim_color'. Enregistre la valeur dans SharedPreferences.
  set newworldColord(Color value) {
    _prefs?.setInt('netflim_color', value.value);
  }

  /// Getter pour 'background_color'. Retourne la valeur ou null si non défini.
  Color get backgroundColor {
    // Récupération de la valeur
    int? aColorStr = _prefs?.getInt('background_color');

    // Si valeur nulle par défaut on utilise le rouge Netflim
    aColorStr = aColorStr ?? Colors.white.value;

    return Color(aColorStr);
  }

  /// Setter pour 'background_color'. Enregistre la valeur dans SharedPreferences.
  set backgroundColor(Color value) {
    _prefs?.setInt('background_color', value.value);
  }

  /// Getter pour 'main_text_color'. Retourne la valeur ou blanc si non défini.
  Color get   mainTextColor {
    // Récupération de la valeur
    int? aColorStr = _prefs?.getInt('main_text_color');

    // Si valeur nulle par défaut on utilise le rouge Netflim
    aColorStr = aColorStr ?? Colors.black.value;

    return Color(aColorStr);
  }

  /// Setter pour 'background_color'. Enregistre la valeur dans SharedPreferences.
  set mainTextColor(Color value) {
    _prefs?.setInt('main_text_color', value.value);
  }

  /// Getter pour 'secondary_text_color'. Retourne la valeur ou blanc si non défini.
  Color get secondaryTextColor {
    // Récupération de la valeur
    int? aColorStr = _prefs?.getInt('secondary_text_color');

    // Si valeur nulle par défaut on utilise le rouge Netflim
    aColorStr = aColorStr ?? Colors.grey.value;

    return Color(aColorStr);
  }

  /// Setter pour 'secondary_text_color'. Enregistre la valeur dans SharedPreferences.
  set secondaryTextColor(Color value) {
    _prefs?.setInt('secondary_text_color', value.value);
  }

  // Ajoutez ici d'autres getters et setters pour diverses préférences.
}
