
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'dart:convert';  // Add this import for jsonEncode and jsonDecode
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'my_parties_screen.dart';
import 'member_details_screen.dart';

class PartyDetailsScreen extends StatefulWidget {  // Change to StatefulWidget
  final String partyId;
  final String partyName;
  final List<PartyMember> members;
  final List<String> images;  // Add this field

  const PartyDetailsScreen({
    super.key,
    required this.partyId,
    required this.partyName,
    required this.members,
    this.images = const [],  // Add this parameter
  });

  @override
  State<PartyDetailsScreen> createState() => _PartyDetailsScreenState();
}

class _PartyDetailsScreenState extends State<PartyDetailsScreen> {
  late List<String> _images;

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.images);
  }

  Future<void> _savePartyImages() async {
    final prefs = await SharedPreferences.getInstance();
    final parties = prefs.getStringList('parties') ?? [];
    final List<Map<String, dynamic>> partiesList = parties
        .map((party) => jsonDecode(party) as Map<String, dynamic>)
        .toList();

    final partyIndex = partiesList.indexWhere((p) => p['id'] == widget.partyId);
    if (partyIndex != -1) {
      partiesList[partyIndex]['images'] = _images;
      final updatedParties = partiesList
          .map((party) => jsonEncode(party))
          .toList()
          .cast<String>();
      await prefs.setStringList('parties', updatedParties);
    }
  }

  @override
  void dispose() {
    _savePartyImages();
    super.dispose();
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    setState(() {
                      _images.add(image.path);
                    });
                    await _savePartyImages();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    setState(() {
                      _images.add(image.path);
                    });
                    await _savePartyImages();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.partyName),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Members'),
              Tab(text: 'All Images'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMembersTab(context),
            _buildImagesTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersTab(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Party ID: ${widget.partyId}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Members: ${widget.members.length}'),
                ],
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Party QR Code'),
                      content: QrImageView(
                        data: widget.partyId,
                        size: 200,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.qr_code),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.members.length,
            itemBuilder: (context, index) {
              final member = widget.members[index];
              return _buildMemberTile(member);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMemberTile(PartyMember member) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: member.profileImagePath != null
              ? ClipOval(
                  child: Image.file(
                    File(member.profileImagePath!),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, color: Colors.grey);
                    },
                  ),
                )
              : const Icon(Icons.person, color: Colors.grey),
        ),
        title: Text(member.name),
        subtitle: Text(member.joinedAt),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberDetailsScreen(member: member),
            ),
          );
        },
      );
    }

  Widget _buildImagesTab(BuildContext context) {
    if (_images.isEmpty) {
      return Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.image_not_supported_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Empty',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => _showImagePickerOptions(context),
              child: const Icon(Icons.add_photo_alternate),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,  // Fixed: changed from crossCount to crossAxisCount
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _images.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_images[index]),
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () => _showImagePickerOptions(context),
            child: const Icon(Icons.add_photo_alternate),
          ),
        ),
      ],
    );
  }
}