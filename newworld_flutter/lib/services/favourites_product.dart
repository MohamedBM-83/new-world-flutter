// Importe shared_preferences pour le stockage persistant des données.
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newworld/models/product.dart';
import 'package:newworld/services/api_service.dart';

/// Favourites utilise le modèle Singleton pour gérer les préférences.
///
/// Permet le stockage et la récupération persistants des préférences utilisateur.
class FavouritesProduct {
  // Instance unique privée de FavouritesProduct pour le modèle Singleton.
  static final FavouritesProduct _instance = FavouritesProduct._internal();

  // Factory constructor retournant l'instance unique.
  factory FavouritesProduct() {
    return _instance;
  }

  // Constructeur privé pour l'initialisation de l'instance Singleton.
  FavouritesProduct._internal();

  // Référence privée à SharedPreferences pour le stockage clé-valeur.
  SharedPreferences? _prefs;

  /// Initialise SharedPreferences. Doit être appelé avant toute opération.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  List<String> list() {
  // Récupération de la liste des films à regarder depuis les SharedPreferences.
  // Si aucune liste n'est stockée, on initialise une liste vide par défaut.
  return _prefs?.getStringList('FavouritesProduct') ?? [];
}

  /// Ajoute un film aux favoris
  addToFavourites(Product product) {
// Récupération de la liste des favoris depuis les SharedPreferences.
// Si aucune liste n'est stockée, on initialise une liste vide par défaut.
    List<String> favourites = _prefs?.getStringList('FavouritesProduct') ?? [];
// On utilise l'id du film comme clé dans le tableau
    final productId = product.id.toString();
// L'identifiant du film est inconnu?
    if (!favourites.contains(productId)) {
  // Ajout du film à la liste
      favourites.add(productId);
      // ApiService().addToCart(user, product);
// Sauvegarde persistante via les préférences
      _prefs?.setStringList('FavouritesProduct', favourites);

    }
  }

  /// Vérifie si un film est dans les favoris
  bool isAFavourite(Product product) {
// Récupération de la liste des favoris depuis les SharedPreferences.
// Si aucune liste n'est stockée, on initialise une liste vide par défaut.
    List<String> favourites = _prefs?.getStringList('FavouritesProduct') ?? [];
// Conversion de l'ID du film en chaîne de caractères.
    final productId = product.id.toString();
// Vérifie si l'identifiant du film est présent dans la liste des favoris.
// Retourne true si l'identifiant est trouvé, sinon false.
    return favourites.contains(productId);
  }

  /// Supprime un film des favoris
  Future<void> removeFromFavourites(Product product) async {
    List<String> favourites = _prefs?.getStringList('FavouritesProduct') ?? [];
    final productId = product.id.toString();

    if (favourites.contains(productId)) {
      favourites.remove(productId);
      await _prefs?.setStringList('FavouritesProduct', favourites);
    }
  }
}
