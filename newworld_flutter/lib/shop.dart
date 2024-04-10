import 'package:flutter/material.dart';

void main() {
  runApp(const ShopPage());
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Compte',
      home: BasicPage(),
    );
  }
}

class BasicPage extends StatelessWidget {
  const BasicPage({super.key});

  CircleAvatar myProfilePic(double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: const AssetImage('images/profile.jpg'),
    );
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: const Text(
          'Votre Panier :',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/back.jpeg'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.8), // Change the opacity value here
              BlendMode.dstATop,
            ),
          ),
        ),
        ),
             
      ),
      
    );
    
  }
}
