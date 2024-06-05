import 'package:flutter/material.dart';
import '../services/api_service.dart';

import 'home_screen.dart';
import 'package:netflim/main.dart';
import '../models/app_tab_controller.dart';
import '../models/product.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<Product> products;

  LoginScreen({required this.products});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: ()   async {
                print(_emailController.text);
                print(_passwordController.text);
                bool isAuthenticated = await ApiService().authenticate(
                  _emailController.text,
                  _passwordController.text,
                );
                if (isAuthenticated) {
                  print("Bienjoué");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppTabController(ProductList: products)));
                // } else {
                //   showDialog(
                //     context: context,
                //     builder: (context) {
                //       return AlertDialog(
                //         title: Text('Erreur'),
                //         content: Text('Email ou mot de passe incorrect'),
                //         actions: <Widget>[
                //           TextButton(
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             },
                //             child: Text('OK'),
                //           ),
                //         ],
                //       );
                //     },
                //   );
                }
              },  
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}