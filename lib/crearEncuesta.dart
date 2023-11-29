// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'alerts.dart';

class AgregarEncuesta extends StatefulWidget {

  const AgregarEncuesta({Key? key}) : super(key: key);

  @override
  _AgregarEncuestaState createState() => _AgregarEncuestaState();
}

class _AgregarEncuestaState extends State<AgregarEncuesta> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController tituloController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Encuesta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: tituloController,
                decoration: const InputDecoration(
                  labelText: 'Titulo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el titulo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Validar el formulario antes de agregar la pregunta
                  if (_formKey.currentState?.validate() ?? false) {
                    agregarEncuesta(tituloController.text, descripcionController.text);
                  }
                },
                child: const Text('Agregar Pregunta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void agregarEncuesta(String titulo, String descripcion) async {

    mostrarAlertDialog(context, 'Agregando encuesta...');
    try {
      // Realizar la solicitud HTTP para agregar la pregunta
      final response = await http.post(Uri.parse('http://127.0.0.1:8000/api/agregarEncuesta'),
        body: {
          'titulo': titulo, 
          'descripcion': descripcion},
      );

      // Manejar la respuesta de la API según sea necesario
      if (response.statusCode == 200 || response.statusCode == 201) {
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Encuesta añadida con éxito'),
            content: const Text('La encuesta se ha añadido correctamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  // Cerrar el diálogo y navegar hacia atrás
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
      } else {
        // Manejar errores o mostrar mensajes al usuario
    print('ola');
        mostrarError('Error al agregar la encuesta: ${response.statusCode}',context);
      }
    } catch (error) {
      print('ola2');
      mostrarError('Error al agregar la encuesta: $error',context);
    }
  }
}
