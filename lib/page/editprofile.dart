import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> userData;

  EditProfile({required this.userData});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _fullnameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _telephoneController;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController(text: widget.userData['fullname']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _addressController = TextEditingController(text: widget.userData['address']);
    _telephoneController = TextEditingController(text: widget.userData['telephone']);
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final updatedData = {
      'fullname': _fullnameController.text,
      'email': _emailController.text,
      'address': _addressController.text,
      'telephone': _telephoneController.text,
    };

    final response = await http.put(
      Uri.parse('http://localhost:3000/boxerdata/${widget.userData['_id']['\$oid']}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _fullnameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _telephoneController,
              decoration: InputDecoration(labelText: 'Telephone'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}
