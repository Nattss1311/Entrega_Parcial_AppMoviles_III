class Client {
  final int? id;
  final String name;
  final String phone;
  final String address;
  final String zone;
  final String? notes;
  final DateTime createdAt;

  const Client({
    this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.zone,
    this.notes,
    required this.createdAt,
  });

  Client copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? zone,
    String? notes,
    DateTime? createdAt,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      zone: zone ?? this.zone,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
