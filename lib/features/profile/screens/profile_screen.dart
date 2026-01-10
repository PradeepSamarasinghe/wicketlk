import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import 'package:wicket_lk_new/features/auth/providers/auth_provider.dart';
import 'edit_profile_screen.dart';
import 'analytics_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;

          if (user == null) {
            return Center(
              child: Text(
                'Not logged in',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }

          // Safe access to stats map
          final Map<String, dynamic>? stats = user.stats;
          final double strikeRate = (stats?['strikeRate'] as num?)?.toDouble() ?? 0.0;
          final double average = (stats?['average'] as num?)?.toDouble() ?? 0.0;
          final int matchesPlayed = (stats?['matchesPlayed'] as num?)?.toInt() ?? 0;
          final int runs = (stats?['runs'] as num?)?.toInt() ?? 0;
          final int wickets = (stats?['wickets'] as num?)?.toInt() ?? 0;
          final List<String> badges = (stats?['badges'] as List?)?.cast<String>() ?? [];

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.darkBlue,
                          AppTheme.darkBlue.withOpacity(0.8), // Safer: avoid undefined navyBlue
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.neonGreen.withOpacity(0.2),
                          child: Text(
                            (user.name?.isNotEmpty ?? false)
                                ? user.name!.substring(0, 1).toUpperCase()
                                : 'P', // Fallback if name null/empty
                            style: const TextStyle(
                              fontSize: 40,
                              color: AppTheme.neonGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.name ?? 'Player',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        if (user.location != null && user.location!.isNotEmpty)
                          Text(
                            user.location!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StatsRow(strikeRate: strikeRate, average: average),
                      const SizedBox(height: 24),
                      Text(
                        'Statistics',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Matches',
                              value: matchesPlayed.toString(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'Runs',
                              value: runs.toString(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'Wickets',
                              value: wickets.toString(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AnalyticsScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: AppTheme.glassmorphicDecoration(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.analytics,
                                    color: AppTheme.neonGreen,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'View Analytics',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: AppTheme.neonGreen,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (badges.isNotEmpty) ...[
                        Text(
                          'Badges',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: badges.map((badge) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.neonGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.neonGreen.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: AppTheme.neonGreen,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    badge,
                                    style: const TextStyle(
                                      color: AppTheme.neonGreen,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            authProvider.signOut();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login',
                              (route) => false,
                            );
                          },
                          child: const Text('Sign Out', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final double strikeRate;
  final double average;

  const _StatsRow({required this.strikeRate, required this.average});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: AppTheme.glassmorphicDecoration(),
            child: Column(
              children: [
                Text(
                  strikeRate.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.neonGreen,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Strike Rate',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: AppTheme.glassmorphicDecoration(),
            child: Column(
              children: [
                Text(
                  average.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.neonGreen,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Average',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
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
      padding: const EdgeInsets.all(12),
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }
}