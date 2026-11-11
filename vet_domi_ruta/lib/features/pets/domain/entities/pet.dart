class Pet {
  final int? id;
  final int clientId;
  final String name;
  final String species;
  final String breed;
  final int ageYears;
  final double weightKg;
  final String? medicalNotes;
  final DateTime createdAt;

  const Pet({
    this.id,
    required this.clientId,
    required this.name,
    required this.species,
    required this.breed,
    required this.ageYears,
    required this.weightKg,
    this.medicalNotes,
    required this.createdAt,
  });

  Pet copyWith({
    int? id,
    int? clientId,
    String? name,
    String? species,
    String? breed,
    int? ageYears,
    double? weightKg,
    String? medicalNotes,
    DateTime? createdAt,
  }) {
    return Pet(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      ageYears: ageYears ?? this.ageYears,
      weightKg: weightKg ?? this.weightKg,
      medicalNotes: medicalNotes ?? this.medicalNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
