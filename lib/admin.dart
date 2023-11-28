// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'alerts.dart';
import 'encuestas.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  Future<void> obtenerInformacionAPI() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    mostrarAlertDialog(context, 'Buscando información...');

    try {
      // URL de la API con el nombre del país deseado
      String apiUrl =
          'http://127.0.0.1:8000/api/obtenerTodasLasEncuestasConPreguntas';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = response.body;
        print(data);
        mostrarResultados(data);
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        mostrarError('No se encontraron datos', context);
      }
    } on SocketException {
      Navigator.of(context, rootNavigator: true).pop();
      mostrarError('Error de red: No se pudo conectar al servidor', context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      mostrarError('Otro error inesperado: $e', context);
    }
  }

  Future<void> mostrarResultados(dynamic data) async {
    try {
      var jsonResponse = json.decode(data);

      if (jsonResponse is Map) {
        String message = jsonResponse['message'];
        if (message == 'Encuestas y preguntas obtenidas con éxito') {
          Navigator.of(context, rootNavigator: true).pop();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Resultado(
                informacion: data,
              ),
            ),
          );
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        mostrarError('Error: Respuesta de la API inesperada.', context);
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      mostrarError('Error al procesar la respuesta de la API', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encuestas'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://assets-global.website-files.com/5f4f67c5950db17954dd4f52/6422ff4b8c21bb0419d4fdf2_encuestas.jpeg', // Reemplaza con la URL del fondo
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: obtenerInformacionAPI,
                      icon: const Icon(Icons.search),
                      label: const Text('Ver encuestas',
                          style: TextStyle(fontSize: 20)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
