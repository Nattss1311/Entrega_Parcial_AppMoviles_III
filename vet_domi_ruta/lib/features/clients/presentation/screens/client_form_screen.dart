import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/client.dart';
import '../providers/client_providers.dart';

class ClientFormScreen extends ConsumerStatefulWidget {
  final Client? client;

  const ClientFormScreen({super.key, this.client});

  @override
  ConsumerState<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends ConsumerState<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _zoneController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final c = widget.client;
    _nameController = TextEditingController(text: c?.name ?? '');
    _phoneController = TextEditingController(text: c?.phone ?? '');
    _addressController = TextEditingController(text: c?.address ?? '');
    _zoneController = TextEditingController(text: c?.zone ?? '');
    _notesController = TextEditingController(text: c?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _zoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final client = Client(
      id: widget.client?.id,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      zone: _zoneController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      createdAt: widget.client?.createdAt ?? DateTime.now(),
    );

    if (widget.client == null) {
      await ref.read(clientsProvider.notifier).addClient(client);
    } else {
      await ref.read(clientsProvider.notifier).updateClient(client);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.client == null
              ? 'Cliente guardado con éxito'
              : 'Cliente actualizado con éxito'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client == null ? 'Nuevo Cliente' : 'Editar Cliente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo del Propietario *',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingresa el nombre' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono Móvil (WhatsApp) *',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingresa el teléfono' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección Completa de Domicilio *',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingresa la dirección' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _zoneController,
                decoration: const InputDecoration(
                  labelText: 'Zona / Barrio / Localidad *',
                  prefixIcon: Icon(Icons.map_outlined),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingresa la zona' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Instrucciones de Acceso / Notas',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.edit_note_rounded),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Guardar Cliente', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
