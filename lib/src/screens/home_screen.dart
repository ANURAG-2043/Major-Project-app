import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'qr_scanner_screen.dart';
import 'qr_display_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _partyNameController = TextEditingController();

  void _showCreatePartyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Party'),
        content: TextField(
          controller: _partyNameController,
          decoration: const InputDecoration(
            labelText: 'Party Name',
            hintText: 'Enter party name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_partyNameController.text.isNotEmpty) {
                Navigator.pop(context);
                // Generate a unique party ID (you might want to use UUID)
                final partyId = DateTime.now().millisecondsSinceEpoch.toString();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRDisplayScreen(
                      partyId: partyId,
                      partyName: _partyNameController.text,
                    ),
                  ),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PartyPic'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _showCreatePartyDialog,
              child: const Text('Create Party'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRScannerScreen(),
                  ),
                );
                if (result != null) {
                  // Handle the scanned party code
                  // TODO: Implement party joining logic
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Joined party: $result')),
                    );
                  }
                }
              },
              child: const Text('Join Party'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              },
              child: const Text('Dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _partyNameController.dispose();
    super.dispose();
  }
}