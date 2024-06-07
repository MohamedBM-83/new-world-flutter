import 'package:flutter/material.dart';
import 'package:newworld/services/api_service.dart';
import 'package:newworld/services/cart.dart';
// import 'package:newworld/services/list_to_watch.dart';
import '../models/product.dart';
import '../screens/product_list_screen.dart';
import '../services/user_preferences.dart';
import 'package:newworld/services/list_to_buy.dart';

// import '../services/favourites.dart';

/// Contrôleur permettant l'affichage des onglets: Accueil, Recherche, Panier,
/// et Liste d'envie.
class AppTabController extends StatefulWidget {
  /// Liste des produits chargés à l'initialisation de l'application
  final List<Product>? _productList;

  /// Constructeur de notre widget
  const AppTabController({
    super.key,
    required List<Product>? ProductList,
  }) : _productList = ProductList;

  /// Surcharge de la gestion d'état
  @override
  _AppTabControllerState createState() => _AppTabControllerState();
}

class _AppTabControllerState extends State<AppTabController>
    with SingleTickerProviderStateMixin {
  late Future<List<Product>?> _productsFuture;
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Ajout de l'écouteur
    _tabController!.addListener(_handleTabSelection);

    // Initialisation de la liste de produits par défaut
    _productsFuture = loadProducts();
  }

  void _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        _productsFuture = loadProducts();
      });
    }
  }

  // Construction du contexte
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Ignore l'action de retour
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(child: Text('New World')),
          backgroundColor: UserPreferences().newworldColord,
          foregroundColor: UserPreferences().mainTextColor,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.home), text: 'Accueil'),
              Tab(icon: Icon(Icons.shopping_bag), text: 'Panier'),
              Tab(icon: Icon(Icons.person), text: 'Mon Compte'),
            ],
            labelStyle: const TextStyle(fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Container(
              color: UserPreferences().backgroundColor,
              child: Center(
                child: ProductListScreen(
                    title: "Nos Produits", products: widget._productList!),
              ),
            ),
            FutureBuilder<List<Product>?>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      color: UserPreferences().backgroundColor,
                      child: Center(
                          child: CircularProgressIndicator(
                              color: UserPreferences().newworldColord)));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else {
                  return ProductListScreen(
                      title: "Votre Panier", products: snapshot.data ?? []);
                }
              },
            ),
            FutureBuilder<List<Product>?>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      color: UserPreferences().backgroundColor,
                      child: Center(
                          child: CircularProgressIndicator(
                              color: UserPreferences().newworldColord)));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else {
                  return ProductListScreen(
                      title: "Votre Compte", products: snapshot.data ?? []);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Méthode asynchrone chargeant la liste de produits à afficher
  Future<List<Product>?> loadProducts() async {
    switch (_tabController!.index) {
// Favoris
      case 1:
        // Récupérer la liste des identifiants
        List<String> productIds = Cart().list();
// Créer une liste vide pour stocker les produits
        List<Product> products = [];
// Boucler sur chaque identifiant pour récupérer les produits correspondants
        for (String productId in productIds) {
// Appeler l'API pour chaque produit et attendre le résultat
          Product? product =
              await ApiService().getProduct(int.parse(productId));
// Ajouter le produits à la liste des produitss
          if (product != null) products.add(product);
        }
// Retourner la liste complète des produits
        return products;
// A regarder
      case 2:
// Récupérer la liste des identifiants
        List<String> productIds = ListToBuy().list();
// Créer une liste vide pour stocker les produits
        List<Product> products = [];
// Boucler sur chaque identifiant pour récupérer les produits correspondants
        for (String productId in productIds) {
// Appeler l'API pour chaque produits et attendre le résultat
          Product? product =
              await ApiService().getProduct(int.parse(productId));
// Ajouter le produit à la liste des produits
          if (product != null) products.add(product);
        }
// Retourner la liste complète des produits
        return products;

      default:
        return [];
    }
  }
}
