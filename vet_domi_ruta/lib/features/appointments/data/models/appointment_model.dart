import '../../domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    super.id,
    required super.petId,
    required super.clientId,
    required super.serviceType,
    required super.appointmentDate,
    required super.status,
    required super.baseFee,
    required super.transportFee,
    required super.totalFee,
    required super.address,
    super.notes,
    required super.createdAt,
    super.clientName,
    super.clientPhone,
    super.petName,
    super.petSpecies,
    super.petBreed,
    super.clientZone,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] as int?,
      petId: map['pet_id'] as int,
      clientId: map['client_id'] as int,
      serviceType: map['service_type'] as String,
      appointmentDate: DateTime.parse(map['appointment_date'] as String),
      status: map['status'] as String,
      baseFee: (map['base_fee'] as num).toDouble(),
      transportFee: (map['transport_fee'] as num).toDouble(),
      totalFee: (map['total_fee'] as num).toDouble(),
      address: map['address'] as String,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      clientName: map['client_name'] as String?,
      clientPhone: map['client_phone'] as String?,
      petName: map['pet_name'] as String?,
      petSpecies: map['pet_species'] as String?,
      petBreed: map['pet_breed'] as String?,
      clientZone: map['client_zone'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'pet_id': petId,
      'client_id': clientId,
      'service_type': serviceType,
      'appointment_date': appointmentDate.toIso8601String(),
      'status': status,
      'base_fee': baseFee,
      'transport_fee': transportFee,
      'total_fee': totalFee,
      'address': address,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory AppointmentModel.fromEntity(Appointment app) {
    return AppointmentModel(
      id: app.id,
      petId: app.petId,
      clientId: app.clientId,
      serviceType: app.serviceType,
      appointmentDate: app.appointmentDate,
      status: app.status,
      baseFee: app.baseFee,
      transportFee: app.transportFee,
      totalFee: app.totalFee,
      address: app.address,
      notes: app.notes,
      createdAt: app.createdAt,
      clientName: app.clientName,
      clientPhone: app.clientPhone,
      petName: app.petName,
      petSpecies: app.petSpecies,
      petBreed: app.petBreed,
      clientZone: app.clientZone,
    );
  }
}
