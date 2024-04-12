import 'package:flutter/material.dart';
import 'package:newworld_flutter/home.dart';
import 'package:newworld_flutter/shop.dart';
import 'package:newworld_flutter/account.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,   //tableau contenant les redirection de toutes les pages
        children: const [
          HomePage(),         // redirection vers la page accueil
          ShopPage(), // redirection vers le panier
          AccountPage(), // redirection vers la page compte
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 179, 179, 179), // Fond de la navbar
        selectedItemColor: Colors.black, // Couleur des icônes sélectionnées
        unselectedItemColor: Colors.black, // Couleur des icônes non sélectionnées
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        currentIndex: currentPageIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home, currentPageIndex == 0),      // index 0 du tableau de redirection
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.shopping_bag, currentPageIndex == 1),  // index 1 du tableau de redirection
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.person, currentPageIndex == 2),  // index 2 du tableau de redirection
            label: 'Compte',
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData iconData, bool isSelected) {
    return isSelected
        ? AnimatedContainer(            // animation pour aggrandissement des icon lors de leur selection
            duration: const Duration(milliseconds: 300),      // timing de l'affichage
            transform: Matrix4.translationValues(-5.0, -10.0, 0.0)    // positionnement de l'aggrandissement
            
              ..scale(isSelected ? 1.5 : 1.0),
            child: Icon(iconData), 
          )
        : Icon(iconData);
  }
}
