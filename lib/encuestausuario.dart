import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyectodm/responderencuesta.dart';

import 'alerts.dart';

class EncuestaUsuario extends StatefulWidget {
  const EncuestaUsuario({super.key, required this.title});

  final String title;

  @override
  State<EncuestaUsuario> createState() => _EncuestaUsuario();
}

class _EncuestaUsuario extends State<EncuestaUsuario> {
  final _formKey = GlobalKey<FormState>();
  
  Future<void> obtenerInformacionAPI() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  mostrarAlertDialog(context, 'Buscando información...');

  try {
    // URL de la API con el nombre del país deseado
    String apiUrl = 'http://127.0.0.1:8000/api/obtenerTodasLasEncuestasConPreguntas';

    var response = await http.get(Uri.parse(apiUrl));
   
    if (response.statusCode == 200) {
      var data = response.body;

      mostrarResultados(data);
    }else{
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
              builder: (context) => ResponderEncuestaView(
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
      title: const Text('Encuestas'),
    ),
    body: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Cambiado a MainAxisAlignment.start
            children: [
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                child: const Column(
                  children: [
                    Text(
                      '¡Bienvenido a la Encuesta de Cultura General!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Descubre cuánto sabes sobre diferentes temas.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: obtenerInformacionAPI,
                  icon: const Icon(Icons.file_copy),
                  label: const Text(
                    'Hacer encuesta',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    primary: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


}
