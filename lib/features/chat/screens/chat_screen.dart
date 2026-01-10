import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String userId;

  const ChatScreen({
    super.key,
    required this.name,
    required this.userId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'sender': 'other',
      'text': 'Hi, are you available for Saturday?',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '2',
      'sender': 'me',
      'text': 'Yes, I\'m available',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2, minutes: 1)),
    },
    {
      'id': '3',
      'sender': 'other',
      'text': 'Great! See you at 3 PM then',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
    },
    {
      'id': '4',
      'sender': 'other',
      'text': 'See you on Saturday!',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'id': DateTime.now().toString(),
        'sender': 'me',
        'text': _messageController.text,
        'timestamp': DateTime.now(),
      });
    });
    _messageController.clear();
  }

  String _formatTime(DateTime timestamp) {
    int hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final ampm = hour >= 12 ? 'PM' : 'AM';
    if (hour == 0) hour = 12;
    if (hour > 12) hour -= 12;
    return '$hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMine = message['sender'] == 'me';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: isMine
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isMine
                              ? AppTheme.neonGreen
                              : AppTheme.darkBlue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(
                            color: isMine
                                ? AppTheme.darkBlue  // Changed from navyBlue to darkBlue for consistency
                                : AppTheme.textWhite,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(message['timestamp']),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              fontSize: 11,
                              color: AppTheme.textGray,
                            ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkBlue,
              border: Border(
                top: BorderSide(
                  color: AppTheme.textGray.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: AppTheme.textWhite),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                        color: AppTheme.textGray.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: AppTheme.darkBlue,  // Changed from navyBlue to darkBlue
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: AppTheme.textGray.withOpacity(0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: AppTheme.textGray.withOpacity(0.2),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.neonGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: AppTheme.darkBlue,  // Changed from navyBlue to darkBlue
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}