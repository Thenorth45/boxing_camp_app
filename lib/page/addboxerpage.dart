import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddBoxerPage extends StatefulWidget {
  @override
  _AddBoxerPageState createState() => _AddBoxerPageState();
}

class _AddBoxerPageState extends State<AddBoxerPage> {
  final TextEditingController _campIdController = TextEditingController();
  String? _selectedBoxer;
  String? _selectedCamp;
  List<dynamic> _boxers = [];
  List<dynamic> _camps = [];

  @override
  void initState() {
    super.initState();
    _fetchBoxers();
    _fetchCamps();
  }

  // ฟังก์ชันดึงรายชื่อนักมวยจากฐานข้อมูล
  Future<void> _fetchBoxers() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/users'), // เปลี่ยน endpoint ตามที่คุณใช้
    );

    if (response.statusCode == 200) {
      List<dynamic> allUsers = json.decode(response.body);

      // กรองเฉพาะนักมวยที่ role เป็น 'นักมวย'
      setState(() {
        _boxers = allUsers.where((user) => user['role'] == 'นักมวย').toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถโหลดรายชื่อนักมวยได้')),
      );
    }
  }

  // ฟังก์ชันดึงข้อมูลค่ายมวยจากฐานข้อมูล
  Future<void> _fetchCamps() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:3000/getcamp'), // เปลี่ยน endpoint ตามที่คุณใช้
    );

    if (response.statusCode == 200) {
      List<dynamic> allCamps = json.decode(response.body);

      // กรองเฉพาะค่ายที่มีชื่อ
      setState(() {
        _camps = allCamps
            .where((camp) => camp['name'] != null && camp['name'].isNotEmpty)
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถโหลดข้อมูลค่ายมวยได้')),
      );
    }
  }

  // ฟังก์ชันเพิ่มนักมวยไปยังค่าย
  Future<void> _addBoxer() async {
    if (_selectedBoxer == null || _selectedCamp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณาเลือกนักมวยและค่ายมวย')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost:3000/addboxer'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'campId': _selectedCamp!,
        'boxerUsername': _selectedBoxer!,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เพิ่มนักมวยสำเร็จ')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถเพิ่มนักมวยได้')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่มนักมวย')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown สำหรับเลือกค่ายมวย
            _camps.isNotEmpty
                ? DropdownButtonFormField<String>(
                    value: _selectedCamp,
                    hint: Text('เลือกค่ายมวย'),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCamp = newValue;
                      });
                    },
                    items: _camps.map<DropdownMenuItem<String>>((camp) {
                      return DropdownMenuItem<String>(
                        value: camp['_id'], // ใช้ camp ID
                        child: Text(camp['name']),
                      );
                    }).toList(),
                  )
                : CircularProgressIndicator(), // แสดงโหลดเดอร์ขณะดึงข้อมูล
            SizedBox(height: 16),
            // Dropdown สำหรับเลือกนักมวย
            _boxers.isNotEmpty
                ? DropdownButtonFormField<String>(
                    value: _selectedBoxer,
                    hint: Text('เลือกนักมวย'),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedBoxer = newValue;
                      });
                    },
                    items: _boxers.map<DropdownMenuItem<String>>((boxer) {
                      return DropdownMenuItem<String>(
                        value: boxer['username'],
                        child: Text(boxer['fullname']),
                      );
                    }).toList(),
                  )
                : CircularProgressIndicator(), // แสดงโหลดเดอร์ขณะดึงข้อมูล
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addBoxer,
              child: Text('เพิ่มนักมวย'),
            ),
          ],
        ),
      ),
    );
  }
}
