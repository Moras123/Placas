import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:placa/userInfoScreen.dart';
import 'package:placa/user_entry.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

import 'DatabaseHelper.dart';
import 'lista_usuarios.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController? _cameraController;
  File? _image;
  String _recognizedText = '';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    // Mover la lógica de inserción a initState
    _insertPropietario();

    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController!.initialize();
    setState(() {});
  }

  Future<void> _insertPropietario() async {
    Propietario nuevoPropietario = Propietario(placa: '1852PHD', nombre: 'Juan Pérez');

    // Insertar el nuevo propietario en la base de datos
    await DatabaseHelper().insertPropietario(nuevoPropietario);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Placa Recognition'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _cameraController == null
                  ? Container(
                margin: EdgeInsets.all(10.0),
                child: Text('Inicializando la cámara...'),
              )
                  : Container(
                margin: EdgeInsets.all(10.0),
                child: CameraPreview(_cameraController!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Seleccionar Imagen'),
              ),
              ElevatedButton(
                onPressed: _recognizePlate,
                child: Text('Reconocer Placa en Tiempo Real'),
              ),
              SizedBox(height: 20),
              _isProcessing
                  ? CircularProgressIndicator()
                  : Text('Texto Reconocido: $_recognizedText'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _recognizedText = '';
        });
      }
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
    }
  }

  Future<void> _recognizePlate() async {
    if (_isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile imageFile = await _cameraController!.takePicture();

      final inputImage = InputImage.fromFilePath(imageFile.path);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      String recognizedTextString = '';
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          recognizedTextString += line.text + ' ';
        }
        recognizedTextString += '\n';
      }

      setState(() {
        _recognizedText = recognizedTextString.trim();
      });

      final propietario = await DatabaseHelper().buscarPropietarioPorPlaca(_recognizedText);

      if (propietario != null) {
        // Redirigir a la pantalla de información del usuario
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserInfoScreen(propietario: propietario)),
        );
      } else {
        // Mostrar un mensaje en la pantalla actual
        setState(() {
          _recognizedText = 'Usuario no encontrado';
        });
      }
    } catch (e) {
      print('Error en el reconocimiento de placa: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
}
