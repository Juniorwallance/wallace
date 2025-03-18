import 'package:flutter/material.dart';

class SouvenirsScreen extends StatelessWidget {
  const SouvenirsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Souvenirs')),
      body: const Center(
        child: Text('Souvenirs will be displayed here.'), // Placeholder
      ),
    );
  }
}