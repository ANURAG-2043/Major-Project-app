import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';  // Move this import up
import 'package:provider/provider.dart';
import '../providers/party_provider.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'about_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  int _partiesCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadPartiesCount();
  }

  Future<void> _loadPartiesCount() async {
    final prefs = await SharedPreferences.getInstance();
    final partiesJson = prefs.getStringList('parties') ?? [];
    setState(() {
      _partiesCount = partiesJson.length;
    });
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('profile_name') ?? 'John Doe';
      _emailController.text = prefs.getString('profile_email') ?? 'john.doe@example.com';
      _phoneController.text = prefs.getString('profile_phone') ?? '+1 234 567 890';
      
      // Safely handle image loading
      try {
        final String? imagePath = prefs.getString('profile_image');
        if (imagePath != null) {
          final imageFile = File(imagePath);
          if (imageFile.existsSync()) {
            _imageFile = imageFile;
          } else {
            // Remove invalid image path
            prefs.remove('profile_image');
          }
        }
      } catch (e) {
        // If there's any error loading the image, clear the stored path
        prefs.remove('profile_image');
        print('Error loading profile image: $e');
      }
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', _nameController.text);
    await prefs.setString('profile_email', _emailController.text);
    await prefs.setString('profile_phone', _phoneController.text);
    
    // Safely handle image saving
    try {
      if (_imageFile != null && await _imageFile!.exists()) {
        await prefs.setString('profile_image', _imageFile!.path);
      } else {
        await prefs.remove('profile_image');
      }
    } catch (e) {
      print('Error saving profile image: $e');
      await prefs.remove('profile_image');
    }
  }

  Future<void> _pickImage() async {
    try {
      await showModalBottomSheet(
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
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      setState(() {
                        _imageFile = File(image.path);
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      setState(() {
                        _imageFile = File(image.path);
                      });
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final partyProvider = Provider.of<PartyProvider>(context);
    final partiesJoined = partyProvider.userParties.length;  // Get parties count

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () async {  // Make this async
              if (isEditing) {
                if (_formKey.currentState!.validate()) {
                  await _saveProfileData();  // Add this line
                  setState(() {
                    isEditing = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully')),
                  );
                }
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    child: _imageFile != null
                        ? ClipOval(
                            child: Image.file(
                              _imageFile!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                  ),
                  if (isEditing)
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                        ),
                        onPressed: _pickImage,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                enabled: isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                enabled: isEditing,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone',
                enabled: isEditing,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildProfileItem(Icons.celebration, 'Parties Joined', _partiesCount.toString()),
              _buildProfileItem(Icons.photo_camera, 'Photos Shared', '25'),
              // Remove the divider and ListTiles for Privacy, Terms, and About
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool enabled,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
