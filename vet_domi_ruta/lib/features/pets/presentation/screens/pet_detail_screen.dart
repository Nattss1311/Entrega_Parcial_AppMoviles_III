import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/formatters.dart';
import '../../../appointments/presentation/providers/appointment_providers.dart';
import '../../../appointments/presentation/widgets/appointment_card.dart';
import '../../domain/entities/pet.dart';
import '../providers/pet_providers.dart';
import 'pet_form_screen.dart';

class PetDetailScreen extends ConsumerWidget {
  final Pet pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(appointmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PetFormScreen(pet: pet),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Eliminar',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('¿Eliminar mascota?'),
                  content: const Text(
                      'Esta acción eliminará la ficha de la mascota y sus citas vinculadas.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await ref.read(petsProvider.notifier).deletePet(pet.id!);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mascota eliminada')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ficha Clínica Resumida
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0xFF0F766E).withOpacity(0.12),
                          child: const Icon(Icons.pets, size: 30, color: Color(0xFF0F766E)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pet.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${pet.species} • ${pet.breed}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildRow(Icons.cake_rounded, 'Edad', '${pet.ageYears} años'),
                    const SizedBox(height: 8),
                    _buildRow(Icons.scale_rounded, 'Peso corporal', '${pet.weightKg} Kg'),
                    if (pet.medicalNotes != null && pet.medicalNotes!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildRow(
                        Icons.medical_information_rounded,
                        'Observaciones médicas',
                        pet.medicalNotes!,
                      ),
                    ],
                    const SizedBox(height: 8),
                    _buildRow(
                      Icons.calendar_today_rounded,
                      'Fecha de registro',
                      Formatters.formatDate(pet.createdAt),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Historial de Citas de esta Mascota
            const Text(
              'Historial de Atenciones Veterinarias',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            appointmentsAsync.when(
              data: (list) {
                final petApps = list.where((a) => a.petId == pet.id).toList();
                if (petApps.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('No hay atenciones registradas para esta mascota.'),
                    ),
                  );
                }

                return Column(
                  children: petApps.map((a) => AppointmentCard(appointment: a)).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF0F766E)),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF334155))),
        ),
      ],
    );
  }
}
