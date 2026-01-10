import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'Batsman';
  String _selectedExperience = 'Beginner';

  final List<String> _roles = [
    'Batsman',
    'Bowler',
    'All-rounder',
    'Keeper',
  ];

  final List<String> _experience = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Professional',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us about yourself',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Full name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _locationController,
                label: 'District',
                icon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'District is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Primary Role',
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
              Text(
                'Experience Level',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                value: _selectedExperience,
                items: _experience,
                onChanged: (value) {
                  setState(() {
                    _selectedExperience = value;
                  });
                },
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile created successfully!'),
                          backgroundColor: AppTheme.neonGreen,
                        ),
                      );
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home',
                        (route) => false,
                      );
                    }
                  },
                  child: const Text('Complete Profile'),
                ),
              ),
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
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppTheme.textWhite),
      validator: validator,
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppTheme.neonGreen,
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
