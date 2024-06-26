// Importe shared_preferences pour le stockage persistant des données.
import 'package:newworld/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ListToBuy utilise le modèle Singleton pour gérer les préférences.
///
/// Permet le stockage et la récupération persistants des préférences utilisateur.
class ListToBuy {
  // Instance unique privée de ListToBuy pour le modèle Singleton.
  static final ListToBuy _instance = ListToBuy._internal();

  // Factory constructor retournant l'instance unique.
  factory ListToBuy() {
    return _instance;
  }

  // Constructeur privé pour l'initialisation de l'instance Singleton.
  ListToBuy._internal();

  // Référence privée à SharedPreferences pour le stockage clé-valeur.
  SharedPreferences? _prefs;

  /// Initialise SharedPreferences. Doit être appelé avant toute opération.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Récupère la liste des produits favoris
  addToList(Product product) async {
    // Récupération de la liste des favoris depuis les SharedPreferences.
    // Si aucune liste n'est stockée, on initialise une liste vide par défaut.
    List<String> ListToBuy = _prefs?.getStringList('l') ?? [];
    
    // On utilise l'id du produit comme clé dans le tableau
    final productId = product.id.toString();
    
    // L'identifiant du produit est inconnu?
    if (!ListToBuy.contains(productId)) {
      // Ajout du produit à la liste
        ListToBuy.add(productId);
      
      // Sauvegarde persistante via les préférences
        _prefs?.setStringList('ListToBuy', ListToBuy);
    }
  }

  /// Supprime un produit des favoris
  removeFromList(Product product) async {
    // Récupération de la liste des favoris depuis les SharedPreferences.
    // Si aucune liste n'est stockée, on initialise une liste vide par défaut.
    List<String> ListToBuy = _prefs?.getStringList('ListToBuy') ?? [];
    
    // Conversion de l'ID du produit en chaîne de caractères.
    final productId = product.id.toString();
    
    // L'identifiant du produit est connu?
    if (ListToBuy.contains(productId)) {
      // Suppression du produit de la liste
        ListToBuy.remove(productId);
      
      // Sauvegarde persistante via les préférences
        _prefs?.setStringList('ListToBuy', ListToBuy);
    }
  }

  /// Vérifie si un produit est dans les favoris
  bool isInList(Product product) {
    // Récupération de la liste des favoris depuis les SharedPreferences.
    // Si aucune liste n'est stockée, on initialise une liste vide par défaut.
    List<String> ListToBuy = _prefs?.getStringList('ListToBuy') ?? [];
    
    // Conversion de l'ID du produit en chaîne de caractères.
    final movieId = product.id.toString();
    
    // Vérifie si l'identifiant du produit est présent dans la liste des favoris.
    // Retourne true si l'identifiant est trouvé, sinon false.
    return ListToBuy.contains(movieId);
  }

  /// Récupère la liste des produits à regarder
  List<String> list() {
    // Récupération de la liste des favoris depuis les SharedPreferences.
    // Si aucune liste n'est stockée, on initialise une liste vide par défaut.
    List<String> ListToBuy = _prefs?.getStringList('ListToBuy') ?? [];
    
    // Conversion de la liste d'identifiants en liste de produits
    return ListToBuy;
  }
}
