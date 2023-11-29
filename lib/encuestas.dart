import 'package:flutter/material.dart';
import 'dart:convert';

import 'agregarpregunta.dart';
import 'editarPregunta.dart'; // Asegúrate de importar el archivo correspondiente

class Resultado extends StatelessWidget {
  final String informacion;

  const Resultado({Key? key, required this.informacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic decodedInfo = json.decode(informacion);

    // Asegurarse de que estamos tratando la respuesta como una lista
    List<dynamic> encuestas;
    if (decodedInfo is List) {
      encuestas = decodedInfo.cast<Map<String, dynamic>>();
    } else if (decodedInfo is Map<String, dynamic> && decodedInfo.containsKey('data')) {
      // Manejar el caso en que el objeto contiene una propiedad 'data'
      encuestas = decodedInfo['data'].cast<Map<String, dynamic>>();
    } else {
      // Manejar otros casos según sea necesario
      return Center(child: Text('Error en el formato de la respuesta'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de Encuestas'),
      ),
      body: ListView.builder(
        itemCount: encuestas.length,
        itemBuilder: (context, index) {
          final Map<String, dynamic> encuesta = encuestas[index];
          String tituloEncuesta = encuesta['titulo'];
          List<dynamic> preguntas = encuesta['preguntas'];
          int idEncuesta = encuesta['Id_encuesta'];

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('Encuesta: $tituloEncuesta'),
                ),
                // Verificar si hay preguntas
                preguntas.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: preguntas.length,
                        itemBuilder: (context, index) {
                          final pregunta = preguntas[index];
                          return ListTile(
                            title: Text('Pregunta: ${pregunta['texto_pregunta']}'),
                          );
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No hay preguntas para esta encuesta.'),
                      ),
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la vista de agregar pregunta
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgregarPreguntaView(idEncuesta: idEncuesta),
                      ),
                    );
                  },
                  child: Text('Agregar Pregunta'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la vista de editar preguntas
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarPreguntaView(idEncuesta: idEncuesta),
                      ),
                    );
                  },
                  child: Text('Editar Preguntas'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
