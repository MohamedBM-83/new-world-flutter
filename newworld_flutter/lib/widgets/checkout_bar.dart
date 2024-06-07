import 'package:flutter/material.dart';
import 'package:newworld/services/cart.dart';
import 'package:newworld/services/user_preferences.dart';

class CheckoutBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FutureBuilder<double>(
              future: Cart().getTotalPrice(),
              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erreur: ${snapshot.error}');
                } else {
                  return Text(
                    'Total: ${snapshot.data} €',
                    style: TextStyle(
                      fontSize: 20,
                      color: UserPreferences().mainTextColor,
                    ),
                  );
                }
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(UserPreferences().newworldColord),
                foregroundColor: MaterialStateProperty.all(
                    UserPreferences().backgroundColor),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 60, vertical: 10)),
              ),
              onPressed: () {
                // Ajoutez ici la logique pour le paiement
              },
              child: Text('Payer'),
            ),
          ],
        ),
      ),
    );
  }
}
