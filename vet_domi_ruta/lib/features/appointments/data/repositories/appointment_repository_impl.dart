import '../../../../core/database/database_helper.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final DatabaseHelper dbHelper;

  AppointmentRepositoryImpl({DatabaseHelper? helper})
      : dbHelper = helper ?? DatabaseHelper.instance;

  static const String _joinedSelectQuery = '''
    SELECT 
      a.id,
      a.pet_id,
      a.client_id,
      a.service_type,
      a.appointment_date,
      a.status,
      a.base_fee,
      a.transport_fee,
      a.total_fee,
      a.address,
      a.notes,
      a.created_at,
      c.name AS client_name,
      c.phone AS client_phone,
      c.zone AS client_zone,
      p.name AS pet_name,
      p.species AS pet_species,
      p.breed AS pet_breed
    FROM appointments a
    INNER JOIN clients c ON a.client_id = c.id
    INNER JOIN pets p ON a.pet_id = p.id
  ''';

  @override
  Future<List<Appointment>> getAppointments() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('$_joinedSelectQuery ORDER BY a.appointment_date ASC');
    return result.map((map) => AppointmentModel.fromMap(map)).toList();
  }

  @override
  Future<List<Appointment>> getTodayAppointments() async {
    final db = await dbHelper.database;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0).toIso8601String();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String();

    final result = await db.rawQuery(
      '''$_joinedSelectQuery 
         WHERE a.appointment_date BETWEEN ? AND ? 
         ORDER BY a.appointment_date ASC''',
      [startOfDay, endOfDay],
    );
    return result.map((map) => AppointmentModel.fromMap(map)).toList();
  }

  @override
  Future<List<Appointment>> getAppointmentsByStatus(String status) async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      '$_joinedSelectQuery WHERE a.status = ? ORDER BY a.appointment_date ASC',
      [status],
    );
    return result.map((map) => AppointmentModel.fromMap(map)).toList();
  }

  @override
  Future<List<Appointment>> getAppointmentsByClientId(int clientId) async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      '$_joinedSelectQuery WHERE a.client_id = ? ORDER BY a.appointment_date DESC',
      [clientId],
    );
    return result.map((map) => AppointmentModel.fromMap(map)).toList();
  }

  @override
  Future<List<Appointment>> getAppointmentsByPetId(int petId) async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      '$_joinedSelectQuery WHERE a.pet_id = ? ORDER BY a.appointment_date DESC',
      [petId],
    );
    return result.map((map) => AppointmentModel.fromMap(map)).toList();
  }

  @override
  Future<Appointment?> getAppointmentById(int id) async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      '$_joinedSelectQuery WHERE a.id = ? LIMIT 1',
      [id],
    );
    if (result.isNotEmpty) {
      return AppointmentModel.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<int> insertAppointment(Appointment appointment) async {
    final db = await dbHelper.database;
    final model = AppointmentModel.fromEntity(appointment);
    return await db.insert('appointments', model.toMap());
  }

  @override
  Future<int> updateAppointment(Appointment appointment) async {
    final db = await dbHelper.database;
    final model = AppointmentModel.fromEntity(appointment);
    return await db.update(
      'appointments',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }

  @override
  Future<int> updateAppointmentStatus(int id, String status) async {
    final db = await dbHelper.database;
    return await db.update(
      'appointments',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteAppointment(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'appointments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<double> getTotalRevenueToday() async {
    final db = await dbHelper.database;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0).toIso8601String();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String();

    final result = await db.rawQuery(
      '''SELECT SUM(total_fee) AS total 
         FROM appointments 
         WHERE appointment_date BETWEEN ? AND ? 
         AND status != 'Cancelada' ''',
      [startOfDay, endOfDay],
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toDouble();
    }
    return 0.0;
  }
}
