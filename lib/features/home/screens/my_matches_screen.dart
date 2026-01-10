import 'package:flutter/material.dart';

class MyMatchesScreen extends StatelessWidget {
  const MyMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Matches'),
      ),
      body: const Center(
        child: Text('My Matches Content'),
      ),
    );
  }
}
