import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'team_management_screen.dart';

class MyTeamsScreen extends StatefulWidget {
  const MyTeamsScreen({super.key});

  @override
  State<MyTeamsScreen> createState() => _MyTeamsScreenState();
}

class _MyTeamsScreenState extends State<MyTeamsScreen> {
  final List<Map<String, dynamic>> _teams = [
    {
      'id': '1',
      'name': 'Colombo Kings',
      'location': 'Colombo',
      'members': 11,
      'maxMembers': 15,
      'wins': 18,
      'role': 'Captain',
    },
    {
      'id': '2',
      'name': 'Galle Titans',
      'location': 'Galle',
      'members': 12,
      'maxMembers': 15,
      'wins': 15,
      'role': 'Player',
    },
    {
      'id': '3',
      'name': 'Kandy Warriors',
      'location': 'Kandy',
      'members': 10,
      'maxMembers': 15,
      'wins': 12,
      'role': 'Player',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Teams'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTeamDialog();
        },
        backgroundColor: AppTheme.neonGreen,
        child: const Icon(Icons.add, color: AppTheme.navyBlue),
      ),
      body: _teams.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.groups_outlined,
                    size: 80,
                    color: AppTheme.textGray,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No teams yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showCreateTeamDialog();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Team'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _teams.length,
              itemBuilder: (context, index) {
                final team = _teams[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _TeamCard(
                    team: team,
                    onManage: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TeamManagementScreen(
                            teamId: team['id'],
                            teamName: team['name'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showCreateTeamDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Create New Team',
          style: TextStyle(color: AppTheme.textWhite),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter team name',
              style: TextStyle(color: AppTheme.textWhite),
            ),
            const SizedBox(height: 12),
            TextField(
              style: const TextStyle(color: AppTheme.textWhite),
              decoration: InputDecoration(
                hintText: 'Team name',
                hintStyle: TextStyle(
                  color: AppTheme.textGray.withOpacity(0.5),
                ),
                filled: true,
                fillColor: AppTheme.navyBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textGray),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Team created successfully!'),
                  backgroundColor: AppTheme.neonGreen,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final Map<String, dynamic> team;
  final VoidCallback onManage;

  const _TeamCard({
    required this.team,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.glassmorphicDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.neonGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.groups,
                  color: AppTheme.neonGreen,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team['name'],
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: AppTheme.textGray),
                        const SizedBox(width: 4),
                        Text(
                          team['location'],
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                  ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.neonGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            team['role'],
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 10,
                                      color: AppTheme.neonGreen,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.navyBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Members',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${team['members']}/${team['maxMembers']}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.neonGreen,
                          ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Wins',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      team['wins'].toString(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.neonGreen,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkBlue,
                foregroundColor: AppTheme.neonGreen,
              ),
              onPressed: onManage,
              child: const Text('Manage Team'),
            ),
          ),
        ],
      ),
    );
  }
}
