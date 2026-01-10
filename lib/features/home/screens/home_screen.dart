import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'my_matches_screen.dart';
import 'my_tournaments_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wicket.lk'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppTheme.darkBlue,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back, Player!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have 2 upcoming matches',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textGray,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _QuickAccessButton(
                    icon: Icons.sports_cricket,
                    label: 'My Matches',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MyMatchesScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _QuickAccessButton(
                    icon: Icons.emoji_events,
                    label: 'My Tournaments',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MyTournamentsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _QuickAccessButton(
                    icon: Icons.people,
                    label: 'Find Players',
                    onTap: () {
                      Navigator.of(context).pushNamed('/looking');
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: AppTheme.glassmorphicDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ActivityItem(
                          icon: Icons.check_circle,
                          title: 'Match Completed',
                          subtitle: 'Colombo Kings vs Galle - Won',
                          time: '2 days ago',
                        ),
                        const SizedBox(height: 12),
                        _ActivityItem(
                          icon: Icons.person_add,
                          title: 'Player Joined Team',
                          subtitle: 'Saman Silva joined your team',
                          time: '5 days ago',
                        ),
                        const SizedBox(height: 12),
                        _ActivityItem(
                          icon: Icons.emoji_events,
                          title: 'Tournament Started',
                          subtitle: 'Galle Premier League begins',
                          time: '1 week ago',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Quick Stats',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Matches',
                          value: '24',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Runs',
                          value: '1,234',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Wickets',
                          value: '28',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppTheme.glassmorphicDecoration(),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.neonGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.neonGreen),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward, color: AppTheme.neonGreen),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.neonGreen),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: AppTheme.textGray,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          time,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 11,
                color: AppTheme.textGray,
              ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.glassmorphicDecoration(),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.neonGreen,
                ),
          ),
        ],
      ),
    );
  }
}
