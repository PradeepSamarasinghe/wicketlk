import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView(
        children: const [
          _ChatListItem(
            name: 'John Doe',
            lastMessage: 'Hey, are you coming to the match?',
            time: '2m ago',
            unread: true,
          ),
          _ChatListItem(
            name: 'Team Galle',
            lastMessage: 'Practice at 5pm today.',
            time: '1h ago',
            unread: false,
          ),
          _ChatListItem(
            name: 'Saman Silva',
            lastMessage: 'Congrats on the win!',
            time: '3h ago',
            unread: false,
          ),
        ],
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final bool unread;

  const _ChatListItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(name[0]),
      ),
      title: Text(name),
      subtitle: Text(lastMessage),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: TextStyle(fontSize: 12)),
          if (unread)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      onTap: () {
        // TODO: Navigate to chat detail screen
      },
    );
  }
}
