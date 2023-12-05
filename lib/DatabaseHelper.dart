import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Propietario {
  final String placa;
  final String nombre;

  Propietario({required this.placa, required this.nombre});
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  late Database _database;

  DatabaseHelper.internal() {
    _checkDatabaseExistence();
  }

  Future<void> _checkDatabaseExistence() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'propietarios.db');
    bool isdatabaseExists = await databaseExists(path);

    if (!isdatabaseExists) {
      _database = await initDatabase();
    } else {
      _database = await openDatabase(path, version: 1);
    }
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'propietarios.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE Propietarios(placa TEXT PRIMARY KEY, nombre TEXT)',
        );
      },
    );
  }

  Future<void> insertPropietario(Propietario propietario) async {
    await _checkDatabaseExistence();
    await _database.insert(
      'Propietarios',
      {
        'placa': propietario.placa,
        'nombre': propietario.nombre,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Propietario?> buscarPropietarioPorPlaca(String placa) async {
    await _checkDatabaseExistence();
    final maps = await _database.query('Propietarios',
        where: 'placa = ?', whereArgs: [placa], limit: 1);

    if (maps.isNotEmpty) {
      return Propietario(
        placa: maps.first['placa'] as String,
        nombre: maps.first['nombre'] as String,
      );
    }

    return null;
  }

  // Nueva función para obtener todos los propietarios
  Future<List<Propietario>> obtenerTodosPropietarios() async {
    await _checkDatabaseExistence();
    final List<Map<String, dynamic>> maps = await _database.query('Propietarios');

    return List.generate(maps.length, (i) {
      return Propietario(
        placa: maps[i]['placa'] as String,
        nombre: maps[i]['nombre'] as String,
      );
    });
  }
}
