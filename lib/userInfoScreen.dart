// userInfoScreen.dart
import 'package:flutter/material.dart';

import 'DatabaseHelper.dart';

class UserInfoScreen extends StatelessWidget {
  final Propietario propietario;

  UserInfoScreen({required this.propietario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información del Usuario'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Placa: ${propietario.placa}'),
            Text('Nombre: ${propietario.nombre}'),
            // Agrega aquí más detalles si es necesario
          ],
        ),
      ),
    );
  }
}
