import 'package:flutter/material.dart';
import 'package:newworld/services/cart.dart';
import 'package:newworld/services/list_to_buy.dart';
import 'package:newworld/widgets/text_to_speech_button.dart';

import '../models/product.dart';

import '../services/user_preferences.dart';
import '../widgets/movie_actions_menu.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  final VoidCallback onGoBack; // Méthode callback

  const ProductScreen(
      {super.key, required this.product, required this.onGoBack});

  @override
  ProductScreenState createState() => ProductScreenState();
}

/// Widget ProductScreen qui affiche les détails d'un produit
class ProductScreenState extends State<ProductScreen> {
  late Product product;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserPreferences().backgroundColor,
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: UserPreferences().newworldColord,
        foregroundColor: UserPreferences().mainTextColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            // Image du produit
            FadeInImage.assetNetwork(
                placeholder: 'assets/images/placeholder.png',
                image: product.posterURL()!,
                width: double.infinity,
                height: 300,
                fit: BoxFit.fitHeight,
                imageErrorBuilder: (context, error, stackTrace) {
                  // Widget de remplacement en cas d'erreur
                  return Image.asset(
                    'assets/images/placeholder.png',
                    height: 300,
                    fit: BoxFit.fitHeight,
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description du produit
                  Text(
                    "Description",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: UserPreferences().mainTextColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: UserPreferences().mainTextColor),
                  ),
                  TextToSpeechButton(text: product.description),
                  Text(
                    "Prix",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: UserPreferences().mainTextColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${product.price} €",
                    textAlign: TextAlign.justify,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: UserPreferences().mainTextColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--;
                            }
                          });
                        },
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MovieActionsMenu(
        onFavoritePressed: () {
          if (Cart().isInCart(product)) {
            Cart().removeFromCart(product);
          } else {
            Cart().addToCart(product);
          }

          setState(() {});

          widget.onGoBack();
        },
        onAddToListPressed: () {
          // Logique pour ajouter le produit à la liste
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirmer l\'ajout'),
                content: const Text(
                    'Voulez-vous ajouter ce produit à votre liste de souhait ?'),
                actions: <Widget>[
                  TextButton(
                    // Ferme la boîte de dialogue sans rien faire
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Ferme la boîte de dialogue
                      Navigator.of(context).pop();

                      if (ListToBuy().isInList(product)) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: const Text('Ajout impossible'),
                                  content: const Text(
                                      'Le produit est déjà présent dans votre liste de souhait.'),
                                  actions: <Widget>[
                                    TextButton(
                                      // Ferme la boîte de dialogue sans rien faire
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ]);
                            });
                      } else {
                        // Logique pour ajouter le produit à la liste
                        ListToBuy().addToList(product);
                      }
                    },
                    child: const Text('Confirmer'),
                  ),
                ],
              );
            },
          );
        },
        isInCart: Cart().isInCart(product),
      ),
    );
  }
}
