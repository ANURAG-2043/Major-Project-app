import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Terms of Service',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Last updated: February 2024',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 24),
            _TermsSection(
              title: 'Acceptance of Terms',
              content: '''
By accessing or using PartyPic, you agree to be bound by these Terms of Service. If you disagree with any part of these terms, you may not access the service.
              ''',
            ),
            _TermsSection(
              title: 'User Responsibilities',
              content: '''
• You must be 13 years or older to use this service
• You are responsible for maintaining the security of your account
• You must not share inappropriate or illegal content
• You agree to respect other users' privacy and rights
              ''',
            ),
            _TermsSection(
              title: 'Content Guidelines',
              content: '''
• You retain rights to your content
• You grant PartyPic license to use your content
• You must not violate others' intellectual property rights
• We may remove content that violates our policies
              ''',
            ),
            _TermsSection(
              title: 'Service Modifications',
              content: '''
• We may modify or discontinue services at any time
• We will notify users of significant changes
• We are not liable for any service interruptions
              ''',
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  final String title;
  final String content;

  const _TermsSection({required this.title, required this.content});

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