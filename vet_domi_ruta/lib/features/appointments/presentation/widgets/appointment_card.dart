import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/appointment.dart';
import '../screens/appointment_detail_screen.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final Function(String newStatus)? onStatusChanged;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = AppConstants.getStatusColor(appointment.status);
    final statusIcon = AppConstants.getStatusIcon(appointment.status);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor.withOpacity(0.3), width: 1.2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentDetailScreen(appointment: appointment),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado: Paciente y Estado
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.petName != null
                              ? '${appointment.petName} (${appointment.petBreed ?? ""})'
                              : 'Paciente #${appointment.petId}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Propietario: ${appointment.clientName ?? "Cliente #${appointment.clientId}"}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Menú contextual de cambio rápido de estado
                  PopupMenuButton<String>(
                    tooltip: 'Cambiar estado',
                    initialValue: appointment.status,
                    onSelected: (newStatus) {
                      if (onStatusChanged != null) {
                        onStatusChanged!(newStatus);
                      }
                    },
                    itemBuilder: (context) => AppConstants.appointmentStatuses
                        .map(
                          (status) => PopupMenuItem<String>(
                            value: status,
                            child: Row(
                              children: [
                                Icon(
                                  AppConstants.getStatusIcon(status),
                                  color: AppConstants.getStatusColor(status),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(status),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            appointment.status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down, size: 16, color: statusColor),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Servicio solicitado
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.medical_services_outlined, size: 16, color: Color(0xFF0F766E)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appointment.serviceType,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Dirección y Hora
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 15, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    Formatters.formatTime(appointment.appointmentDate),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.location_on_outlined, size: 15, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      appointment.address,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 0.8),
              // Tarifa total y Desglose
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Base: ${Formatters.formatCurrency(appointment.baseFee)} + Ruta: ${Formatters.formatCurrency(appointment.transportFee)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    Formatters.formatCurrency(appointment.totalFee),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F766E),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
