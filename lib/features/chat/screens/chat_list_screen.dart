import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<Map<String, dynamic>> _conversations = [
    {
      'id': '1',
      'name': 'Kasun Perera',
      'lastMessage': 'See you on Saturday!',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'unread': true,
      'avatar': 'K',
    },
    {
      'id': '2',
      'name': 'Colombo Kings Team',
      'lastMessage': 'New match scheduled for next week',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'unread': true,
      'avatar': 'C',
    },
    {
      'id': '3',
      'name': 'Saman Silva',
      'lastMessage': 'Thanks for the opportunity',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'unread': false,
      'avatar': 'S',
    },
    {
      'id': '4',
      'name': 'Ravi Kumara',
      'lastMessage': 'Practice session confirmed for 3 PM',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'unread': false,
      'avatar': 'R',
    },
    {
      'id': '5',
      'name': 'Nishan Fernando',
      'lastMessage': 'Available for the upcoming tournament',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'unread': false,
      'avatar': 'N',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _conversations.where((c) => c['unread']).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$unreadCount new',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: _conversations.length,
        itemBuilder: (context, index) {
          final conversation = _conversations[index];
          return _ConversationTile(
            conversation: conversation,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    name: conversation['name'],
                    userId: conversation['id'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Map<String, dynamic> conversation;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: conversation['unread']
            ? AppTheme.neonGreen.withOpacity(0.05)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppTheme.neonGreen.withOpacity(0.2),
              child: Text(
                conversation['avatar'],
                style: const TextStyle(
                  color: AppTheme.neonGreen,
                  fontSize: 16,
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
                          conversation['name'],
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: conversation['unread']
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTime(conversation['timestamp']),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 11,
                              color: AppTheme.textGray,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          conversation['lastMessage'],
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textGray,
                                fontSize: 13,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation['unread'])
                        const SizedBox(width: 8),
                      if (conversation['unread'])
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.neonGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      // Removed DateFormat usage to avoid requiring intl package
      return '${timestamp.month}/${timestamp.day}';
    }
  }
}