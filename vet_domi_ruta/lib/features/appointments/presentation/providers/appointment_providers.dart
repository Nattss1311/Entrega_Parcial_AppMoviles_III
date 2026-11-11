import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/appointment_repository_impl.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepositoryImpl();
});

// Filtro seleccionado en la agenda ('Todos', 'Hoy', 'Pendiente', 'En Ruta', 'Completada')
final appointmentFilterProvider = StateProvider<String>((ref) => 'Hoy');

class AppointmentsNotifier extends StateNotifier<AsyncValue<List<Appointment>>> {
  final AppointmentRepository _repository;

  AppointmentsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      state = const AsyncValue.loading();
      final appointments = await _repository.getAppointments();
      state = AsyncValue.data(appointments);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    await _repository.insertAppointment(appointment);
    await loadAppointments();
  }

  Future<void> updateAppointment(Appointment appointment) async {
    await _repository.updateAppointment(appointment);
    await loadAppointments();
  }

  Future<void> updateStatus(int id, String newStatus) async {
    await _repository.updateAppointmentStatus(id, newStatus);
    await loadAppointments();
  }

  Future<void> deleteAppointment(int id) async {
    await _repository.deleteAppointment(id);
    await loadAppointments();
  }
}

final appointmentsProvider =
    StateNotifierProvider<AppointmentsNotifier, AsyncValue<List<Appointment>>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return AppointmentsNotifier(repository);
});

// Citas filtradas según el filtro seleccionado
final filteredAppointmentsProvider = Provider<AsyncValue<List<Appointment>>>((ref) {
  final appointmentsAsync = ref.watch(appointmentsProvider);
  final filter = ref.watch(appointmentFilterProvider);

  return appointmentsAsync.whenData((list) {
    final now = DateTime.now();
    switch (filter) {
      case 'Hoy':
        return list.where((a) =>
            a.appointmentDate.year == now.year &&
            a.appointmentDate.month == now.month &&
            a.appointmentDate.day == now.day).toList();
      case 'Pendiente':
        return list.where((a) => a.status == 'Pendiente').toList();
      case 'En Ruta':
        return list.where((a) => a.status == 'En Ruta').toList();
      case 'Completada':
        return list.where((a) => a.status == 'Completada').toList();
      case 'Todos':
      default:
        return list;
    }
  });
});

// Resumen de ingresos y estadísticas del día
final todayRevenueProvider = FutureProvider<double>((ref) async {
  // Observa appointmentsProvider para refrescarse cuando cambie el estado
  ref.watch(appointmentsProvider);
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.getTotalRevenueToday();
});

// Citas de un cliente
final clientAppointmentsProvider =
    FutureProvider.family<List<Appointment>, int>((ref, clientId) async {
  ref.watch(appointmentsProvider);
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.getAppointmentsByClientId(clientId);
});
