// lista_usuarios.dart
import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class ListaUsuariosScreen extends StatelessWidget {
  final List<Propietario> usuarios;

  ListaUsuariosScreen({required this.usuarios});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
      ),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          return ListTile(
            title: Text('Placa: ${usuario.placa}'),
            subtitle: Text('Nombre: ${usuario.nombre}'),
          );
        },
      ),
    );
  }
}
