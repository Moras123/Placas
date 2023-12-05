import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:placa/plate_recognition.dart';
import 'package:placa/user_entry.dart';
import 'package:permission_handler/permission_handler.dart';

import 'DatabaseHelper.dart';
import 'lista_usuarios.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Placa Recognition App',
      home: HomeScreen(),
    );
  }
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App de Registro y Búsqueda'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserEntryScreen()),
              ),
              child: Text('Ingresar Nuevo Usuario'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              child: Text('Búsqueda'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _verTodosUsuarios(context),
              child: Text('Ver Todos los Usuarios'),
            ),
          ],
        ),
      ),
    );

  }
  Future<void> _verTodosUsuarios(BuildContext context) async {
    final List<Propietario> usuarios = await DatabaseHelper().obtenerTodosPropietarios();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListaUsuariosScreen(usuarios: usuarios)),
    );
  }
}
