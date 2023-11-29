import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'alerts.dart';

class EditarPreguntaView extends StatefulWidget {
  final int idEncuesta;

  const EditarPreguntaView({Key? key, required this.idEncuesta}) : super(key: key);

  @override
  _EditarPreguntaViewState createState() => _EditarPreguntaViewState();
}

class _EditarPreguntaViewState extends State<EditarPreguntaView> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> preguntas = [];
  TextEditingController preguntaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Obtener las preguntas de la encuesta seleccionada al inicializar el estado
    obtenerPreguntas();
  }

  void obtenerPreguntas() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/obtenerTodasLasEncuestasConPreguntas'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final encuestas = data['data'];

        // Buscar la encuesta por ID
        final encuestaSeleccionada = encuestas.firstWhere(
          (encuesta) => encuesta['Id_encuesta'] == widget.idEncuesta,
          orElse: () => null,
        );

        if (encuestaSeleccionada != null) {
          setState(() {
            preguntas = List<Map<String, dynamic>>.from(encuestaSeleccionada['preguntas']);
          });
        } else {
          mostrarError('No se encontró la encuesta seleccionada', context);
        }
      } else {
        mostrarError('Error al obtener las preguntas: ${response.statusCode}', context);
      }
    } catch (error) {
      mostrarError('Error al obtener las preguntas: $error', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Preguntas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mostrar cada pregunta en un TextField para editar
              for (var pregunta in preguntas)
                TextFormField(
                  initialValue: pregunta['texto_pregunta'],
                  onChanged: (value) {
                    // Actualizar el valor en la lista de preguntas
                    pregunta['texto_pregunta'] = value;
                  },
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
                  // Validar el formulario antes de editar las preguntas
                  if (_formKey.currentState?.validate() ?? false) {
                    editarPreguntas(widget.idEncuesta, preguntas);
                  }
                },
                child: const Text('Editar Preguntas'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editarPreguntas(int idEncuesta, List<Map<String, dynamic>> preguntas) async {
    mostrarAlertDialog(context, 'Editando preguntas...');
    try {
      // Realizar la solicitud HTTP para editar las preguntas
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/editarPregunta'),
        body: {
          'id_encuesta': idEncuesta.toString(),
          'preguntas': json.encode(preguntas),
        },
      );

      // Manejar la respuesta de la API según sea necesario
      if (response.statusCode == 200 || response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Preguntas editadas con éxito'),
              content: const Text('Las preguntas se han editado correctamente.'),
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
        mostrarError('Error al editar las preguntas: ${response.statusCode}', context);
      }
    } catch (error) {
      mostrarError('Error al editar las preguntas: $error', context);
    }
  }
}
