import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/pet_repository_impl.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';

final petRepositoryProvider = Provider<PetRepository>((ref) {
  return PetRepositoryImpl();
});

class PetsNotifier extends StateNotifier<AsyncValue<List<Pet>>> {
  final PetRepository _repository;

  PetsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadPets();
  }

  Future<void> loadPets() async {
    try {
      state = const AsyncValue.loading();
      final pets = await _repository.getPets();
      state = AsyncValue.data(pets);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addPet(Pet pet) async {
    await _repository.insertPet(pet);
    await loadPets();
  }

  Future<void> updatePet(Pet pet) async {
    await _repository.updatePet(pet);
    await loadPets();
  }

  Future<void> deletePet(int id) async {
    await _repository.deletePet(id);
    await loadPets();
  }
}

final petsProvider =
    StateNotifierProvider<PetsNotifier, AsyncValue<List<Pet>>>((ref) {
  final repository = ref.watch(petRepositoryProvider);
  return PetsNotifier(repository);
});

// Mascotas filtradas por cliente
final petsByClientProvider =
    FutureProvider.family<List<Pet>, int>((ref, clientId) async {
  final repository = ref.watch(petRepositoryProvider);
  return await repository.getPetsByClientId(clientId);
});
