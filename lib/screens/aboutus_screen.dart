// ignore_for_file: use_key_in_widget_constructors, avoid_print, prefer_typing_uninitialized_variables, non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  static const TextStyle headerStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
  );

  static const TextStyle footerStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  final String email = 'lipalocal@gmail.com';
  final String website = 'www.lipalocal.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('Who We Are',
                      'We are a leading company specializing in cutting-edge solutions that empower local artisans and tourists to do business without need for middlemen. Lipalocal is dedicated for empowering, creativity, and delivering excellence to both the local artisans and tourists.'),
                  _buildSection('Our Mission',
                      'Our mission is to leverage the local crafts and artisan market to simplify lives, foster growth, and inspire change among the local people and artists. We strive to create meaningful experiences for our users while upholding our values of integrity and collaboration.'),
                  _buildContactSection(),
                  _buildSocialMediaSection(),
                  Center(
                    child: Text(
                      '© 2025 Our Company. All rights reserved.',
                      style: footerStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              const SizedBox(height: 80),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/logo.png'), // App logo
              ),
              const SizedBox(height: 10),
              const Text(
                'Lipalocal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: headerStyle),
        const SizedBox(height: 8),
        Text(content, style: bodyStyle),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Us', style: headerStyle),
        const SizedBox(height: 8),
        _buildContactRow(Icons.email, 'Email: $email', () {
          // Replace with actual email logic
          print('Navigate to email: $email');
        }),
        const SizedBox(height: 8),
        _buildContactRow(Icons.language, 'Website: $website', () {
          // Replace with website logic
          print('Navigate to website: $website');
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 8),
          Text(text, style: bodyStyle),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Follow Us', style: headerStyle),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSocialMediaIcon(FontAwesomeIcons.facebook, 'Facebook'),
            const SizedBox(width: 16),
            _buildSocialMediaIcon(FontAwesomeIcons.twitter, 'Twitter'),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSocialMediaIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
