/// Classe `User` représente un modèle pour les données d'utilisateur.
class User {
  final int id;
  final String email;
  // final String password;
  final String firstname;
  final String lastname;

  User({
    required this.id,
    required this.email,
    // required this.password,
    required this.firstname,
    required this.lastname,
  });

}