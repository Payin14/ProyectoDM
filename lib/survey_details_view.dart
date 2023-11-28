import 'package:flutter/material.dart';

import 'Survey.dart';

class SurveyDetailsView extends StatelessWidget {
  final Survey survey;

  SurveyDetailsView({required this.survey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(survey.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preguntas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Mostrar las preguntas de la encuesta
            for (String question in survey.questions) Text('- $question'),
          ],
        ),
      ),
    );
  }
}
