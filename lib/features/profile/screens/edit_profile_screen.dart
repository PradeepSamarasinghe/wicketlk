import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import 'package:wicket_lk_new/features/auth/providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late String _selectedRole;
  late String _selectedExperience;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _locationController = TextEditingController(text: user?.location ?? '');
    _selectedRole = user?.role ?? 'Batsman';
    _selectedExperience = user?.experience ?? 'Beginner';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name
            TextField(
              controller: _nameController,
              style: const TextStyle(color: AppTheme.textWhite),
              decoration: InputDecoration(
                hintText: 'Full Name',
                hintStyle: TextStyle(color: AppTheme.textGray.withOpacity(0.5)),
                prefixIcon: const Icon(Icons.person, color: AppTheme.neonGreen),
                filled: true,
                fillColor: AppTheme.darkBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.textGray.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.textGray.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.neonGreen),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Location/District
            TextField(
              controller: _locationController,
              style: const TextStyle(color: AppTheme.textWhite),
              decoration: InputDecoration(
                hintText: 'Location/District',
                hintStyle: TextStyle(color: AppTheme.textGray.withOpacity(0.5)),
                prefixIcon: const Icon(Icons.location_on, color: AppTheme.neonGreen),
                filled: true,
                fillColor: AppTheme.darkBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.textGray.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.textGray.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.neonGreen),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Playing Role Dropdown
            DropdownButtonFormField<String>(
              value: _selectedRole,
              dropdownColor: AppTheme.darkBlue,
              style: const TextStyle(color: AppTheme.textWhite),
              iconEnabledColor: AppTheme.neonGreen,
              decoration: InputDecoration(
                hintText: 'Playing Role',
                prefixIcon: const Icon(Icons.sports_cricket, color: AppTheme.neonGreen),
                filled: true,
                fillColor: AppTheme.darkBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.textGray.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.textGray.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.neonGreen),
                ),
              ),
              items: ['Batsman', 'Bowler', 'All-rounder', 'Keeper']
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRole = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            // Experience Level Dropdown
            DropdownButtonFormField<String>(
              value: _selectedExperience,
              dropdownColor: AppTheme.darkBlue,
              style: const TextStyle(color: AppTheme.textWhite),
              iconEnabledColor: AppTheme.neonGreen,
              decoration: InputDecoration(
                hintText: 'Experience Level',
                prefixIcon: const Icon(Icons.star, color: AppTheme.neonGreen),
                filled: true,
                fillColor: AppTheme.darkBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.textGray.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.textGray.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.neonGreen),
                ),
              ),
              items: ['Beginner', 'Intermediate', 'Advanced', 'Professional']
                  .map((exp) => DropdownMenuItem(
                        value: exp,
                        child: Text(exp),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedExperience = value;
                  });
                }
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.neonGreen,
                  foregroundColor: AppTheme.darkBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  final authProvider = context.read<AuthProvider>();
                  authProvider.updateProfile({
                    'name': _nameController.text.trim(),
                    'location': _locationController.text.trim(),
                    'role': _selectedRole,
                    'experience': _selectedExperience,
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully!'),
                      backgroundColor: AppTheme.neonGreen,
                    ),
                  );
                },
                child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}