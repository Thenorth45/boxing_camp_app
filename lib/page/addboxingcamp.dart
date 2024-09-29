import 'dart:io'; // Import for File
import 'package:image_picker/image_picker.dart'; // Import for ImagePicker
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map_picker_page.dart';

class AddCampPage extends StatefulWidget {
  final String? username;
  const AddCampPage({super.key, this.username});

  @override
  State<AddCampPage> createState() => _AddCampPageState();
}

class _AddCampPageState extends State<AddCampPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  LatLng? _selectedLocation;
  File? _image; // Variable to store the selected image
  late String? username;
  String accessToken = "";
  String refreshToken = "";
  String role = "";
  late SharedPreferences logindata;
  bool _isCheckingStatus = false;
  List<dynamic> _managers = []; // เก็บรายชื่อผู้จัดการ
  String? _selectedManagerId; // ค่าพื้นฐานเป็น null

  @override
  void initState() {
    super.initState();
    _fetchManagers(); // เรียกใช้ฟังก์ชันเพื่อดึงข้อมูลผู้จัดการ
  }

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

  void getInitialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCheckingStatus = prefs.getBool("isLoggedIn")!;
      username = prefs.getString("username");
      accessToken = prefs.getString("accessToken")!;
      refreshToken = prefs.getString("refreshToken")!;
      role = prefs.getString("role")!;
    });

    print(_isCheckingStatus);
    print(username);
    print(accessToken);
    print(refreshToken);
    print(role);
  }

  Future<void> _fetchManagers() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3000/users'));
    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> allUsers = jsonDecode(response.body);
        _managers =
            allUsers.where((user) => user['role'] == 'ผู้จัดการค่ายมวย').toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถดึงข้อมูลผู้จัดการได้')));
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _submitData() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedManagerId == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('กรุณาเลือกผู้จัดการ')));
        return;
      }

      final campData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'location': {
          'latitude': _selectedLocation!.latitude,
          'longitude': _selectedLocation!.longitude,
        },
        'manager': _selectedManagerId, // เพิ่ม ID ของผู้จัดการ
      };

      final response = await http.post(
        Uri.parse('http://localhost:3000/addcamp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(campData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('บันทึกค่ายมวยสำเร็จ')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${response.reasonPhrase}')));
      }
    }
  }

  void _cancel() {
    Navigator.pop(context); // กลับไปหน้าก่อนหน้า
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
        backgroundColor: const Color.fromARGB(248, 226, 131, 53),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                  maxWidth: 450), // Reduce maxWidth to make it more compact
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Picker Box
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFED673), // Background color #FED673
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.3), // Shadow color
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(
                                  4, 6), // Shadow position (right, bottom)
                            ),
                            BoxShadow(
                              color: Colors.white
                                  .withOpacity(0.5), // Inner light shadow
                              spreadRadius: -1,
                              blurRadius: 15,
                              offset:
                                  const Offset(-4, -4), // Shadow position (left, top)
                            ),
                          ],
                        ),
                        width: double.infinity,
                        height: 150, // Reduce height for a more compact look
                        child: Center(
                          child: _image == null
                              ? const Text(
                                  'แตะเพื่อเลือกรูปภาพ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              : Image.file(
                                  _image!,
                                  width: double.infinity,
                                  height:
                                      150, // Adjusted height to match container
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Camp Name Input
                    const Text(
                      'ชื่อค่าย',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'ใส่ชื่อค่าย',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10), // Adjusted padding
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.orange),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาใส่ชื่อค่าย';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // เพิ่ม UI เพื่อเลือกผู้จัดการ
                    const SizedBox(height: 20),
                    const Text(
                      'ผู้จัดการค่าย',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: _selectedManagerId,
                      hint: const Text('เลือกผู้จัดการ'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedManagerId =
                              newValue; // อัปเดต ID ของผู้จัดการที่เลือก
                        });
                      },
                      items: _managers.map<DropdownMenuItem<String>>((manager) {
                        return DropdownMenuItem<String>(
                          value: manager['_id'], // ID ของผู้จัดการ
                          child:
                              Text(manager['fullname'] ?? ''), // ชื่อผู้จัดการ
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      'คำอธิบายค่าย',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'ใส่คำอธิบายค่าย',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.orange),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาใส่คำอธิบายค่าย';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'ตำแหน่ง',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectLocation,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(
                                  4, 6),
                            ),
                            BoxShadow(
                              color: Colors.white
                                  .withOpacity(0.5),
                              spreadRadius: -1,
                              blurRadius: 15,
                              offset:
                                  const Offset(-4, -4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(
                            14),
                        child: Text(
                          _selectedLocation == null
                              ? 'แตะเพื่อเลือกตำแหน่ง'
                              : 'ตำแหน่ง: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _submitData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                  255, 59, 218, 64),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 22),
                            ),
                            child: const Text(
                              'บันทึกข้อมูล',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _cancel,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                  255, 241, 116, 116),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 22),
                            ),
                            child: const Text(
                              'ยกเลิก',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
