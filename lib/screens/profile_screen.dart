import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircleAvatar(radius: 50),
              SizedBox(height: 20),
              Text('User Name (Replace with actual user data)',
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text('Email: user@example.com (Replace with actual user data)'),
              // ... Add more profile information (e.g., bio, location)
            ],
          ),
        ),
      ),
    );
  }
}