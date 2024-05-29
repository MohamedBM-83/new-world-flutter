import 'package:flutter/material.dart';
import 'package:netflim/services/favourites.dart';
import 'package:netflim/widgets/movie_search_bar.dart';

import '../models/movie.dart';
import '../services/api_service.dart';
import '../services/user_preferences.dart';
import 'movie_screen.dart';

class MovieListScreen extends StatefulWidget {
  final String title;
  final List<Movie> movies;
  final bool displaySearchBar;

  const MovieListScreen(
      {super.key,
      required this.movies,
      required this.title,
      this.displaySearchBar = true});

  @override
  MovieListScreenState createState() => MovieListScreenState();
}

class MovieListScreenState extends State<MovieListScreen> {
  late String title;
  late List<Movie> movies;

  @override
  void initState() {
    super.initState();
    movies = widget.movies;
    title = widget.title;
  }

  void showSearchDialog(BuildContext context) async {
    final searchText = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recherche'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
                hintText: 'Entrez un texte de recherche...'),
            onSubmitted: (value) {
              Navigator.of(context).pop(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog without returning text
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );

    if (searchText != null && searchText.isNotEmpty) {
      title = "Votre Recherche";

      // Appel de l'api pour la recherche de films par titre
      movies = await ApiService().searchForMovies(1, searchText);
    } else {
      title = "Films Populaires";

      // Appel de l'api pour la recherche des films populaires
      movies = await ApiService().getPopularMovies(1);
    }

    // Mise à jour de l'UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserPreferences().backgroundColor,
      /*appBar: AppBar(
        title: const Text('NetFlim'),
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
          widget.displaySearchBar == true
              ? MovieSearchBar(onQueryChanged: (String search) async {
                  if (search != null && search.isNotEmpty) {
                    title = "Votre Recherche";

                    // Appel de l'api pour la recherche de films par titre
                    movies = await ApiService().searchForMovies(1, search);
                  } else {
                    title = "Films Populaires";

                    // Appel de l'api pour la recherche des films populaires
                    movies = await ApiService().getPopularMovies(1);
                  }

                  // Mise à jour de l'UI
                  setState(() {});
                })
              : const SizedBox.shrink(),
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  leading: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/placeholder.png',
                      image: movie.posterURL()!,
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
                    movie.name,
                    style: TextStyle(color: UserPreferences().mainTextColor),
                  ),
                  subtitle: Text(
                    'Plus de détails...',
                    style:
                        TextStyle(color: UserPreferences().secondaryTextColor),
                  ),
                  onTap: () {
                    // Navigue vers le MovieScreen avec les détails du film
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieScreen(
                          movie: movie,
                          onGoBack: () => setState(() {}),
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(
                      Favourites().isAFavourite(movie)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      if (Favourites().isAFavourite(movie)) {
                        // Si le film est déjà un favori, le retirer
                        Favourites().removeFromFavourites(movie);
                      } else {
                        // Sinon, ajouter le film aux favoris
                        Favourites().addToFavourites(movie);
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
    );
  }
}
