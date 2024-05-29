import 'package:flutter/material.dart';
import 'package:netflim/services/favourites.dart';
import 'package:netflim/services/list_to_watch.dart';
import 'package:netflim/widgets/text_to_speech_button.dart';

import '../models/movie.dart';

import '../services/user_preferences.dart';
import '../widgets/movie_actions_menu.dart';

class MovieScreen extends StatefulWidget {
  final Movie movie;
  final VoidCallback onGoBack; // Méthode callback

  const MovieScreen({super.key, required this.movie, required this.onGoBack});

  @override
  MovieScreenState createState() => MovieScreenState();
}

/// Widget MovieScreen qui affiche les détails d'un film
class MovieScreenState extends State<MovieScreen> {
  late Movie movie;

  @override
  void initState() {
    super.initState();
    movie = widget.movie;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserPreferences().backgroundColor,
      appBar: AppBar(
        title: Text(movie.name),
        backgroundColor: UserPreferences().newworldColord,
        foregroundColor: UserPreferences().mainTextColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            // Affiche du film
            FadeInImage.assetNetwork(
                placeholder: 'assets/images/placeholder.png',
                image: movie.posterURL()!,
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
                  // Synopsis du film
                  Text(
                    "Synopsis",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: UserPreferences().mainTextColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.description,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: UserPreferences().mainTextColor),
                  ),
                  TextToSpeechButton(text: movie.description),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MovieActionsMenu(
        onFavoritePressed: () {
          if (Favourites().isAFavourite(movie)) {
            Favourites().removeFromFavourites(movie);
          } else {
            Favourites().addToFavourites(movie);
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
                      
                      if (ListToWatch().isInList(movie)) {
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
                        ListToWatch().addToList(movie);
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
        isAFavourite: Favourites().isAFavourite(movie),
      ),
    );
  }
}
