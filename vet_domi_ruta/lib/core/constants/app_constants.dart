import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'VetDomiRuta';
  static const String appTagline = 'Gestión Profesional de Citas y Rutas Veterinarias';

  // Tipos de Servicios con tarifa base sugerida (COP)
  static const Map<String, double> serviceCatalog = {
    'Consulta General a Domicilio': 70000.0,
    'Vacunación Múltiple / Antirrábica': 65000.0,
    'Desparasitación Interna y Externa': 45000.0,
    'Toma de Muestras de Laboratorio': 80000.0,
    'Control y Curaciones Post-quirúrgicas': 60000.0,
    'Peluquería y Estética Canina/Felina': 90000.0,
    'Profilaxis Dental Preventiva': 110000.0,
    'Urgencia Veterinaria Diurna': 130000.0,
  };

  // Estados de una cita
  static const List<String> appointmentStatuses = [
    'Pendiente',
    'En Ruta',
    'Completada',
    'Cancelada',
  ];

  // Especies soportadas
  static const List<String> speciesList = [
    'Canino',
    'Felino',
    'Conejo',
    'Ave',
    'Otro',
  ];

  // Colores de estado
  static Color getStatusColor(String status) {
    switch (status) {
      case 'Pendiente':
        return const Color(0xFFF59E0B); // Amber / Orange
      case 'En Ruta':
        return const Color(0xFF3B82F6); // Blue
      case 'Completada':
        return const Color(0xFF10B981); // Emerald Green
      case 'Cancelada':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  // Iconos de estado
  static IconData getStatusIcon(String status) {
    switch (status) {
      case 'Pendiente':
        return Icons.access_time_rounded;
      case 'En Ruta':
        return Icons.two_wheeler_rounded;
      case 'Completada':
        return Icons.check_circle_rounded;
      case 'Cancelada':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}
