import '../../../../core/database/database_helper.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../models/client_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final DatabaseHelper dbHelper;

  ClientRepositoryImpl({DatabaseHelper? helper})
      : dbHelper = helper ?? DatabaseHelper.instance;

  @override
  Future<List<Client>> getClients() async {
    final db = await dbHelper.database;
    final result = await db.query('clients', orderBy: 'name ASC');
    return result.map((map) => ClientModel.fromMap(map)).toList();
  }

  @override
  Future<Client?> getClientById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'clients',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return ClientModel.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<int> insertClient(Client client) async {
    final db = await dbHelper.database;
    final model = ClientModel.fromEntity(client);
    return await db.insert('clients', model.toMap());
  }

  @override
  Future<int> updateClient(Client client) async {
    final db = await dbHelper.database;
    final model = ClientModel.fromEntity(client);
    return await db.update(
      'clients',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  @override
  Future<int> deleteClient(int id) async {
    final db = await dbHelper.database;
    // La FK ON DELETE CASCADE eliminará en cascada las mascotas y citas vinculadas
    return await db.delete(
      'clients',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Client>> searchClients(String query) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'clients',
      where: 'name LIKE ? OR phone LIKE ? OR address LIKE ? OR zone LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return result.map((map) => ClientModel.fromMap(map)).toList();
  }
}
