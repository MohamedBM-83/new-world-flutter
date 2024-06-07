import 'package:dio/dio.dart';
import 'package:newworld/services/user_preferences.dart';
import '../models/product.dart';
import 'package:newworld/models/user.dart';
import 'api.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Classe `ApiService` gère les requêtes réseau pour récupérer des données de
/// produits depuis une API externe.
///
/// Cette classe utilise la bibliothèque Dio pour effectuer des requêtes HTTP.
/// Elle est conçue pour interroger une API spécifique de produits et récupérer des
/// informations telles que les produits populaires.
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    // Construction de l'URL complète
    String url = api.baseUrl + path;

    // Ajout des paramètres de requête par défaut et ceux fournis

    // Lancement de la requète
    final response = await dio.get(url);
    // final response = await dio.get(url, queryParameters: params, options: Options(
    //   headers: {
    //     'Authorization': 'Bearer $token',
    //     'Content-Type': 'application/json',
    //     },
    // ));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw response;
    }
  }

  Future<bool> authenticate(String email, String password) async {
    final response = await dio.post(
      'http://localhost:8000/api/login_check',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'username': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.data['token']);

      final response2 = await dio.get('http://localhost:8000/api/users?email=$email');
      if (response2.statusCode == 200) {
        List<dynamic> results = response2.data["hydra:member"];
        int userId = results[0]['id'];
        await prefs.setInt('userId', userId);
      }
        return true;
      } else {
        return false;
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

      // Transformation du JSON en objet Movie
      Product product = Product(
          id: json['id'] as int,
          name: json['name'] as String,
          description: json['description'] as String,
          price: json['price'] as double,
          partner: json['partner'] as String,
          quantity: json['quantity'] as String,
          image: json['image'] as String);

      return product;
    } else {
      throw response;
    }
  }

  Future<List<Product>> searchForProducts(String searchString) async {
    Response response = await getData("/products?name=$searchString");

    if (response.statusCode == 200) {
      Map data = response.data;

      List<dynamic> results = data["hydra:member"];
      List<Product> products = [];

      for (Map<String, dynamic> json in results) {
        // Transformation du JSON en objet Product
        Product product = Product(
            id: json['id'] as int,
            name: json['name'] as String,
            description: json['description'] as String,
            price: json['price'] as double,
            partner: json['partner'] as String,
            quantity: json['quantity'] as String,
            image: json['image'] as String);

        products.add(product);
      }

      return products;
    } else {
      throw response;
    }
  }
  Future<Response> createOrder(List<Map<String, dynamic>> cartItems) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('userId');

  // Construction du corps de la requête
  Map<String, dynamic> body = {
    'user': userId, // Assurez-vous que l'API attend le token ici, sinon vous devrez peut-être fournir l'ID de l'utilisateur
    'status': 'pending', // Mettez le statut que vous voulez pour la nouvelle commande
    'orderlines': cartItems.map((item) => {
      'product_id': item['id'], // Assurez-vous que 'id' est le bon champ pour l'ID du produit
      'quantity': item['quantity'], // Assurez-vous que 'quantity' est le bon champ pour la quantité
    }).toList(),
  };

  // Envoi de la requête
  final response = await dio.post(
    '/orders',
    data: body
    );

  // Vérification de la réponse
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to create order: ${response.statusMessage}');
  }
}
  
}
