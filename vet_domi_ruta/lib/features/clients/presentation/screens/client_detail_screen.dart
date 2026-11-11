import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/formatters.dart';
import '../../../appointments/presentation/providers/appointment_providers.dart';
import '../../../appointments/presentation/widgets/appointment_card.dart';
import '../../../pets/presentation/providers/pet_providers.dart';
import '../../../pets/presentation/screens/pet_form_screen.dart';
import '../../../pets/presentation/widgets/pet_card.dart';
import '../providers/client_providers.dart';
import 'client_form_screen.dart';

class ClientDetailScreen extends ConsumerWidget {
  final int clientId;

  const ClientDetailScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientAsync = ref.watch(clientDetailProvider(clientId));
    final petsAsync = ref.watch(petsByClientProvider(clientId));
    final appointmentsAsync = ref.watch(clientAppointmentsProvider(clientId));

    return clientAsync.when(
      data: (client) {
        if (client == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cliente no encontrado')),
            body: const Center(child: Text('El cliente fue eliminado.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(client.name),
            actions: [
              IconButton(
                tooltip: 'Editar',
                icon: const Icon(Icons.edit_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientFormScreen(client: client),
                    ),
                  ).then((_) {
                    final _ = ref.refresh(clientDetailProvider(clientId));
                  });
                },
              ),
              IconButton(
                tooltip: 'Eliminar',
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('¿Eliminar cliente?'),
                      content: const Text(
                        'Esta acción borrará al cliente y, por integridad referencial (CASCADE), también a todas sus mascotas y citas asociadas.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Eliminar Todo'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await ref.read(clientsProvider.notifier).deleteClient(client.id!);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cliente y registros asociados eliminados')),
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
                // Tarjeta de Información de Contacto
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
                              radius: 26,
                              backgroundColor: const Color(0xFF0F766E).withOpacity(0.15),
                              child: Text(
                                client.name[0],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F766E),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    client.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    client.zone,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0284C7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildRow(Icons.phone_rounded, 'Teléfono', client.phone),
                        const SizedBox(height: 8),
                        _buildRow(Icons.location_on_rounded, 'Dirección', client.address),
                        if (client.notes != null && client.notes!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _buildRow(Icons.notes_rounded, 'Notas', client.notes!),
                        ],
                        const SizedBox(height: 8),
                        _buildRow(
                          Icons.calendar_today_rounded,
                          'Cliente desde',
                          Formatters.formatDate(client.createdAt),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sección: Mascotas Registradas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mascotas Registradas',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PetFormScreen(clientId: client.id!),
                          ),
                        ).then((_) {
                          final _ = ref.refresh(petsByClientProvider(clientId));
                        });
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Añadir Mascota'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                petsAsync.when(
                  data: (pets) {
                    if (pets.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('No hay mascotas registradas para este cliente.'),
                        ),
                      );
                    }
                    return Column(
                      children: pets.map((p) => PetCard(pet: p)).toList(),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error al cargar mascotas: $e'),
                ),

                const SizedBox(height: 24),

                // Sección: Historial de Citas
                const Text(
                  'Historial de Visitas a Domicilio',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                appointmentsAsync.when(
                  data: (appointments) {
                    if (appointments.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('No hay visitas registradas para este cliente.'),
                        ),
                      );
                    }
                    return Column(
                      children: appointments
                          .map((a) => AppointmentCard(appointment: a))
                          .toList(),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error al cargar citas: $e'),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
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
