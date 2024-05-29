// Importe shared_preferences pour le stockage persistant des données.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:netflim/models/movie.dart';

/// Favourites utilise le modèle Singleton pour gérer les préférences.
///
/// Permet le stockage et la récupération persistants des préférences utilisateur.
class Favourites {
  // Instance unique privée de Favourites pour le modèle Singleton.
  static final Favourites _instance = Favourites._internal();

  // Factory constructor retournant l'instance unique.
  factory Favourites() {
    return _instance;
  }

  // Constructeur privé pour l'initialisation de l'instance Singleton.
  Favourites._internal();

  // Référence privée à SharedPreferences pour le stockage clé-valeur.
  SharedPreferences? _prefs;

  /// Initialise SharedPreferences. Doit être appelé avant toute opération.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  List<String> list() {
  // Récupération de la liste des films à regarder depuis les SharedPreferences.
  // Si aucune liste n'est stockée, on initialise une liste vide par défaut.
  return _prefs?.getStringList('Favourites') ?? [];
}

  /// Ajoute un film aux favoris
  addToFavourites(Movie movie) {
// Récupération de la liste des favoris depuis les SharedPreferences.
// Si aucune liste n'est stockée, on initialise une liste vide par défaut.
    List<String> favourites = _prefs?.getStringList('Favourites') ?? [];
// On utilise l'id du film comme clé dans le tableau
    final movieId = movie.id.toString();
// L'identifiant du film est inconnu?
    if (!favourites.contains(movieId)) {
// Ajout du film à la liste
      favourites.add(movieId);
// Sauvegarde persistante via les préférences
      _prefs?.setStringList('Favourites', favourites);
    }
  }

  /// Vérifie si un film est dans les favoris
  bool isAFavourite(Movie movie) {
// Récupération de la liste des favoris depuis les SharedPreferences.
// Si aucune liste n'est stockée, on initialise une liste vide par défaut.
    List<String> favourites = _prefs?.getStringList('Favourites') ?? [];
// Conversion de l'ID du film en chaîne de caractères.
    final movieId = movie.id.toString();
// Vérifie si l'identifiant du film est présent dans la liste des favoris.
// Retourne true si l'identifiant est trouvé, sinon false.
    return favourites.contains(movieId);
  }

  /// Supprime un film des favoris
  Future<void> removeFromFavourites(Movie movie) async {
    List<String> favourites = _prefs?.getStringList('Favourites') ?? [];
    final movieId = movie.id.toString();

    if (favourites.contains(movieId)) {
      favourites.remove(movieId);
      await _prefs?.setStringList('Favourites', favourites);
    }
  }
}
