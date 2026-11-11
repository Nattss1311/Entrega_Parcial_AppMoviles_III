import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../clients/presentation/providers/client_providers.dart';
import '../../../pets/presentation/providers/pet_providers.dart';
import '../../domain/entities/appointment.dart';
import '../providers/appointment_providers.dart';

class AppointmentFormScreen extends ConsumerStatefulWidget {
  final Appointment? appointment;

  const AppointmentFormScreen({super.key, this.appointment});

  @override
  ConsumerState<AppointmentFormScreen> createState() =>
      _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends ConsumerState<AppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedClientId;
  int? _selectedPetId;
  String _selectedService = AppConstants.serviceCatalog.keys.first;
  String _selectedStatus = 'Pendiente';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  late final TextEditingController _addressController;
  late final TextEditingController _baseFeeController;
  late final TextEditingController _transportFeeController;
  late final TextEditingController _notesController;

  double _totalFee = 0.0;

  @override
  void initState() {
    super.initState();
    final app = widget.appointment;

    if (app != null) {
      _selectedClientId = app.clientId;
      _selectedPetId = app.petId;
      _selectedService = app.serviceType;
      _selectedStatus = app.status;
      _selectedDate = app.appointmentDate;
      _selectedTime = TimeOfDay.fromDateTime(app.appointmentDate);

      _addressController = TextEditingController(text: app.address);
      _baseFeeController =
          TextEditingController(text: app.baseFee.toStringAsFixed(0));
      _transportFeeController =
          TextEditingController(text: app.transportFee.toStringAsFixed(0));
      _notesController = TextEditingController(text: app.notes ?? '');
      _totalFee = app.totalFee;
    } else {
      _addressController = TextEditingController();
      final defaultBaseFee =
          AppConstants.serviceCatalog[_selectedService] ?? 70000.0;
      _baseFeeController =
          TextEditingController(text: defaultBaseFee.toStringAsFixed(0));
      _transportFeeController = TextEditingController(text: '20000');
      _notesController = TextEditingController();
      _calculateTotal();
    }
  }

  void _calculateTotal() {
    final base = double.tryParse(_baseFeeController.text.replaceAll(',', '')) ?? 0.0;
    final transport =
        double.tryParse(_transportFeeController.text.replaceAll(',', '')) ?? 0.0;
    setState(() {
      _totalFee = base + transport;
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _baseFeeController.dispose();
    _transportFeeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedClientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un cliente.')),
      );
      return;
    }

    if (_selectedPetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una mascota.')),
      );
      return;
    }

    final appointmentDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final baseFee = double.tryParse(_baseFeeController.text.trim()) ?? 0.0;
    final transportFee = double.tryParse(_transportFeeController.text.trim()) ?? 0.0;
    final totalFee = baseFee + transportFee;

    final newAppointment = Appointment(
      id: widget.appointment?.id,
      clientId: _selectedClientId!,
      petId: _selectedPetId!,
      serviceType: _selectedService,
      appointmentDate: appointmentDateTime,
      status: _selectedStatus,
      baseFee: baseFee,
      transportFee: transportFee,
      totalFee: totalFee,
      address: _addressController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      createdAt: widget.appointment?.createdAt ?? DateTime.now(),
    );

    if (widget.appointment == null) {
      await ref.read(appointmentsProvider.notifier).addAppointment(newAppointment);
    } else {
      await ref.read(appointmentsProvider.notifier).updateAppointment(newAppointment);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.appointment == null
                ? '¡Cita a domicilio programada con éxito!'
                : 'Cita actualizada correctamente.',
          ),
          backgroundColor: const Color(0xFF0F766E),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appointment == null
            ? 'Programar Visita a Domicilio'
            : 'Editar Cita'),
      ),
      body: clientsAsync.when(
        data: (clients) {
          if (clients.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people_outline, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No tienes clientes registrados aún',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Debes agregar al menos un cliente y su mascota para programar una visita.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Volver'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Si no hay cliente seleccionado, inicializar con el primero
          if (_selectedClientId == null && clients.isNotEmpty) {
            _selectedClientId = clients.first.id;
            _addressController.text = clients.first.address;
          }

          final petsAsync = ref.watch(petsByClientProvider(_selectedClientId ?? 0));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección 1: Selección de Cliente y Mascota
                  _buildSectionHeader('1. Datos del Paciente y Propietario', Icons.pets),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: _selectedClientId,
                    decoration: const InputDecoration(
                      labelText: 'Propietario / Cliente *',
                      prefixIcon: Icon(Icons.person),
                    ),
                    items: clients.map((c) {
                      return DropdownMenuItem<int>(
                        value: c.id,
                        child: Text('${c.name} (${c.zone})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedClientId = val;
                        _selectedPetId = null; // Reiniciar mascota
                        final client = clients.firstWhere((c) => c.id == val);
                        _addressController.text = client.address;
                      });
                    },
                    validator: (v) => v == null ? 'Selecciona un cliente' : null,
                  ),
                  const SizedBox(height: 14),

                  // Dropdown de Mascotas según el cliente
                  petsAsync.when(
                    data: (pets) {
                      if (pets.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.amber.shade300),
                          ),
                          child: const Text(
                            'Este cliente no tiene mascotas registradas. Añade una mascota antes de agendar.',
                            style: TextStyle(color: Colors.brown, fontSize: 13),
                          ),
                        );
                      }

                      if (_selectedPetId == null || !pets.any((p) => p.id == _selectedPetId)) {
                        _selectedPetId = pets.first.id;
                      }

                      return DropdownButtonFormField<int>(
                        value: _selectedPetId,
                        decoration: const InputDecoration(
                          labelText: 'Mascota / Paciente *',
                          prefixIcon: Icon(Icons.cruelty_free),
                        ),
                        items: pets.map((p) {
                          return DropdownMenuItem<int>(
                            value: p.id,
                            child: Text('${p.name} (${p.species} - ${p.breed})'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedPetId = val;
                          });
                        },
                        validator: (v) => v == null ? 'Selecciona una mascota' : null,
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const Text('Error al cargar mascotas del cliente'),
                  ),

                  const SizedBox(height: 24),
                  // Sección 2: Servicio y Tarifas
                  _buildSectionHeader('2. Servicio y Liquidación de Ruta', Icons.attach_money),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedService,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Servicio Veterinario *',
                      prefixIcon: Icon(Icons.medical_services_rounded),
                    ),
                    items: AppConstants.serviceCatalog.keys.map((serv) {
                      return DropdownMenuItem<String>(
                        value: serv,
                        child: Text(serv, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedService = val;
                          final suggestedFee = AppConstants.serviceCatalog[val] ?? 70000.0;
                          _baseFeeController.text = suggestedFee.toStringAsFixed(0);
                          _calculateTotal();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _baseFeeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Tarifa Base (COP) *',
                            prefixIcon: Icon(Icons.price_check),
                          ),
                          onChanged: (_) => _calculateTotal(),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Requerido' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _transportFeeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Costo Ruta/Domi *',
                            prefixIcon: Icon(Icons.two_wheeler_rounded),
                          ),
                          onChanged: (_) => _calculateTotal(),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Requerido' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL LIQUIDADO:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF166534),
                          ),
                        ),
                        Text(
                          Formatters.formatCurrency(_totalFee),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF166534),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Sección 3: Fecha, Hora y Ubicación
                  _buildSectionHeader('3. Fecha, Horario y Destino', Icons.map_rounded),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Fecha de Visita',
                              prefixIcon: Icon(Icons.calendar_today_rounded),
                            ),
                            child: Text(Formatters.formatDate(_selectedDate)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: _pickTime,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Hora Estimada',
                              prefixIcon: Icon(Icons.access_time_rounded),
                            ),
                            child: Text(_selectedTime.format(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Dirección de Visita a Domicilio *',
                      prefixIcon: Icon(Icons.home_work_rounded),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Ingresa la dirección' : null,
                  ),
                  const SizedBox(height: 14),

                  // Estado de la Cita
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Estado de la Cita *',
                      prefixIcon: Icon(Icons.flag_rounded),
                    ),
                    items: AppConstants.appointmentStatuses.map((st) {
                      return DropdownMenuItem<String>(
                        value: st,
                        child: Text(st),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedStatus = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 14),

                  // Observaciones
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notas de Campo / Instrucciones de Llegada',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.note_alt_rounded),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botón de Guardar
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _saveAppointment,
                      icon: const Icon(Icons.check_circle_rounded),
                      label: Text(
                        widget.appointment == null
                            ? 'Agendar Cita a Domicilio'
                            : 'Actualizar Cita',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
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
    );
  }
}
