import 'package:flutter/material.dart';
import 'app.dart';

void main() {
// Carga las variables de entorno desde el archivo .env
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Login',
      home: SignUpScreen(),
    );
  }
}
