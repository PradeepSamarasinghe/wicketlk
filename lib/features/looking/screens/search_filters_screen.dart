// File: lib/features/looking/screens/search_filters_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SearchFiltersScreen extends StatefulWidget {
  const SearchFiltersScreen({super.key});

  @override
  State<SearchFiltersScreen> createState() => _SearchFiltersScreenState();
}

class _SearchFiltersScreenState extends State<SearchFiltersScreen> {
  String _selectedDistrict = 'All Districts';
  String _selectedRole = 'Any Role';
  String _selectedExperience = 'Any Level';

  final List<String> _districts = [
    'All Districts',
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Kandy',
    'Matale',
    'Nuwara Eliya',
    'Galle',
    'Matara',
    'Hambantota',
    // Add more as needed
  ];

  final List<String> _roles = [
    'Any Role',
    'Batsman',
    'Bowler',
    'All-rounder',
    'Keeper',
  ];

  final List<String> _experiences = [
    'Any Level',
    'Beginner',
    'Intermediate',
    'Advanced',
    'Professional',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'District',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedDistrict,
              items: _districts
                  .map((district) => DropdownMenuItem(
                        value: district,
                        child: Text(district),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDistrict = value!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.darkBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.textGray.withOpacity(0.3)),
                ),
              ),
              dropdownColor: AppTheme.darkBlue,
              style: const TextStyle(color: AppTheme.textWhite),
              iconEnabledColor: AppTheme.neonGreen,
            ),
            const SizedBox(height: 24),
            Text(
              'Role',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: _roles
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.darkBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.textGray.withOpacity(0.3)),
                ),
              ),
              dropdownColor: AppTheme.darkBlue,
              style: const TextStyle(color: AppTheme.textWhite),
              iconEnabledColor: AppTheme.neonGreen,
            ),
            const SizedBox(height: 24),
            Text(
              'Experience Level',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedExperience,
              items: _experiences
                  .map((exp) => DropdownMenuItem(
                        value: exp,
                        child: Text(exp),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedExperience = value!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.darkBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.textGray.withOpacity(0.3)),
                ),
              ),
              dropdownColor: AppTheme.darkBlue,
              style: const TextStyle(color: AppTheme.textWhite),
              iconEnabledColor: AppTheme.neonGreen,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.neonGreen,
                  foregroundColor: AppTheme.darkBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // TODO: Apply filters and return/pop with results
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Filters applied! (Placeholder)'),
                      backgroundColor: AppTheme.neonGreen,
                    ),
                  );
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}