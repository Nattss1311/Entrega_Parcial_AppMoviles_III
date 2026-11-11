import '../entities/pet.dart';

abstract class PetRepository {
  Future<List<Pet>> getPets();
  Future<List<Pet>> getPetsByClientId(int clientId);
  Future<Pet?> getPetById(int id);
  Future<int> insertPet(Pet pet);
  Future<int> updatePet(Pet pet);
  Future<int> deletePet(int id);
}
