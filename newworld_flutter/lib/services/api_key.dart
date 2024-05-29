/// Classe `APIKey` sert à stocker de manière centralisée les clés API utilisées
/// dans l'application.
///
/// Cette classe contient des clés API statiques qui peuvent être utilisées à
/// travers l'application pour accéder à des services web externes. Il est
/// important de garder ces clés sécurisées et de ne pas les exposer
/// publiquement, notamment sur des dépôts de code source ouverts.
///
/// Usage :
/// Pour utiliser la clé API dans votre code, référencez-la via `APIKey.apikey`.
///
/// Exemple :
/// ```
/// var myApiKey = APIKey.apikey;
/// ```
///
/// Sécurité :
/// - Assurez-vous que votre clé API n'est pas exposée dans des endroits
/// accessibles au public.
class APIKey {
  /// Clé API pour l'accès aux services du site themoviedb.org.
  static String apikey = '586dec5b9c6e21f65ea2ac79a27920a6';
}
