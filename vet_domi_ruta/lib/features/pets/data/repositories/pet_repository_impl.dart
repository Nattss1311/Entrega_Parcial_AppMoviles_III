import '../../../../core/database/database_helper.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';
import '../models/pet_model.dart';

class PetRepositoryImpl implements PetRepository {
  final DatabaseHelper dbHelper;

  PetRepositoryImpl({DatabaseHelper? helper})
      : dbHelper = helper ?? DatabaseHelper.instance;

  @override
  Future<List<Pet>> getPets() async {
    final db = await dbHelper.database;
    final result = await db.query('pets', orderBy: 'name ASC');
    return result.map((map) => PetModel.fromMap(map)).toList();
  }

  @override
  Future<List<Pet>> getPetsByClientId(int clientId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'pets',
      where: 'client_id = ?',
      whereArgs: [clientId],
      orderBy: 'name ASC',
    );
    return result.map((map) => PetModel.fromMap(map)).toList();
  }

  @override
  Future<Pet?> getPetById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'pets',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return PetModel.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<int> insertPet(Pet pet) async {
    final db = await dbHelper.database;
    final model = PetModel.fromEntity(pet);
    return await db.insert('pets', model.toMap());
  }

  @override
  Future<int> updatePet(Pet pet) async {
    final db = await dbHelper.database;
    final model = PetModel.fromEntity(pet);
    return await db.update(
      'pets',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [pet.id],
    );
  }

  @override
  Future<int> deletePet(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'pets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
