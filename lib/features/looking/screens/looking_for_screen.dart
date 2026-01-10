import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'player_detail_screen.dart';
import 'team_detail_screen.dart';
import 'search_filters_screen.dart';

class LookingForScreen extends StatefulWidget {
  const LookingForScreen({super.key});

  @override
  State<LookingForScreen> createState() => _LookingForScreenState();
}

class _LookingForScreenState extends State<LookingForScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedLocation = 'All Districts';

  final List<Map<String, String>> _players = [
    {
      'name': 'Kasun Perera',
      'role': 'Batsman',
      'location': 'Colombo',
      'experience': 'Advanced',
      'availability': 'Weekends',
    },
    {
      'name': 'Saman Silva',
      'role': 'Bowler',
      'location': 'Galle',
      'experience': 'Intermediate',
      'availability': 'Anytime',
    },
    {
      'name': 'Ravi Kumara',
      'role': 'All-rounder',
      'location': 'Kandy',
      'experience': 'Advanced',
      'availability': 'Weekdays',
    },
    {
      'name': 'Nishan Fernando',
      'role': 'Keeper',
      'location': 'Colombo',
      'experience': 'Intermediate',
      'availability': 'Weekends',
    },
  ];

  final List<Map<String, String>> _teams = [
    {
      'name': 'Colombo Kings',
      'location': 'Colombo',
      'members': '11/15',
      'wins': '18',
    },
    {
      'name': 'Galle Titans',
      'location': 'Galle',
      'members': '12/15',
      'wins': '15',
    },
    {
      'name': 'Kandy Warriors',
      'location': 'Kandy',
      'members': '10/15',
      'wins': '12',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Players & Teams'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.neonGreen,
          labelColor: AppTheme.neonGreen,
          unselectedLabelColor: AppTheme.textGray,
          tabs: const [
            Tab(text: 'Players'),
            Tab(text: 'Teams'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: AppTheme.textWhite),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: AppTheme.textGray.withOpacity(0.5),
                      ),
                      prefixIcon: const Icon(Icons.search,
                          color: AppTheme.neonGreen),
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
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const SearchFiltersScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.neonGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: AppTheme.darkBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPlayersList(),
                _buildTeamsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _players.length,
      itemBuilder: (context, index) {
        final player = _players[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PlayerDetailScreen(
                    playerName: player['name']!,
                    role: player['role']!,
                    location: player['location']!,
                  ),
                ),
              );
            },
            child: Container(
              decoration: AppTheme.glassmorphicDecoration(),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.neonGreen.withOpacity(0.2),
                    child: Text(
                      player['name']!.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.neonGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player['name']!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.neonGreen.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                player['role']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 11,
                                      color: AppTheme.neonGreen,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppTheme.textGray,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              player['location']!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward,
                      color: AppTheme.neonGreen),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeamsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _teams.length,
      itemBuilder: (context, index) {
        final team = _teams[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TeamDetailScreen(
                    teamName: team['name']!,
                    location: team['location']!,
                  ),
                ),
              );
            },
            child: Container(
              decoration: AppTheme.glassmorphicDecoration(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.neonGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.groups,
                          color: AppTheme.neonGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              team['name']!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 14,
                                    color: AppTheme.textGray),
                                const SizedBox(width: 4),
                                Text(
                                  team['location']!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward,
                          color: AppTheme.neonGreen),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _TeamStatBadge(
                        label: 'Members',
                        value: team['members']!,
                      ),
                      _TeamStatBadge(
                        label: 'Wins',
                        value: team['wins']!,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TeamStatBadge extends StatelessWidget {
  final String label;
  final String value;

  const _TeamStatBadge({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 11,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.neonGreen,
            fontSize: 16,
              ),
        ),
      ],
    );
  }
}
