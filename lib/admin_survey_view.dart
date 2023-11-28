import 'package:flutter/material.dart';

import 'Survey.dart';

class AdminSurveyView extends StatefulWidget {
  @override
  _AdminSurveyViewState createState() => _AdminSurveyViewState();
}

class _AdminSurveyViewState extends State<AdminSurveyView> {
  List<Survey> surveys = []; // Lista de encuestas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrador de Encuestas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Encuestas Disponibles:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: surveys.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(surveys[index].title),
                      subtitle:
                          Text('Preguntas: ${surveys[index].questions.length}'),
                      onTap: () {
                        // Aquí puedes manejar la navegación a la vista de detalles de la encuesta
                        // Por ejemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyDetailsView(survey: surveys[index])));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
