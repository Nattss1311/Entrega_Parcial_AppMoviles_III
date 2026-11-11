import 'package:flutter/material.dart';
import '../../domain/entities/pet.dart';
import '../screens/pet_detail_screen.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback? onDelete;

  const PetCard({
    super.key,
    required this.pet,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDog = pet.species.toLowerCase().contains('can') ||
        pet.species.toLowerCase().contains('perr');

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetDetailScreen(pet: pet),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isDog
                      ? const Color(0xFFFEF3C7) // Amber pastel
                      : const Color(0xFFFCE7F3), // Pink pastel
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isDog ? Icons.pets_rounded : Icons.cruelty_free_rounded,
                  color: isDog ? const Color(0xFFD97706) : const Color(0xFFDB2777),
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${pet.species} • ${pet.breed}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.ageYears} años • ${pet.weightKg} kg',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F766E),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
