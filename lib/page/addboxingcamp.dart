import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_picker_page.dart';

class AddCampPage extends StatefulWidget {
  const AddCampPage({super.key});

  @override
  State<AddCampPage> createState() => _AddCampPageState();
}

class _AddCampPageState extends State<AddCampPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  LatLng? _selectedLocation;

  Future<void> _selectLocation() async {
    final location = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerPage()),
    );
    if (location != null) {
      setState(() {
        _selectedLocation = location;
      });
    }
  }

  Future<void> _submitData() async {
    if (_formKey.currentState?.validate() ?? false) {
      final campData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'location': {
          'latitude': _selectedLocation!.latitude,
          'longitude': _selectedLocation!.longitude,
        },
      };

      final response = await http.post(
        Uri.parse('http://localhost:3000/addcamp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(campData),
      );

      if (response.statusCode == 201) {
        // สำเร็จ
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('บันทึกค่ายมวยสำเร็จ')));
      } else {
        // ล้มเหลว
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${response.reasonPhrase}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'เพิ่มค่ายมวย',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        backgroundColor: Color.fromARGB(248, 158, 25, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ชื่อค่าย',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'ใส่ชื่อค่าย',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาใส่ชื่อค่าย';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'คำอธิบายค่าย',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'ใส่คำอธิบายค่าย',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาใส่คำอธิบายค่าย';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'ตำแหน่ง',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: _selectLocation,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _selectedLocation == null
                        ? 'แตะเพื่อเลือกตำแหน่ง'
                        : 'ตำแหน่ง: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('บันทึกข้อมูล'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
