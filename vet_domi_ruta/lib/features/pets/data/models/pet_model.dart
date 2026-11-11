import '../../domain/entities/pet.dart';

class PetModel extends Pet {
  const PetModel({
    super.id,
    required super.clientId,
    required super.name,
    required super.species,
    required super.breed,
    required super.ageYears,
    required super.weightKg,
    super.medicalNotes,
    required super.createdAt,
  });

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'] as int?,
      clientId: map['client_id'] as int,
      name: map['name'] as String,
      species: map['species'] as String,
      breed: map['breed'] as String,
      ageYears: map['age_years'] as int,
      weightKg: (map['weight_kg'] as num).toDouble(),
      medicalNotes: map['medical_notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'client_id': clientId,
      'name': name,
      'species': species,
      'breed': breed,
      'age_years': ageYears,
      'weight_kg': weightKg,
      'medical_notes': medicalNotes,
      'created_at': createdAt.toIso8601String(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory PetModel.fromEntity(Pet pet) {
    return PetModel(
      id: pet.id,
      clientId: pet.clientId,
      name: pet.name,
      species: pet.species,
      breed: pet.breed,
      ageYears: pet.ageYears,
      weightKg: pet.weightKg,
      medicalNotes: pet.medicalNotes,
      createdAt: pet.createdAt,
    );
  }
}
