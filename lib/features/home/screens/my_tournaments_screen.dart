import 'package:flutter/material.dart';

class MyTournamentsScreen extends StatelessWidget {
  const MyTournamentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tournaments'),
      ),
      body: const Center(
        child: Text('My Tournaments Content'),
      ),
    );
  }
}
