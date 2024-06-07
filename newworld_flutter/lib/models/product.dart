import '../services/api.dart';

/// Classe `Product` représente un modèle pour les données de produit.
///
/// Cette classe fournit une structure pour stocker les informations essentielles d'un produit,
/// y compris son identifiant, son nom, sa description, et le chemin de son affiche.
///
/// Usage :
/// Utilisez cette classe pour créer des instances de `Product` avec des données récupérées
/// depuis une API ou une source de données.
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String partner;
  final String quantity;
  final String? image;


  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.partner,
    required this.quantity,
    this.image,
  });

  /// Génère et retourne l'URL complet de l'affiche du produit en préfixant
  /// `posterPath` avec l'URL de base pour les images. Assurez-vous que
  /// `posterPath` n'est pas `null` avant d'invoquer cette méthode.
  String? posterURL() {
    if (image != null) {
      API api = API();
      return api.baseImageUrl + image!;
    } else {
      return null;
    }
  }
}
