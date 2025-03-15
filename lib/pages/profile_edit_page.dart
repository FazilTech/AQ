import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  File? _imageFile;
  String? _profileImageUrl;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fetch user data from Firestore
  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      setState(() {
        _nameController.text = userData['name'] ?? '';
        _countryController.text = userData['country'] ?? '';
        _cityController.text = userData['city'] ?? '';
        _profileImageUrl = userData['profileImageUrl'] ?? '';
      });
    }
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Function to upload image to Firebase Storage
  Future<String> _uploadImage(File image) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Reference ref = FirebaseStorage.instance.ref().child('profile_pictures/${user.uid}.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    }
    return '';
  }

  // Function to update user profile
  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String imageUrl = _profileImageUrl ?? '';

        // Upload new profile picture if selected
        if (_imageFile != null) {
          imageUrl = await _uploadImage(_imageFile!);
        }

        // Update Firestore with new data
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'name': _nameController.text.trim(),
          'country': _countryController.text.trim(),
          'city': _cityController.text.trim(),
          'profileImageUrl': imageUrl,
        });

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ));

        Navigator.pop(context); // Go back to the previous screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty)
                                  ? NetworkImage(_profileImageUrl!)
                                  : AssetImage('assets/default_avatar.png') as ImageProvider,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _countryController,
                        decoration: InputDecoration(labelText: 'Country', border: OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? 'Please enter your country' : null,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(labelText: 'City', border: OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? 'Please enter your city' : null,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updateProfile,
                        child: Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
