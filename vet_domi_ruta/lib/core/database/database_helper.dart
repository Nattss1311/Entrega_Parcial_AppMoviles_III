import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vet_domi_ruta.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _createDB,
    );
  }

  Future<void> _onConfigure(Database db) async {
    // Activa la integridad referencial para llaves foráneas y cascadas
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDB(Database db, int version) async {
    // Tabla 1: Clientes (Propietarios de mascotas)
    await db.execute('''
      CREATE TABLE clients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        zone TEXT NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Tabla 2: Mascotas (Pacientes veterinarios)
    await db.execute('''
      CREATE TABLE pets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        species TEXT NOT NULL,
        breed TEXT NOT NULL,
        age_years INTEGER NOT NULL,
        weight_kg REAL NOT NULL,
        medical_notes TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE
      )
    ''');

    // Tabla 3: Citas / Rutas a Domicilio
    await db.execute('''
      CREATE TABLE appointments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pet_id INTEGER NOT NULL,
        client_id INTEGER NOT NULL,
        service_type TEXT NOT NULL,
        appointment_date TEXT NOT NULL,
        status TEXT NOT NULL,
        base_fee REAL NOT NULL,
        transport_fee REAL NOT NULL,
        total_fee REAL NOT NULL,
        address TEXT NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE,
        FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE
      )
    ''');

    // Inserción de Mock Data Inicial (Semillero)
    await _seedDatabase(db);
  }

  Future<void> _seedDatabase(Database db) async {
    final now = DateTime.now();

    // 1. Semillero de 3 Clientes
    final client1Id = await db.insert('clients', {
      'name': 'Dra. Mariana López',
      'phone': '+57 312 456 7890',
      'address': 'Calle 127 # 15-42, Apto 502',
      'zone': 'Norte - Usaquén',
      'notes': 'Condominio cerrado con citófono. Portón principal.',
      'created_at': now.subtract(const Duration(days: 30)).toIso8601String(),
    });

    final client2Id = await db.insert('clients', {
      'name': 'Carlos Eduardo Restrepo',
      'phone': '+57 300 987 6543',
      'address': 'Carrera 7 # 67-31, Casa 4',
      'zone': 'Chapinero Alto',
      'notes': 'Parqueadero de visitantes disponible.',
      'created_at': now.subtract(const Duration(days: 20)).toIso8601String(),
    });

    final client3Id = await db.insert('clients', {
      'name': 'Valentina Gómez Peña',
      'phone': '+57 318 654 3210',
      'address': 'Av. Suba # 115-88, Torre 2',
      'zone': 'Suba - Pontevedra',
      'notes': 'Atención preferencial los fines de semana.',
      'created_at': now.subtract(const Duration(days: 10)).toIso8601String(),
    });

    // 2. Semillero de 4 Mascotas
    final pet1Id = await db.insert('pets', {
      'client_id': client1Id,
      'name': 'Maximus',
      'species': 'Canino',
      'breed': 'Golden Retriever',
      'age_years': 4,
      'weight_kg': 32.5,
      'medical_notes': 'Alérgico a ciertos antipulgas tópicos. Muy dócil.',
      'created_at': now.subtract(const Duration(days: 30)).toIso8601String(),
    });

    final pet2Id = await db.insert('pets', {
      'client_id': client1Id,
      'name': 'Luna',
      'species': 'Felino',
      'breed': 'Siamés',
      'age_years': 2,
      'weight_kg': 4.2,
      'medical_notes': 'Esquema de vacunación al día. Nerviosa con extraños.',
      'created_at': now.subtract(const Duration(days: 25)).toIso8601String(),
    });

    final pet3Id = await db.insert('pets', {
      'client_id': client2Id,
      'name': 'Rocky',
      'species': 'Canino',
      'breed': 'Bulldog Francés',
      'age_years': 3,
      'weight_kg': 12.8,
      'medical_notes': 'Sensibilidad respiratoria braquiocefálica.',
      'created_at': now.subtract(const Duration(days: 20)).toIso8601String(),
    });

    final pet4Id = await db.insert('pets', {
      'client_id': client3Id,
      'name': 'Kira',
      'species': 'Felino',
      'breed': 'Persa Blanco',
      'age_years': 5,
      'weight_kg': 3.9,
      'medical_notes': 'Mantenimiento periódico de pelaje y control renal.',
      'created_at': now.subtract(const Duration(days: 10)).toIso8601String(),
    });

    // 3. Semillero de 5 Citas a Domicilio
    // Cita 1: Hoy a las 09:00 AM (En Ruta / Pendiente)
    final date1 = DateTime(now.year, now.month, now.day, 9, 0);
    await db.insert('appointments', {
      'pet_id': pet1Id,
      'client_id': client1Id,
      'service_type': 'Vacunación Múltiple y Rabia',
      'appointment_date': date1.toIso8601String(),
      'status': 'En Ruta',
      'base_fee': 65000.0,
      'transport_fee': 20000.0,
      'total_fee': 85000.0,
      'address': 'Calle 127 # 15-42, Apto 502',
      'notes': 'Llevar carnet físico y vacuna antirrábica refrigerada.',
      'created_at': now.subtract(const Duration(days: 2)).toIso8601String(),
    });

    // Cita 2: Hoy a las 11:30 AM (Pendiente)
    final date2 = DateTime(now.year, now.month, now.day, 11, 30);
    await db.insert('appointments', {
      'pet_id': pet2Id,
      'client_id': client1Id,
      'service_type': 'Control Desparasitación Felina',
      'appointment_date': date2.toIso8601String(),
      'status': 'Pendiente',
      'base_fee': 50000.0,
      'transport_fee': 10000.0,
      'total_fee': 60000.0,
      'address': 'Calle 127 # 15-42, Apto 502',
      'notes': 'Aprovechar la visita de Maximus para revisar a Luna.',
      'created_at': now.subtract(const Duration(days: 2)).toIso8601String(),
    });

    // Cita 3: Hoy a las 03:00 PM (Pendiente)
    final date3 = DateTime(now.year, now.month, now.day, 15, 0);
    await db.insert('appointments', {
      'pet_id': pet3Id,
      'client_id': client2Id,
      'service_type': 'Consulta Dermatológica y Oído',
      'appointment_date': date3.toIso8601String(),
      'status': 'Pendiente',
      'base_fee': 80000.0,
      'transport_fee': 25000.0,
      'total_fee': 105000.0,
      'address': 'Carrera 7 # 67-31, Casa 4',
      'notes': 'Revisión por prurito excesivo en pliegues nasales.',
      'created_at': now.subtract(const Duration(days: 1)).toIso8601String(),
    });

    // Cita 4: Mañana a las 10:00 AM (Programada)
    final date4 = DateTime(now.year, now.month, now.day + 1, 10, 0);
    await db.insert('appointments', {
      'pet_id': pet4Id,
      'client_id': client3Id,
      'service_type': 'Peluquería Canina/Felina y Profilaxis',
      'appointment_date': date4.toIso8601String(),
      'status': 'Pendiente',
      'base_fee': 95000.0,
      'transport_fee': 22000.0,
      'total_fee': 117000.0,
      'address': 'Av. Suba # 115-88, Torre 2',
      'notes': 'Desanudado suave y corte higiénico.',
      'created_at': now.subtract(const Duration(hours: 12)).toIso8601String(),
    });

    // Cita 5: Ayer (Completada con éxito)
    final date5 = DateTime(now.year, now.month, now.day - 1, 14, 0);
    await db.insert('appointments', {
      'pet_id': pet1Id,
      'client_id': client1Id,
      'service_type': 'Control Nutricional y Pesaje',
      'appointment_date': date5.toIso8601String(),
      'status': 'Completada',
      'base_fee': 55000.0,
      'transport_fee': 18000.0,
      'total_fee': 73000.0,
      'address': 'Calle 127 # 15-42, Apto 502',
      'notes': 'Se ajusta porción de alimento seco a 380g/día. Evolución favorable.',
      'created_at': now.subtract(const Duration(days: 4)).toIso8601String(),
    });
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
