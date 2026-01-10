import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'create_post_screen.dart';

class LookingPostsScreen extends StatefulWidget {
  const LookingPostsScreen({super.key});

  @override
  State<LookingPostsScreen> createState() => _LookingPostsScreenState();
}

class _LookingPostsScreenState extends State<LookingPostsScreen> {
  final List<Map<String, dynamic>> _posts = [
    {
      'id': '1',
      'title': 'Looking for experienced bowlers',
      'type': 'Looking for Players',
      'description': 'We need experienced bowlers for our tournament team',
      'author': 'Kasun Perera',
      'location': 'Colombo',
      'role': 'Bowler',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'responses': 5,
    },
    {
      'id': '2',
      'title': 'Need a team for weekend match',
      'type': 'Looking for Team',
      'description': 'Looking for a team to play in weekend cricket match',
      'author': 'Saman Silva',
      'location': 'Galle',
      'role': 'Batsman',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'responses': 3,
    },
    {
      'id': '3',
      'title': 'Practice session needed',
      'type': 'Looking for Practice',
      'description': 'Looking for players for a practice session',
      'author': 'Ravi Kumara',
      'location': 'Kandy',
      'role': 'All-rounder',
      'date': DateTime.now().subtract(const Duration(hours: 12)),
      'responses': 8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Looking For Posts'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreatePostScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.neonGreen,
        child: const Icon(Icons.add, color: AppTheme.darkBlue),  // Fixed: navyBlue → darkBlue
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _PostCard(post: post),
          );
        },
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const _PostCard({required this.post});

  String _formatDateTime(DateTime date) {
    // Manual formatting without intl package
    const List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    int hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final ampm = hour >= 12 ? 'PM' : 'AM';
    if (hour == 0) hour = 12;
    if (hour > 12) hour -= 12;

    final month = months[date.month - 1];
    final day = date.day;
    final year = date.year;

    return '$month $day, $year - $hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.glassmorphicDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.neonGreen.withOpacity(0.2),
                child: Text(
                  post['author'].substring(0, 1).toUpperCase(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            post['author'],
                            style: Theme.of(context).textTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.neonGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            post['type'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 11,
                                  color: AppTheme.neonGreen,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateTime(post['date']),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            color: AppTheme.textGray,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post['title'],
            style: Theme.of(context).textTheme.titleLarge,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            post['description'],
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (post['role'] != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.darkBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    post['role'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 11,
                          color: AppTheme.neonGreen,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              const Icon(Icons.location_on, size: 14, color: AppTheme.textGray),
              const SizedBox(width: 4),
              Text(
                post['location'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 16,
                    color: AppTheme.textGray,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post['responses']} responses',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 11,
                          color: AppTheme.textGray,
                        ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkBlue,
                  foregroundColor: AppTheme.neonGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Interest sent!'),
                      backgroundColor: AppTheme.neonGreen,
                    ),
                  );
                },
                child: const Text('Interested', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}