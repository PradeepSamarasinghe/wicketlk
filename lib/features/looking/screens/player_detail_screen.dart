// File: lib/features/looking/screens/player_detail_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PlayerDetailScreen extends StatelessWidget {
  final String playerName;
  final String role;
  final String location;

  const PlayerDetailScreen({
    super.key,
    required this.playerName,
    required this.role,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playerName),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppTheme.neonGreen.withOpacity(0.2),
                child: Text(
                  playerName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.neonGreen,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              playerName,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.neonGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    role,
                    style: const TextStyle(
                      color: AppTheme.neonGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.location_on, color: AppTheme.textGray, size: 20),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.neonGreen,
                  foregroundColor: AppTheme.darkBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // TODO: Navigate to chat or send interest
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message sent! (Placeholder)'),
                      backgroundColor: AppTheme.neonGreen,
                    ),
                  );
                },
                child: const Text('Send Message', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'About',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Experienced $role from $location. Available for matches and tournaments.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}