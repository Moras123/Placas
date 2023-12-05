// user_entry.dart
import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class UserEntryScreen extends StatefulWidget {
  @override
  _UserEntryScreenState createState() => _UserEntryScreenState();
}

class _UserEntryScreenState extends State<UserEntryScreen> {
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingresar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _placaController,
              decoration: InputDecoration(labelText: 'Placa'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _registrarUsuario,
              child: Text('Registrar Usuario'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registrarUsuario() async {
    final placa = _placaController.text;
    final nombre = _nombreController.text;

    if (placa.isNotEmpty && nombre.isNotEmpty) {
      final nuevoPropietario = Propietario(placa: placa, nombre: nombre);
      await DatabaseHelper().insertPropietario(nuevoPropietario);

      // Puedes mostrar un mensaje al usuario indicando que el registro se ha completado
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Usuario registrado exitosamente'),
      ));

      // Puedes cerrar la pantalla de ingreso de usuario y volver a la pantalla principal
      Navigator.pop(context);
    } else {
      // Puedes mostrar un mensaje al usuario indicando que debe completar todos los campos
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, completa todos los campos'),
      ));
    }
  }
}
