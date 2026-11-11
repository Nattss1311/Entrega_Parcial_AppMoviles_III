import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/appointment.dart';
import '../providers/appointment_providers.dart';
import 'appointment_form_screen.dart';

class AppointmentDetailScreen extends ConsumerWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = AppConstants.getStatusColor(appointment.status);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Cita'),
        actions: [
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AppointmentFormScreen(appointment: appointment),
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
                  title: const Text('¿Eliminar cita?'),
                  content: const Text(
                      'Esta acción no se puede deshacer. ¿Deseas eliminar la cita agendada?'),
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
                await ref
                    .read(appointmentsProvider.notifier)
                    .deleteAppointment(appointment.id!);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cita eliminada correctamente')),
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
            // Banner de Estado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: statusColor, width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(AppConstants.getStatusIcon(appointment.status),
                      color: statusColor, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estado: ${appointment.status}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                        Text(
                          'Fecha: ${Formatters.formatDateTime(appointment.appointmentDate)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Cambiar Estado Rápido
            const Text(
              'Actualizar Progreso de Ruta:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: AppConstants.appointmentStatuses.map((st) {
                final isCurrent = appointment.status == st;
                final col = AppConstants.getStatusColor(st);
                return ChoiceChip(
                  label: Text(st),
                  selected: isCurrent,
                  selectedColor: col,
                  labelStyle: TextStyle(
                    color: isCurrent ? Colors.white : Colors.black87,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (val) {
                    if (val && !isCurrent) {
                      ref
                          .read(appointmentsProvider.notifier)
                          .updateStatus(appointment.id!, st);
                      Navigator.pop(context);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Detalle de Servicio y Finanzas
            _buildInfoCard(
              title: 'Liquidación del Servicio',
              icon: Icons.payments_rounded,
              children: [
                _buildInfoRow('Servicio Veterinario', appointment.serviceType),
                _buildInfoRow('Tarifa Base Consulta/Procedimiento',
                    Formatters.formatCurrency(appointment.baseFee)),
                _buildInfoRow('Recargo Desplazamiento / Ruta',
                    Formatters.formatCurrency(appointment.transportFee)),
                const Divider(),
                _buildInfoRow(
                  'VALOR TOTAL A COBRAR',
                  Formatters.formatCurrency(appointment.totalFee),
                  isBold: true,
                  valueColor: const Color(0xFF0F766E),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Detalle del Paciente y Propietario
            _buildInfoCard(
              title: 'Paciente y Ubicación',
              icon: Icons.pets_rounded,
              children: [
                _buildInfoRow('Paciente',
                    '${appointment.petName ?? "ID ${appointment.petId}"} (${appointment.petSpecies ?? ""} - ${appointment.petBreed ?? ""})'),
                _buildInfoRow('Propietario',
                    appointment.clientName ?? 'ID #${appointment.clientId}'),
                if (appointment.clientPhone != null)
                  _buildInfoRow('Teléfono Contacto', appointment.clientPhone!),
                _buildInfoRow('Dirección de Domicilio', appointment.address),
                if (appointment.clientZone != null)
                  _buildInfoRow('Zona Geográfica', appointment.clientZone!),
              ],
            ),

            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Notas e Instrucciones de Campo',
                icon: Icons.notes_rounded,
                children: [
                  Text(
                    appointment.notes!,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF334155)),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF0F766E)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F766E),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: valueColor ?? const Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
