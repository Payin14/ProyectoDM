import 'package:flutter/material.dart';
import 'dart:async';

import 'admin.dart';
import 'encuesta.dart';
// Importa el paquete

class MyAppForm extends StatefulWidget {
  const MyAppForm({Key? key}) : super(key: key);

  @override
  _MyAppFormState createState() => _MyAppFormState();
}

class _MyAppFormState extends State<MyAppForm> {
  late String _nombre = '';
  late String _email = '';
  late String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 90.0,
        ),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 100.0,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage('https://sic.cultura.gob.mx/images/65754'),
              ),
              const Text(
                'Iniciar sesion',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'NerkoOne',
                  fontSize: 50.0,
                ),
              ),
              const Text(
                'ENCUESTA',
                style: TextStyle(
                  fontFamily: 'NerkoOne',
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                width: 160.0,
                height: 15.0,
                child: Divider(color: Colors.blueGrey[600]),
              ),
              TextField(
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                  hintText: 'USER-NAME',
                  labelText: 'User name',
                  suffixIcon: const Icon(Icons.verified_user),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (valor) {
                  _nombre = valor;
                },
              ),
              const Divider(
                height: 18.0,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  suffixIcon: const Icon(Icons.alternate_email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (valor) {
                  _email = valor;
                },
              ),
              const Divider(
                height: 15.0,
              ),
              TextField(
                enableInteractiveSelection: false,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  suffixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (valor) {
                  _password = valor;
                },
              ),
              const Divider(
                height: 15.0,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlueAccent,
                    onPrimary: Colors.white70,
                    textStyle: const TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'NerkoOne',
                    ),
                  ),
                  onPressed: () {
                    // Validar los valores ingresados
                    print(_nombre);
                    print(_email);
                    print(_password);
                    if (_nombre == 'usuario' &&
                        _email == 'correo@example.com' &&
                        _password == 'contrasena') {
                      // Si son correctos, navegar a otra vista
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurveyPage(),
                        ),
                      );
                    } else if(_nombre == 'admin' &&
                              _email == 'admin@example.com' &&
                              _password == '123456') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminSurveyView(),
                                ),
                              );
                    }else{  
                      // Mostrar un mensaje de error o realizar otra acción
                      print('Credenciales incorrectas');
                    }
                  },
                  child: Text('Sign In'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
