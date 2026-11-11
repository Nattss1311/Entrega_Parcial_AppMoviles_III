import '../entities/appointment.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAppointments();
  Future<List<Appointment>> getTodayAppointments();
  Future<List<Appointment>> getAppointmentsByStatus(String status);
  Future<List<Appointment>> getAppointmentsByClientId(int clientId);
  Future<List<Appointment>> getAppointmentsByPetId(int petId);
  Future<Appointment?> getAppointmentById(int id);
  Future<int> insertAppointment(Appointment appointment);
  Future<int> updateAppointment(Appointment appointment);
  Future<int> updateAppointmentStatus(int id, String status);
  Future<int> deleteAppointment(int id);
  Future<double> getTotalRevenueToday();
}
