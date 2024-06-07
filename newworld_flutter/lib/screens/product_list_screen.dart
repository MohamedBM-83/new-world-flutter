import 'package:flutter/material.dart';
import 'package:newworld/services/cart.dart';
import 'package:newworld/widgets/product_search_bar.dart';
import 'package:newworld/widgets/checkout_bar.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../services/user_preferences.dart';
import 'product_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String title;
  final List<Product> products;

  const ProductListScreen({
    super.key,
    required this.products,
    required this.title,
  });

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  late String title;
  late List<Product> products;
  bool displaySearchBar = false;
  bool displaycheckoutBar = false;

  @override
  void initState() {
    super.initState();
    products = widget.products;
    title = widget.title;
    if (widget.title == "Nos Produits") {
      displaySearchBar = true;
    }
    if (widget.title == "Votre Panier") {
      displaycheckoutBar = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UserPreferences().backgroundColor,
        /*appBar: AppBar(
        title: const Text('newworld'),
        backgroundColor: UserPreferences().newworldColord,
        foregroundColor: UserPreferences().mainTextColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Affiche la boîte de dialogue de recherche
              showSearchDialog(context);
            },
          ),
        ],
      ),*/
        body: Column(
          children: [
            title != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        color: UserPreferences().mainTextColor,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            displaySearchBar == true
                ? ProductSearchBar(onQueryChanged: (String search) async {
                    if (search.isNotEmpty) {
                      title = "Votre Recherche";

                      // Appel de l'api pour la recherche de produits par titre
                      products = await ApiService().searchForProducts(search);
                    } else {
                      title = "Nos Produits";

                      // Appel de l'api pour la recherche des produits
                      products = await ApiService().getProducts(1);
                    }

                    // Mise à jour de l'UI
                    setState(() {});
                  })
                : const SizedBox.shrink(),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    leading: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder.png',
                        image: product.posterURL()!,
                        width: 50,
                        height: 100,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          // Widget de remplacement en cas d'erreur
                          return Image.asset(
                            'assets/images/placeholder.png',
                            height: 300,
                            fit: BoxFit.fitHeight,
                          );
                        }),
                    title: Text(
                      product.name,
                      style: TextStyle(color: UserPreferences().mainTextColor),
                    ),
                    subtitle: Text(
                      'Plus de détails...',
                      style: TextStyle(
                          color: UserPreferences().secondaryTextColor),
                    ),
                    onTap: () {
                      // Navigue vers le ProductScreen avec les détails du produit
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(
                            product: product,
                            onGoBack: () => setState(() {}),
                          ),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(
                        Cart().isInCart(product)
                            ? Icons.shopping_bag
                            : Icons.shopping_bag_outlined,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        if (Cart().isInCart(product)) {
                          // Si le produit est déjà un favori, le retirer
                          Cart().removeFromCart(product);
                        } else {
                          // Sinon, ajouter le produit aux favoris
                          Cart().addToCart(product);
                        }

                        setState(() {});
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: displaycheckoutBar ? CheckoutBar() : null);
  }
}
