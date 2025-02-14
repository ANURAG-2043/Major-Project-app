import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt,
              size: 80,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 16),
            const Text(
              'PartyPic',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'PartyPic is your ultimate party companion app that makes sharing and collecting photos at events seamless and fun.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            _buildFeatureSection(
              icon: Icons.group,
              title: 'Easy Photo Sharing',
              description: 'Share photos instantly with party members',
            ),
            _buildFeatureSection(
              icon: Icons.qr_code,
              title: 'Quick Party Join',
              description: 'Join parties easily using QR codes',
            ),
            _buildFeatureSection(
              icon: Icons.security,
              title: 'Secure & Private',
              description: 'Your photos are shared only with party members',
            ),
            const SizedBox(height: 32),
            const Text(
              '© 2024 PartyPic. All rights reserved.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSection({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.deepPurple),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}