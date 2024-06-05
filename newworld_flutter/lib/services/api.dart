import 'api_key.dart';

/// Classe `API` centralise la configuration nécessaire pour accéder à l'API de The Movie Database (TMDB).
///
/// Cette classe contient la clé API, l'URL de base de l'API, et l'URL de base pour accéder aux images.
/// Elle est utilisée pour construire les requêtes vers l'API de TMDB et récupérer des informations
/// sur les films, les affiches de films, etc.
///
/// Utilisation :
/// - `apikey` est utilisée pour s'authentifier auprès de l'API TMDB.
/// - `baseUrl` sert de point de départ pour toutes les requêtes API vers TMDB.
/// - `baseImageUrl` est utilisé pour construire les URL complets des images de films, telles que les affiches.
///
/// Important :
/// La clé API doit être tenue secrète et ne pas être exposée publiquement, par exemple, dans des dépôts de code source ouverts.
/// Assurez-vous de suivre les meilleures pratiques pour sécuriser votre clé API.
class API {
  /// La clé API pour accéder à l'API de TMDB. Stockée dans un fichier séparé pour la sécurité.
  final String apikey = APIKey.apikey;

  /// L'URL de base pour les requêtes API vers TMDB.
  final String baseUrl = 'http://127.0.0.1:8000/api';

  /// L'URL de base pour accéder aux images sur TMDB, permettant de construire des URL d'images pour les films.
  final String baseImageUrl = 'http://127.0.0.1:8000/images/';
}
