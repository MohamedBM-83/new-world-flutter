// Importe shared_preferences pour le stockage persistant des données.
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newworld/models/product.dart';
import 'package:newworld/services/api_service.dart';

/// Favourites utilise le modèle Singleton pour gérer les préférences.
///
/// Permet le stockage et la récupération persistants des préférences utilisateur.
class Cart {
  // Instance unique privée de Cart pour le modèle Singleton.
  static final Cart _instance = Cart._internal();

  // Factory constructor retournant l'instance unique.
  factory Cart() {
    return _instance;
  }

  // Constructeur privé pour l'initialisation de l'instance Singleton.
  Cart._internal();

  // Référence privée à SharedPreferences pour le stockage clé-valeur.
  SharedPreferences? _prefs;

  /// Initialise SharedPreferences. Doit être appelé avant toute opération.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  List<String> list() {
  // Récupération de la liste des produitss à regarder depuis les SharedPreferences.
  // Si aucune liste n'est stockée, on initialise une liste vide par défaut.
  return _prefs?.getStringList('Cart') ?? [];
}

  /// Ajoute un produits aux favoris
  addToCart(Product product) {
// Récupération de la liste des favoris depuis les SharedPreferences.
// Si aucune liste n'est stockée, on initialise une liste vide par défaut.
    List<String> cart = _prefs?.getStringList('Cart') ?? [];
// On utilise l'id du produits comme clé dans le tableau
    final productId = product.id.toString();
// L'identifiant du produits est inconnu?
    if (!cart.contains(productId)) {
  // Ajout du produits à la liste
      cart.add(productId);
      // ApiService().addToCart(user, product);
// Sauvegarde persistante via les préférences
      _prefs?.setStringList('Cart', cart);

    }
  }

  /// Vérifie si un produits est dans les favoris
  bool isInCart(Product product) {
// Récupération de la liste des favoris depuis les SharedPreferences.
// Si aucune liste n'est stockée, on initialise une liste vide par défaut.
    List<String> cart = _prefs?.getStringList('Cart') ?? [];
// Conversion de l'ID du produits en chaîne de caractères.
    final productId = product.id.toString();
// Vérifie si l'identifiant du produits est présent dans la liste des favoris.
// Retourne true si l'identifiant est trouvé, sinon false.
    return cart.contains(productId);
  }

  /// Supprime un produits du panier
  Future<void> removeFromCart(Product product) async {
    List<String> cart = _prefs?.getStringList('Cart') ?? [];
    final productId = product.id.toString();

    if (cart.contains(productId)) {
      cart.remove(productId);
      await _prefs?.setStringList('Cart', cart);
    }
  }
  //Vide le panier
  Future<void> clearCart() async {
    await _prefs?.remove('Cart');
  }

  //Calcul le prix total du panier
  Future<double> getTotalPrice() async {
    List<String> cart = _prefs?.getStringList('Cart') ?? [];
    double total = 0;
    for (String productId in cart) {
      Product? product = await ApiService().getProduct(int.parse(productId));
      if (product != null) total += product.price;
    }
    return total;
  }
}
