import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class TeamManagementScreen extends StatefulWidget {
  final String teamId;
  final String teamName;

  const TeamManagementScreen({
    super.key,
    required this.teamId,
    required this.teamName,
  });

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _members = [
    {'name': 'You', 'role': 'Captain', 'status': 'Active'},
    {'name': 'Kasun Perera', 'role': 'Batsman', 'status': 'Active'},
    {'name': 'Saman Silva', 'role': 'Bowler', 'status': 'Active'},
    {'name': 'Ravi Kumara', 'role': 'All-rounder', 'status': 'Active'},
  ];

  final List<Map<String, String>> _pendingRequests = [
    {'name': 'Nishan Fernando', 'role': 'Keeper', 'status': 'Pending'},
    {'name': 'Ajith Kumar', 'role': 'Batsman', 'status': 'Pending'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: Text('${widget.teamName} Management'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.neonGreen,
          labelColor: AppTheme.neonGreen,
          unselectedLabelColor: AppTheme.textGray,
          tabs: const [
            Tab(text: 'Members'),
            Tab(text: 'Requests'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMembersTab(),
          _buildRequestsTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  Widget _buildMembersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _members.length,
      itemBuilder: (context, index) {
        final member = _members[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: AppTheme.glassmorphicDecoration(),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.neonGreen.withOpacity(0.2),
                  child: Text(
                    member['name']!.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.neonGreen,
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
                        member['name']!,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
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
                              member['role']!,
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
                          const Icon(Icons.check_circle,
                              size: 14, color: AppTheme.neonGreen),
                        ],
                      ),
                    ],
                  ),
                ),
                if (member['name'] != 'You')
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {},
                        child: const Text('Change Role'),
                      ),
                      PopupMenuItem(
                        onTap: () {},
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pendingRequests.length,
      itemBuilder: (context, index) {
        final request = _pendingRequests[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: AppTheme.glassmorphicDecoration(),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.neonGreen.withOpacity(0.2),
                      child: Text(
                        request['name']!.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.neonGreen,
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
                            request['name']!,
                            style:
                                Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            request['role']!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _pendingRequests.removeAt(index);
                          });
                        },
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _members.add({
                              'name': request['name']!,
                              'role': request['role']!,
                              'status': 'Active',
                            });
                            _pendingRequests.removeAt(index);
                          });
                        },
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SettingTile(
          title: 'Team Name',
          value: widget.teamName,
          onTap: () {},
        ),
        _SettingTile(
          title: 'Description',
          value: 'A competitive cricket team',
          onTap: () {},
        ),
        _SettingTile(
          title: 'Location',
          value: 'Colombo',
          onTap: () {},
        ),
        _SettingTile(
          title: 'Players Limit',
          value: '15',
          onTap: () {},
        ),
        const SizedBox(height: 24),
        Text(
          'Danger Zone',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.red,
              ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.2),
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              _showDeleteDialog();
            },
            child: const Text('Delete Team'),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        title: const Text(
          'Delete Team',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
          'Are you sure you want to delete ${widget.teamName}? This action cannot be undone.',
          style: const TextStyle(color: AppTheme.textWhite),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _SettingTile({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppTheme.glassmorphicDecoration(),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textGray,
                      ),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward, color: AppTheme.neonGreen),
          ],
        ),
      ),
    );
  }
}
