import '../../domain/entities/client.dart';

class ClientModel extends Client {
  const ClientModel({
    super.id,
    required super.name,
    required super.phone,
    required super.address,
    required super.zone,
    super.notes,
    required super.createdAt,
  });

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      zone: map['zone'] as String,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'phone': phone,
      'address': address,
      'zone': zone,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory ClientModel.fromEntity(Client client) {
    return ClientModel(
      id: client.id,
      name: client.name,
      phone: client.phone,
      address: client.address,
      zone: client.zone,
      notes: client.notes,
      createdAt: client.createdAt,
    );
  }
}
