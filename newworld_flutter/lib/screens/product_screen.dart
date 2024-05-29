import 'package:flutter/material.dart';
import 'package:netflim/services/favourites_product.dart';
import 'package:netflim/services/list_to_buy.dart';
import 'package:netflim/widgets/text_to_speech_button.dart';

import '../models/product.dart';

import '../services/user_preferences.dart';
import '../widgets/movie_actions_menu.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  final VoidCallback onGoBack; // Méthode callback

  const ProductScreen({super.key, required this.product, required this.onGoBack});

  @override
  ProductScreenState createState() => ProductScreenState();
}

/// Widget ProductScreen qui affiche les détails d'un film
class ProductScreenState extends State<ProductScreen> {
  late Product product;

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
            // Affiche du produit
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
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MovieActionsMenu(
        onFavoritePressed: () {
          if (FavouritesProduct().isAFavourite(product)) {
            FavouritesProduct().removeFromFavourites(product);
          } else {
            FavouritesProduct().addToFavourites(product);
          }

          setState(() {});

          widget.onGoBack();
        },
        onAddToListPressed: () {
          // Logique pour ajouter le film à la liste
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirmer l\'ajout'),
                content: const Text(
                    'Voulez-vous ajouter ce film à votre liste à regarder ?'),
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
                                  'Le film est déjà présent dans votre liste à regarder'),
                              actions: <Widget>[
                                TextButton(
                                  // Ferme la boîte de dialogue sans rien faire
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Ok'),
                                ),
                              ]
                            );
                          }
                        );
                      } else {
                        // Logique pour ajouter le film à la liste
                        ListToBuy().addToList(product);
                        print('Ajouté à la liste');
                      }
                    },
                    child: const Text('Confirmer'),
                  ),
                ],
              );
            },
          );
        },
        isAFavourite: FavouritesProduct().isAFavourite(product),
      ),
    );
  }
}
