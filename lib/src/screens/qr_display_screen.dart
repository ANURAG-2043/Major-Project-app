import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QRDisplayScreen extends StatelessWidget {
  final String partyId;
  final String partyName;

  const QRDisplayScreen({
    super.key,
    required this.partyId,
    required this.partyName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Party QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              partyName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            QrImageView(
              data: partyId,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Share.share('Join my party: $partyName\nParty ID: $partyId');
              },
              icon: const Icon(Icons.share),
              label: const Text('Share Party Code'),
            ),
          ],
        ),
      ),
    );
  }
}