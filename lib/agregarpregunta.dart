// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'alerts.dart';

class AgregarPreguntaView extends StatefulWidget {
  final int idEncuesta;

  const AgregarPreguntaView({Key? key, required this.idEncuesta}) : super(key: key);

  @override
  _AgregarPreguntaViewState createState() => _AgregarPreguntaViewState();
}

class _AgregarPreguntaViewState extends State<AgregarPreguntaView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController preguntaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Pregunta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: preguntaController,
                decoration: const InputDecoration(
                  labelText: 'Pregunta',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la pregunta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Validar el formulario antes de agregar la pregunta
                  if (_formKey.currentState?.validate() ?? false) {
                    agregarPregunta(widget.idEncuesta, preguntaController.text);
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

  void agregarPregunta(int idEncuesta, String pregunta) async {

    mostrarAlertDialog(context, 'Agregando pregunta...');
    try {
      // Realizar la solicitud HTTP para agregar la pregunta
      final response = await http.post(Uri.parse('http://127.0.0.1:8000/api/agregarPregunta'),
        body: {
          'id_encuesta': idEncuesta.toString(), 
          'texto_pregunta': pregunta},
      );

      // Manejar la respuesta de la API según sea necesario
      if (response.statusCode == 200 || response.statusCode == 201) {
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pregunta añadida con éxito'),
            content: const Text('La pregunta se ha añadido correctamente.'),
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
        mostrarError('Error al agregar la pregunta: ${response.statusCode}',context);
      }
    } catch (error) {
      print('ola2');
      mostrarError('Error al agregar la pregunta: $error',context);
    }
  }
}
