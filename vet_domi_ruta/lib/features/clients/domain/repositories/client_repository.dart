import '../entities/client.dart';

abstract class ClientRepository {
  Future<List<Client>> getClients();
  Future<Client?> getClientById(int id);
  Future<int> insertClient(Client client);
  Future<int> updateClient(Client client);
  Future<int> deleteClient(int id);
  Future<List<Client>> searchClients(String query);
}
