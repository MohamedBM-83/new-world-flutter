// Importe shared_preferences pour le stockage persistant des données.
import 'package:flutter/material.dart';
import 'package:netflim/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ListToWatch utilise le modèle Singleton pour gérer les préférences.
///
/// Permet le stockage et la récupération persistants des préférences utilisateur.
class ListToWatch {
  // Instance unique privée de ListToWatch pour le modèle Singleton.
  static final ListToWatch _instance = ListToWatch._internal();

  // Factory constructor retournant l'instance unique.
  factory ListToWatch() {
    return _instance;
  }

  // Constructeur privé pour l'initialisation de l'instance Singleton.
  ListToWatch._internal();

  // Référence privée à SharedPreferences pour le stockage clé-valeur.
  SharedPreferences? _prefs;

  /// Initialise SharedPreferences. Doit être appelé avant toute opération.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Récupère la liste des films favoris
  addToList(Movie movie) async {
    // Récupération de la liste des favoris depuis les SharedPreferences.
    // Si aucune liste n'est stockée, on initialise une liste vide par défaut.
    List<String> listToWatch = _prefs?.getStringList('l') ?? [];
    
    // On utilise l'id du film comme clé dans le tableau
    final movieId = movie.id.toString();
    
    // L'identifiant du film est inconnu?
    if (!listToWatch.contains(movieId)) {
      // Ajout du film à la liste
        listToWatch.add(movieId);
      
      // Sauvegarde persistante via les préférences
        _prefs?.setStringList('ListToWatch', listToWatch);
    }
  }

  /// Supprime un film des favoris
  removeFromList(Movie movie) async {
    // Récupération de la liste des favoris depuis les SharedPreferences.
    // Si aucune liste n'est stockée, on initialise une liste vide par défaut.
    List<String> listToWatch = _prefs?.getStringList('ListToWatch') ?? [];
    
    // Conversion de l'ID du film en chaîne de caractères.
    final movieId = movie.id.toString();
    
    // L'identifiant du film est connu?
    if (listToWatch.contains(movieId)) {
      // Suppression du film de la liste
        listToWatch.remove(movieId);
      
      // Sauvegarde persistante via les préférences
        _prefs?.setStringList('ListToWatch', listToWatch);
    }
  }

  /// Vérifie si un film est dans les favoris
  bool isInList(Movie movie) {
    // Récupération de la liste des favoris depuis les SharedPreferences.
    // Si aucune liste n'est stockée, on initialise une liste vide par défaut.
    List<String> listToWatch = _prefs?.getStringList('ListToWatch') ?? [];
    
    // Conversion de l'ID du film en chaîne de caractères.
    final movieId = movie.id.toString();
    
    // Vérifie si l'identifiant du film est présent dans la liste des favoris.
    // Retourne true si l'identifiant est trouvé, sinon false.
    return listToWatch.contains(movieId);
  }

  /// Récupère la liste des films à regarder
  List<String> list() {
    // Récupération de la liste des favoris depuis les SharedPreferences.
    // Si aucune liste n'est stockée, on initialise une liste vide par défaut.
    List<String> listToWatch = _prefs?.getStringList('ListToWatch') ?? [];
    
    // Conversion de la liste d'identifiants en liste de films
    return listToWatch;
  }
}
