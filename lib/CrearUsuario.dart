// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'alerts.dart';

class UserCreationScreen extends StatefulWidget {
  @override
  _UserCreationScreenState createState() => _UserCreationScreenState();
}

class _UserCreationScreenState extends State<UserCreationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> createUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Lógica para crear el usuario con los datos ingresados
        String name = nameController.text;
        String email = emailController.text;
        String password = passwordController.text;

        var response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/guardarUsuario'),
          body: {
            'usuario': name,
            'correo': email,
            'pass': password,
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          var data = jsonDecode(response.body.toString());
          print(data['mensaje']);
          print('Usuario creado exitosamente');

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
          mostrarError('Error al crear el usuario', context);
        }

      } catch (e) {
        print('Error al crear el usuario: $e');
        mostrarError('Error al crear el usuario', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Crear Usuario'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu nombre.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Correo electrónico'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu correo electrónico.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu contraseña.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: createUser,
                  child: Text('Crear Usuario'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crear Usuario Demo',
      home: UserCreationScreen(),
    );
  }
}


