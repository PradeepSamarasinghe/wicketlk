import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedType = 'Looking for Players';
  String _selectedRole = 'Batsman';
  String _selectedLocation = 'Colombo';
  DateTime? _selectedDate;

  final List<String> _types = [
    'Looking for Players',
    'Looking for Team',
    'Looking for Practice',
  ];

  final List<String> _roles = [
    'Batsman',
    'Bowler',
    'All-rounder',
    'Keeper',
  ];

  final List<String> _locations = [
    'Colombo',
    'Galle',
    'Kandy',
    'Jaffna',
    'Matara',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
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
                'What are you looking for?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _buildTypeSelector(),
              const SizedBox(height: 24),
              Text(
                'Title',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                maxLines: 1,
                style: const TextStyle(color: AppTheme.textWhite),
                decoration: InputDecoration(
                  hintText: 'e.g., Looking for experienced batsman',
                  hintStyle: TextStyle(
                    color: AppTheme.textGray.withOpacity(0.5),
                  ),
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
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                style: const TextStyle(color: AppTheme.textWhite),
                decoration: InputDecoration(
                  hintText: 'Provide details about what you\'re looking for',
                  hintStyle: TextStyle(
                    color: AppTheme.textGray.withOpacity(0.5),
                  ),
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
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (_selectedType == 'Looking for Players') ...[
                Text(
                  'Role Required',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _buildDropdown(
                  value: _selectedRole,
                  items: _roles,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
              ],
              Text(
                'Location',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                value: _selectedLocation,
                items: _locations,
                onChanged: (value) {
                  setState(() {
                    _selectedLocation = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Match/Event Date',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
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
                      _selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.darkBlue,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.textGray.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Select a date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: AppTheme.neonGreen,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Post created successfully!'),
                          backgroundColor: AppTheme.neonGreen,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create Post'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: List.generate(
        _types.length,
        (index) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < _types.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedType = _types[index];
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedType == _types[index]
                      ? AppTheme.neonGreen
                      : AppTheme.darkBlue,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _selectedType == _types[index]
                        ? AppTheme.neonGreen
                        : AppTheme.textGray.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _types[index],
                  style: TextStyle(
                    color: _selectedType == _types[index]
                        ? AppTheme.darkBlue
                        : AppTheme.textWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
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
}
