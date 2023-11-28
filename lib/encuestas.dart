import 'package:flutter/material.dart';
import 'dart:convert';

import 'agregarpregunta.dart';

class Resultado extends StatelessWidget {
  final String informacion;

  const Resultado({Key? key, required this.informacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> resultado = json.decode(informacion)['data'][0];

    // Extraer información de la encuesta
    String tituloEncuesta = resultado['titulo'];
    List<dynamic> preguntas = resultado['preguntas'];
    int idEncuesta = resultado['Id_encuesta'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de Encuestas y Preguntas'),
      ),
      body: Card(
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
            // Usar ListView.builder para construir dinámicamente la lista de preguntas
            ListView.builder(
              shrinkWrap: true,
              itemCount: preguntas.length,
              itemBuilder: (context, index) {
                final pregunta = preguntas[index];
                return ListTile(
                  title: Text('Pregunta ${pregunta['id_pregunta']}: ${pregunta['texto_pregunta']}'),
                );
              },
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
          ],
        ),
      ),
    );
  }
}
