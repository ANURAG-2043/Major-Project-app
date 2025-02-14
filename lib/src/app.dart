import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class PartyPicApp extends StatelessWidget {
  const PartyPicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PartyPic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}