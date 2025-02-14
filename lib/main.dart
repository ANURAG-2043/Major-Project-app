import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/providers/party_provider.dart';
import 'src/screens/splash_screen.dart';  // Add this import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PartyProvider(),
      child: MaterialApp(
        title: 'Party Pic',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),  // Now SplashScreen will be recognized
      ),
    );
  }
}
