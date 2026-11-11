import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/formatters.dart';
import '../../../appointments/presentation/providers/appointment_providers.dart';
import '../../../clients/presentation/providers/client_providers.dart';
import '../../../pets/presentation/providers/pet_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientsProvider);
    final petsAsync = ref.watch(petsProvider);
    final appointmentsAsync = ref.watch(appointmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Métricas & Rendimiento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen Operativo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            // Tarjetas de Métricas Principales (Grid 2x2)
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'Clientes',
                    value: clientsAsync.when(
                      data: (list) => list.length.toString(),
                      loading: () => '...',
                      error: (_, __) => '0',
                    ),
                    icon: Icons.people_alt_rounded,
                    color: const Color(0xFF0F766E),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'Pacientes / Mascotas',
                    value: petsAsync.when(
                      data: (list) => list.length.toString(),
                      loading: () => '...',
                      error: (_, __) => '0',
                    ),
                    icon: Icons.pets_rounded,
                    color: const Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'Total Citas',
                    value: appointmentsAsync.when(
                      data: (list) => list.length.toString(),
                      loading: () => '...',
                      error: (_, __) => '0',
                    ),
                    icon: Icons.event_note_rounded,
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'Completadas',
                    value: appointmentsAsync.when(
                      data: (list) => list
                          .where((a) => a.status == 'Completada')
                          .length
                          .toString(),
                      loading: () => '...',
                      error: (_, __) => '0',
                    ),
                    icon: Icons.check_circle_rounded,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Card Financiero
            appointmentsAsync.when(
              data: (list) {
                final totalBilled = list
                    .where((a) => a.status == 'Completada')
                    .fold<double>(0.0, (sum, a) => sum + a.totalFee);
                final totalPending = list
                    .where((a) => a.status != 'Completada' && a.status != 'Cancelada')
                    .fold<double>(0.0, (sum, a) => sum + a.totalFee);

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
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
                      const Row(
                        children: [
                          Icon(Icons.monetization_on_rounded,
                              color: Color(0xFF0F766E), size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Balance Financiero de Visitas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F766E),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ingresos Cobrados (Completadas):',
                              style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
                          Text(
                            Formatters.formatCurrency(totalBilled),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Por Cobrar (Pendiente / En Ruta):',
                              style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
                          Text(
                            Formatters.formatCurrency(totalPending),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Proyectado:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          Text(
                            Formatters.formatCurrency(totalBilled + totalPending),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F766E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),
            const Text(
              'Arquitectura & Almacenamiento Local',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.storage_rounded, color: Color(0xFF0F766E), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Motor SQLite: vet_domi_ruta.db',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F766E),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Operación 100% Offline-First sin requerir cobertura 4G/5G en el punto de atención. Los datos se almacenan de forma relacional con integridad referencial ON DELETE CASCADE.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
