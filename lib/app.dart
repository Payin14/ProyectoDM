import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:proyectodm/CrearUsuario.dart';
import 'package:proyectodm/admin.dart';
import 'package:proyectodm/encuestausuario.dart';
import 'alerts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    mostrarAlertDialog(context, 'Espere...');
    try {
      Response response = await post(
        Uri.parse('http://127.0.0.1:8000/api/Login'),
        body: {
          'usuario': usuarioController.text,
          'pass': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data['mensaje']);
        print('Login successfully');
        if (data['mensaje'] == "Login exitoso Administrador") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage(title: 'title')),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EncuestaUsuario(title: 'title')),
          );
        }
      } else {
        Navigator.pop(context);
        // Mostrar un mensaje de error si las credenciales son incorrectas
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Credenciales incorrectas. Intenta de nuevo.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void irACrearUsuario() {
    // Navegar a la página de crear usuario
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserCreationScreen()),  // Reemplaza "CrearUsuarioPage" con el nombre de tu página de crear usuario
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: usuarioController,
              decoration: InputDecoration(
                hintText: 'Usuario',
              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: passwordController,
              obscureText: true, 
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 40,),
            GestureDetector(
              onTap: () {
                login();
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text('Login'),
                ),
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: irACrearUsuario,
              child: Text('Crear Usuario'),
            ),
          ],
        ),
      ),
    );
  }
}

class CrearUsuarioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Usuario'),
      ),
      body: Center(
        child: Text('Esta es la página de crear usuario'),
      ),
    );
  }
}
