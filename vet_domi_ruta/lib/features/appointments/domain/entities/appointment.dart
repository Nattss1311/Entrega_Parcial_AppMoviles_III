class Appointment {
  final int? id;
  final int petId;
  final int clientId;
  final String serviceType;
  final DateTime appointmentDate;
  final String status;
  final double baseFee;
  final double transportFee;
  final double totalFee;
  final String address;
  final String? notes;
  final DateTime createdAt;

  // Campos opcionales enriquecidos con JOIN relacional
  final String? clientName;
  final String? clientPhone;
  final String? petName;
  final String? petSpecies;
  final String? petBreed;
  final String? clientZone;

  const Appointment({
    this.id,
    required this.petId,
    required this.clientId,
    required this.serviceType,
    required this.appointmentDate,
    required this.status,
    required this.baseFee,
    required this.transportFee,
    required this.totalFee,
    required this.address,
    this.notes,
    required this.createdAt,
    this.clientName,
    this.clientPhone,
    this.petName,
    this.petSpecies,
    this.petBreed,
    this.clientZone,
  });

  Appointment copyWith({
    int? id,
    int? petId,
    int? clientId,
    String? serviceType,
    DateTime? appointmentDate,
    String? status,
    double? baseFee,
    double? transportFee,
    double? totalFee,
    String? address,
    String? notes,
    DateTime? createdAt,
    String? clientName,
    String? clientPhone,
    String? petName,
    String? petSpecies,
    String? petBreed,
    String? clientZone,
  }) {
    return Appointment(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      clientId: clientId ?? this.clientId,
      serviceType: serviceType ?? this.serviceType,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      status: status ?? this.status,
      baseFee: baseFee ?? this.baseFee,
      transportFee: transportFee ?? this.transportFee,
      totalFee: totalFee ?? this.totalFee,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      petName: petName ?? this.petName,
      petSpecies: petSpecies ?? this.petSpecies,
      petBreed: petBreed ?? this.petBreed,
      clientZone: clientZone ?? this.clientZone,
    );
  }
}
