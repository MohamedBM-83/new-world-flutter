import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebouc',
      home: BasicPage(),
    );
  }
}

class BasicPage extends StatelessWidget {
  CircleAvatar myProfilePic(double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage('images/profile.jpg'),
    );
  }

  Widget sectionTitleText(String text) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget aboutRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(text),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: const Text(
          'Votre compte',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 30),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/back.jpeg'), fit: BoxFit.fill)),
        ),
      ),
    );
  }
}
