import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedFormat = 'T20';
  String _selectedType = 'League';
  int _numberOfTeams = 4;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _formats = ['T20', 'ODI', '50 Overs', 'Test'];
  final List<String> _types = ['League', 'Knockout', 'Round Robin'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Tournament'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tournament Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'Tournament Name',
                icon: Icons.emoji_events,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _locationController,
                label: 'Location',
                icon: Icons.location_on,
              ),
              const SizedBox(height: 24),
              Text(
                'Format',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                value: _selectedFormat,
                items: _formats,
                onChanged: (value) {
                  setState(() {
                    _selectedFormat = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Tournament Type',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                value: _selectedType,
                items: _types,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Number of Teams',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.darkBlue,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.textGray.withOpacity(0.3),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove,
                          color: AppTheme.neonGreen),
                      onPressed: () {
                        setState(() {
                          if (_numberOfTeams > 2) _numberOfTeams--;
                        });
                      },
                    ),
                    Text(
                      '$_numberOfTeams Teams',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: AppTheme.neonGreen),
                      onPressed: () {
                        setState(() {
                          if (_numberOfTeams < 16) _numberOfTeams++;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Tournament Dates',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      label: 'Start Date',
                      date: _startDate,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: AppTheme.neonGreen,
                                  surface: AppTheme.darkBlue,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            _startDate = picked;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDatePicker(
                      label: 'End Date',
                      date: _endDate,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate:
                              _startDate ?? DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: AppTheme.neonGreen,
                                  surface: AppTheme.darkBlue,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            _endDate = picked;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _startDate != null &&
                        _endDate != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tournament created successfully!'),
                          backgroundColor: AppTheme.neonGreen,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create Tournament'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: AppTheme.textWhite),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppTheme.textGray.withOpacity(0.7),
        ),
        prefixIcon: Icon(icon, color: AppTheme.neonGreen),
        filled: true,
        fillColor: AppTheme.darkBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppTheme.textGray.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppTheme.textGray.withOpacity(0.3),
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.darkBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.textGray.withOpacity(0.3),
        ),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        dropdownColor: AppTheme.darkBlue,
        style: const TextStyle(color: AppTheme.textWhite),
        iconEnabledColor: AppTheme.neonGreen,
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.darkBlue,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.textGray.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 11,
                    color: AppTheme.textGray,
                  ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date == null
                      ? 'Select date'
                      : '${date.day}/${date.month}/${date.year}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Icon(Icons.calendar_today,
                    color: AppTheme.neonGreen, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
