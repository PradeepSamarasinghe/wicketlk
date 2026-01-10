import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class TeamDetailScreen extends StatelessWidget {
  final String teamName;
  final String location;

  const TeamDetailScreen({
    super.key,
    required this.teamName,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teamName),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.neonGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.groups,
                    size: 50,
                    color: AppTheme.neonGreen,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teamName,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: AppTheme.textGray),
                          const SizedBox(width: 4),
                          Text(location),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatCard(label: 'Members', value: '12/15'),
                _StatCard(label: 'Wins', value: '18'),
                _StatCard(label: 'Win Rate', value: '75%'),
              ],
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Join request sent! (Placeholder)'),
                      backgroundColor: AppTheme.neonGreen,
                    ),
                  );
                },
                child: const Text('Request to Join', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Team Description',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Competitive softball team based in $location looking for dedicated players.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: AppTheme.glassmorphicDecoration(),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.neonGreen,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}