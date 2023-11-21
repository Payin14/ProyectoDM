import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as Dotenv;
import 'app.dart'; 

void main() async {
  await Dotenv.load(); // Carga las variables de entorno desde el archivo .env
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Login',
      home: MyAppForm(),
    );
  }
}