import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({Key? key}) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Ingrese texto',
      ),
      onChanged: (value) {
        setState(() {
          // Realiza la validación y filtra los caracteres no permitidos
          _controller.text = _filterSpecialCharacters(value);
        });
      },
    );
  }

  String _filterSpecialCharacters(String input) {
    // Define los caracteres permitidos
    final RegExp validCharacters = RegExp(r'[a-zA-Z@.]');

    // Filtra los caracteres no permitidos
    return input
        .split('')
        .where((char) => validCharacters.hasMatch(char))
        .join();
  }
}

void main() {
  runApp(
    MaterialApp(
      home: const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CustomTextField(),
          ),
        ),
      ),
    ),
  );
}
