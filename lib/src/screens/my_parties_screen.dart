import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Fixed import
import 'dart:convert';
import 'qr_scanner_screen.dart';
import 'qr_display_screen.dart';
import 'party_details_screen.dart';

class Party {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<PartyMember> members;
  final List<String> images;  // Add this field

  Party({
    required this.id, 
    required this.name, 
    required this.createdAt,
    List<PartyMember>? members,
    List<String>? images,  // Add this parameter
  }) : members = members ?? [PartyMember(name: 'You (Host)', joinedAt: 'Created party')],
       images = images ?? [];  // Initialize images list

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'members': members.map((member) => member.toJson()).toList(),
        'images': images,  // Add this field
      };

  factory Party.fromJson(Map<String, dynamic> json) => Party(
        id: json['id'],
        name: json['name'],
        createdAt: DateTime.parse(json['createdAt']),
        members: (json['members'] as List)
            .map((member) => PartyMember.fromJson(member))
            .toList(),
        images: List<String>.from(json['images'] ?? []),  // Add this field
      );
}

class PartyMember {
  final String name;
  final String joinedAt;
  final String? profileImagePath;  // Add this field

  PartyMember({
    required this.name, 
    required this.joinedAt, 
    this.profileImagePath,  // Add this parameter
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'joinedAt': joinedAt,
        'profileImagePath': profileImagePath,  // Add this field
      };

  factory PartyMember.fromJson(Map<String, dynamic> json) => PartyMember(
        name: json['name'],
        joinedAt: json['joinedAt'],
        profileImagePath: json['profileImagePath'],  // Add this field
      );
}

class MyPartiesScreen extends StatefulWidget {
  const MyPartiesScreen({super.key});

  @override
  State<MyPartiesScreen> createState() => _MyPartiesScreenState();
}

class _MyPartiesScreenState extends State<MyPartiesScreen> {
  final _partyNameController = TextEditingController();
  List<Party> _parties = [];

  @override
  void initState() {
    super.initState();
    _loadParties();
  }

  Future<void> _loadParties() async {
    final prefs = await SharedPreferences.getInstance();
    final partiesJson = prefs.getStringList('parties') ?? [];
    setState(() {
      _parties = partiesJson
          .map((party) => Party.fromJson(jsonDecode(party)))
          .toList();
    });
  }

  Future<void> _saveParties() async {
    final prefs = await SharedPreferences.getInstance();
    final partiesJson = _parties
        .map((party) => jsonEncode(party.toJson()))
        .toList();
    await prefs.setStringList('parties', partiesJson);
  }

  void _addParty(Party party) {
    setState(() {
      _parties.add(party);
    });
    _saveParties();
  }

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
            onPressed: () async {  // Add async here
              if (_partyNameController.text.isNotEmpty) {
                final prefs = await SharedPreferences.getInstance();
                final profileImagePath = prefs.getString('profile_image');
                final profileName = prefs.getString('profile_name') ?? 'You (Host)';
                
                final partyId = DateTime.now().millisecondsSinceEpoch.toString();
                final party = Party(
                  id: partyId,
                  name: _partyNameController.text,
                  createdAt: DateTime.now(),
                  members: [
                    PartyMember(
                      name: profileName, 
                      joinedAt: 'Created party',
                      profileImagePath: profileImagePath,
                    )
                  ],
                );
                _addParty(party);
                _partyNameController.clear();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRDisplayScreen(
                      partyId: partyId,
                      partyName: party.name,
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

  void _deleteParty(String partyId) {
    setState(() {
      _parties.removeWhere((party) => party.id == partyId);
    });
    _saveParties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Parties'),
      ),
      body: _parties.isEmpty
          ? const Center(child: Text('No parties created yet'))
          : ListView.builder(
              itemCount: _parties.length,
              itemBuilder: (context, index) {
                final party = _parties[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.celebration),
                    ),
                    title: Text(party.name),
                    subtitle: Text(
                        'Created on: ${party.createdAt.toString().split(' ')[0]}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Party'),
                                content: Text('Are you sure you want to delete "${party.name}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteParty(party.id);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Party deleted successfully'),
                                        ),
                                      );
                                    },
                                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PartyDetailsScreen(
                            partyId: party.id,
                            partyName: party.name,
                            members: party.members,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Join or Create Party'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showCreatePartyDialog();
                    },
                    child: const Text('Create New Party'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QRScannerScreen(),
                        ),
                      );
                      if (result != null && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Joined party: $result')),
                        );
                      }
                    },
                    child: const Text('Join Party'),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    _partyNameController.dispose();
    super.dispose();
  }
}