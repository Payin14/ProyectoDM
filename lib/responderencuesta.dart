import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'alerts.dart';

class ResponderEncuestaView extends StatelessWidget {
  final String informacion;

  const ResponderEncuestaView({Key? key, required this.informacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> resultado = json.decode(informacion)['data'][0];
print(resultado);
    // Extraer información de la encuesta
    String tituloEncuesta = resultado['titulo'];
    List<dynamic> preguntas = resultado['preguntas'];
    int idEncuesta = resultado['Id_encuesta'];

    // Lista para almacenar las respuestas
    List<String?> respuestas = List.generate(preguntas.length, (index) => null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Responder Encuesta $tituloEncuesta'),
      ),
      body: ListView.builder(
        itemCount: preguntas.length,
        itemBuilder: (context, index) {
          final pregunta = preguntas[index];
          return ListTile(
            title: Text('Pregunta ${pregunta['id_pregunta']}: ${pregunta['texto_pregunta']}'),
            subtitle: TextField(
              onChanged: (respuesta) {
                // Actualizar la lista de respuestas
                respuestas[index] = respuesta;
              },
              decoration: InputDecoration(labelText: 'Respuesta'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Verificar si todas las respuestas fueron proporcionadas
          if (respuestas.every((respuesta) => respuesta != null && respuesta!.isNotEmpty)) {
            mostrarAlertDialog1(context, 'Enviando respuestas...');

            // Lista para almacenar los futuros de las solicitudes HTTP
            List<Future<void>> futures = [];

            // Iterar sobre cada pregunta y enviar la respuesta correspondiente
            for (int i = 0; i < preguntas.length; i++) {
              // Agregar cada futuro a la lista
              futures.add(enviarRespuesta(idEncuesta, preguntas[i]['id_pregunta'], respuestas[i]));
            }

            // Esperar a que todas las solicitudes se completen
            await Future.wait(futures);

            // Cerrar el diálogo "Enviando respuestas..."
            Navigator.pop(context);

            // Mostrar el diálogo de éxito
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Respuestas enviadas con éxito'),
                  content: const Text('Las respuestas se han añadido correctamente.'),
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
            mostrarError('Por favor, responde todas las preguntas.', context);
          }
        },
        child: Icon(Icons.send),
      ),
    );
  }

  Future<void> enviarRespuesta(int idEncuesta, int idPregunta, String? respuesta) async {
    try {
      final response = await http.post(Uri.parse(
        'http://127.0.0.1:8000/api/agregarRespuesta'),
        body: {
          'IDUsuario': '1', // Ajusta según tu necesidad
          'id_encuesta': idEncuesta.toString(),
          'id_pregunta': idPregunta.toString(),
          'respuesta': respuesta ?? '', // Asegurarse de manejar el caso de respuesta nula
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Éxito, puedes manejar la respuesta de la API si es necesario
        print('Respuesta enviada con éxito para la pregunta $idPregunta');
      } else {
        // Manejar errores o mostrar mensajes al usuario
        print('Error al enviar respuesta para la pregunta $idPregunta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al enviar respuesta para la pregunta $idPregunta: $error');
    }
  }
}
