import 'package:flutter/material.dart';
import 'package:netflim/services/user_preferences.dart';

class MovieActionsMenu extends StatelessWidget {
  // Callbacks pour les actions des boutons
  final VoidCallback onFavoritePressed;
  final VoidCallback onAddToListPressed;
  final bool isAFavourite;

  const MovieActionsMenu({
    super.key,
    required this.onFavoritePressed,
    required this.onAddToListPressed,
    required this.isAFavourite,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: UserPreferences().newworldColord,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Bouton Coup de coeur
          IconButton(
            icon: Icon(
              isAFavourite ? Icons.favorite : Icons.favorite_border,
              color: UserPreferences().mainTextColor),
            onPressed: onFavoritePressed,
          ),
          // Bouton Ajouter à votre liste
          IconButton(
            icon: Icon(Icons.playlist_add,
                color: UserPreferences().mainTextColor),
            onPressed: onAddToListPressed,
          ),
        ],
      ),
    );
  }
}
