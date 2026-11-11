import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../clients/presentation/providers/client_providers.dart';
import '../../domain/entities/pet.dart';
import '../providers/pet_providers.dart';

class PetFormScreen extends ConsumerStatefulWidget {
  final int? clientId;
  final Pet? pet;

  const PetFormScreen({super.key, this.clientId, this.pet});

  @override
  ConsumerState<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends ConsumerState<PetFormScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedClientId;
  String _selectedSpecies = AppConstants.speciesList.first;

  late final TextEditingController _nameController;
  late final TextEditingController _breedController;
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _medicalNotesController;

  @override
  void initState() {
    super.initState();
    final p = widget.pet;
    _selectedClientId = widget.clientId ?? p?.clientId;
    _selectedSpecies = p?.species ?? AppConstants.speciesList.first;

    _nameController = TextEditingController(text: p?.name ?? '');
    _breedController = TextEditingController(text: p?.breed ?? '');
    _ageController = TextEditingController(text: p?.ageYears.toString() ?? '1');
    _weightController = TextEditingController(text: p?.weightKg.toString() ?? '5.0');
    _medicalNotesController = TextEditingController(text: p?.medicalNotes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _medicalNotesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona el propietario')),
      );
      return;
    }

    final pet = Pet(
      id: widget.pet?.id,
      clientId: _selectedClientId!,
      name: _nameController.text.trim(),
      species: _selectedSpecies,
      breed: _breedController.text.trim(),
      ageYears: int.tryParse(_ageController.text.trim()) ?? 1,
      weightKg: double.tryParse(_weightController.text.trim()) ?? 1.0,
      medicalNotes: _medicalNotesController.text.trim().isEmpty
          ? null
          : _medicalNotesController.text.trim(),
      createdAt: widget.pet?.createdAt ?? DateTime.now(),
    );

    if (widget.pet == null) {
      await ref.read(petsProvider.notifier).addPet(pet);
    } else {
      await ref.read(petsProvider.notifier).updatePet(pet);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.pet == null
              ? 'Mascota registrada con éxito'
              : 'Mascota actualizada con éxito'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet == null ? 'Nueva Mascota' : 'Editar Mascota'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (widget.clientId == null) ...[
                clientsAsync.when(
                  data: (clients) {
                    if (_selectedClientId == null && clients.isNotEmpty) {
                      _selectedClientId = clients.first.id;
                    }
                    return DropdownButtonFormField<int>(
                      value: _selectedClientId,
                      decoration: const InputDecoration(
                        labelText: 'Propietario / Cliente *',
                        prefixIcon: Icon(Icons.person_rounded),
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
                        });
                      },
                      validator: (v) => v == null ? 'Selecciona un cliente' : null,
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Error al cargar clientes'),
                ),
                const SizedBox(height: 14),
              ],
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Mascota *',
                  prefixIcon: Icon(Icons.pets_rounded),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingresa el nombre' : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _selectedSpecies,
                decoration: const InputDecoration(
                  labelText: 'Especie *',
                  prefixIcon: Icon(Icons.category_rounded),
                ),
                items: AppConstants.speciesList.map((sp) {
                  return DropdownMenuItem<String>(
                    value: sp,
                    child: Text(sp),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedSpecies = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(
                  labelText: 'Raza *',
                  prefixIcon: Icon(Icons.bubble_chart_rounded),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingresa la raza' : null,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Edad (Años) *',
                        prefixIcon: Icon(Icons.cake_rounded),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Ingresa la edad' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Peso (Kg) *',
                        prefixIcon: Icon(Icons.scale_rounded),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Ingresa el peso' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _medicalNotesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Alergias, Antecedentes o Notas Clínicas',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.medical_information_rounded),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Guardar Mascota', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
