import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/client_repository_impl.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';

// Provider del Repositorio
final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  return ClientRepositoryImpl();
});

// StateNotifier para la lista de Clientes
class ClientsNotifier extends StateNotifier<AsyncValue<List<Client>>> {
  final ClientRepository _repository;

  ClientsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadClients();
  }

  Future<void> loadClients() async {
    try {
      state = const AsyncValue.loading();
      final clients = await _repository.getClients();
      state = AsyncValue.data(clients);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> searchClients(String query) async {
    if (query.trim().isEmpty) {
      await loadClients();
      return;
    }
    try {
      state = const AsyncValue.loading();
      final clients = await _repository.searchClients(query);
      state = AsyncValue.data(clients);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<int> addClient(Client client) async {
    final id = await _repository.insertClient(client);
    await loadClients();
    return id;
  }

  Future<void> updateClient(Client client) async {
    await _repository.updateClient(client);
    await loadClients();
  }

  Future<void> deleteClient(int id) async {
    await _repository.deleteClient(id);
    await loadClients();
  }
}

final clientsProvider =
    StateNotifierProvider<ClientsNotifier, AsyncValue<List<Client>>>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return ClientsNotifier(repository);
});

// Provider para obtener un cliente específico por ID
final clientDetailProvider =
    FutureProvider.family<Client?, int>((ref, clientId) async {
  final repository = ref.watch(clientRepositoryProvider);
  return await repository.getClientById(clientId);
});
