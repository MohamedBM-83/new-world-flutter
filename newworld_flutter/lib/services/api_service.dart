import 'package:dio/dio.dart';
import '../models/movie.dart';
import '../models/product.dart';
import 'api.dart';

/// Classe `ApiService` gère les requêtes réseau pour récupérer des données de
/// films depuis une API externe.
///
/// Cette classe utilise la bibliothèque Dio pour effectuer des requêtes HTTP.
/// Elle est conçue pour interroger une API spécifique de films et récupérer des
/// informations telles que les films populaires.
///
/// Usage :
/// Pour utiliser `ApiService`, créez une instance de la classe, puis invoquez
/// les méthodes fournies pour récupérer les données souhaitées.
class ApiService {
  final API api = API();
  final Dio dio = Dio();

  /// Récupère les données depuis l'API en utilisant un chemin spécifié et des
  /// paramètres optionnels.
  ///
  /// [path] Le chemin de la ressource API à laquelle accéder.
  /// [params] Paramètres optionnels à inclure dans la requête.
  ///
  /// Retourne une réponse Dio si la requête aboutit avec un code de statut 200.
  /// Sinon, lève une exception contenant la réponse de la requête.
  Future<Response> getData(String path, {Map<String, dynamic>? params}) async {
    // Construction de l'URL complète
    String url = api.baseUrl + path;

    // Ajout des paramètres de requête par défaut et ceux fournis

    // Lancement de la requète
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw response;
    }
  }

  /// Récupère une liste des films populaires à partir de l'API.
  ///
  /// [pageNumber] Le numéro de la page à récupérer pour la pagination des résultats.
  ///
  /// Retourne une liste d'objets `Movie` si la requête est réussie.
  /// Sinon, lève une exception contenant la réponse de la requête.
  Future<List<Movie>> getPopularMovies(int pageNumber) async {
    Response response = await getData("/movie/popular", params: {
      'page': pageNumber,
    });

    if (response.statusCode == 200) {
      Map data = response.data;

      List<dynamic> results = data["results"];
      List<Movie> movies = [];

      for (Map<String, dynamic> json in results) {
        // Transformation du JSON en objet Movie
        Movie movie = Movie(
            id: json['id'] as int,
            name: json['title'] as String,
            description: json['overview'] as String,
            posterPath: json['poster_path'] ?? '');

        movies.add(movie);
      }

      return movies;
    } else {
      throw response;
    }
  }

  /// Récupère une liste des films sur un criète de recherge à partir de l'API.
  ///
  /// [pageNumber] Le numéro de la page à récupérer pour la pagination des résultats.
  ///
  /// Retourne une liste d'objets `Movie` si la requête est réussie.
  /// Sinon, lève une exception contenant la réponse de la requête.
  Future<List<Movie>> searchForMovies(
      int pageNumber, String searchString) async {
    Response response = await getData("/search/movie",
        params: {'page': pageNumber, 'query': searchString});

    if (response.statusCode == 200) {
      Map data = response.data;

      List<dynamic> results = data["results"];
      List<Movie> movies = [];

      for (Map<String, dynamic> json in results) {
        // Transformation du JSON en objet Movie
        Movie movie = Movie(
            id: json['id'] as int,
            name: json['title'] as String,
            description: json['overview'] as String,
            posterPath: json['poster_path'] ?? '');

        movies.add(movie);
      }

      return movies;
    } else {
      throw response;
    }
  }

  /// Récupère le détail d'un film sur la base de son identifiant.
  ///
  /// Retourne un objet `Movie` si la requête est réussie.
  /// Sinon, lève une exception contenant la réponse de la requête.
  Future<Movie?> getMovie(int movieId) async {
    Response response = await getData("/movie/$movieId");

    if (response.statusCode == 200) {
      Map<String, dynamic> json = response.data;

      print(json.toString());

      // Transformation du JSON en objet Movie
      Movie movie = Movie(
          id: json['id'] as int,
          name: json['title'] as String,
          description: json['overview'] as String,
          posterPath: json['poster_path'] ?? '');

      return movie;
    } else {
      throw response;
    }
  }

  Future<List<Product>> getProducts(int pageNumber) async {
    Response response = await getData("/products", params: {
      'page': pageNumber,
    });
    if (response.data == null) {
      return [];
    }

    if (response.statusCode == 200) {
      Map data = response.data;

      List<dynamic> results = data["hydra:member"];
      List<Product> products = [];

      for (Map<String, dynamic> json in results) {
        // Transformation du JSON en objet Movie
        Product product = Product(
            id: json['id'] as int,
            name: json['name'] as String,
            description: json['description'] as String,
            price: json['price'] as double,
            partner: json['partner'] as String,
            quantity: json['quantity'] as String,
            image: json['image']);

        products.add(product);
      }

      return products;
    } else {
      throw response;
    }
  }

  Future<Product?> getProduct(int productId) async {
    Response response = await getData("/products/$productId");

    if (response.statusCode == 200) {
      Map<String, dynamic> json = response.data;

      print(json.toString());

      // Transformation du JSON en objet Movie
      Product product = Product(
          id: json['id'] as int,
          name: json['name'] as String,
          description: json['description'] as String,
          price: json['price'] as double,
          partner: json['partner'] as String,
          quantity: json['quantity'] as String,
          image: json['image']);

      return product;
    } else {
      throw response;
    }
  }

  Future<List<Product>> searchForProducts(
      int pageNumber, String searchString) async {
    Response response = await getData("/search/products",
        params: {'page': pageNumber, 'query': searchString});

    if (response.statusCode == 200) {
      Map data = response.data;

      List<dynamic> results = data["hydra:member"];
      List<Product> products = [];

      for (Map<String, dynamic> json in results) {
        // Transformation du JSON en objet Movie
        Product product = Product(
            id: json['id'] as int,
            name: json['name'] as String,
            description: json['description'] as String,
            price: json['price'] as double,
            partner: json['partner'] as String,
            quantity: json['quantity'] as String,
            image: json['image']);

        products.add(product);
      }

      return products;
    } else {
      throw response;
    }
  }

}
