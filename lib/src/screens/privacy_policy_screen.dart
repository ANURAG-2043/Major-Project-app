import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Last updated: February 2024',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 24),
            _PolicySection(
              title: 'Information We Collect',
              content: '''
• Profile Information: Name, email address, phone number, and profile picture
• Party Information: Event details, photos, and participant information
• Device Information: Device type, operating system, and app usage data
              ''',
            ),
            _PolicySection(
              title: 'How We Use Your Information',
              content: '''
• To provide and maintain our Service
• To notify you about changes to our Service
• To allow you to participate in interactive features
• To provide customer support
• To gather analysis or valuable information to improve our Service
              ''',
            ),
            _PolicySection(
              title: 'Data Storage and Security',
              content: '''
• We implement industry-standard security measures
• Your data is stored securely and accessed only when necessary
• We regularly review our security practices
              ''',
            ),
            _PolicySection(
              title: 'Your Rights',
              content: '''
• Access your personal data
• Correct any inaccurate data
• Request deletion of your data
• Opt-out of marketing communications
              ''',
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;

  const _PolicySection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(content),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}