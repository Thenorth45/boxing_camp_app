import 'package:boxing_camp_app/main.dart';
import 'package:boxing_camp_app/page/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final String? username;

  const ProfilePage({super.key, this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String? username;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    _loadUserData();
  }
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('token'); // Assume you stored token after login

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://localhost:3000/user'),
        headers: {
          'Authorization': 'Bearer $token', // ส่ง token ไปยัง API
        },
      );

      if (response.statusCode == 200) {
        // ถ้าการดึงข้อมูลสำเร็จ
        final data = json.decode(response.body);
        setState(() {
          username = data['username'] ?? 'ไม่มีชื่อผู้ใช้';
          // name = data['email'] ?? 'ไม่มีอีเมล';
        });
      } else {
        // จัดการเมื่อเกิดข้อผิดพลาด
        setState(() {
          username = 'ไม่สามารถดึงข้อมูลผู้ใช้ได้';
          // name = 'ไม่สามารถดึงข้อมูลอีเมลได้';
        });
      }
    } else {
      // ถ้าไม่มี token ให้แสดงข้อความแจ้งผู้ใช้
      setState(() {
        username = 'ไม่มีชื่อผู้ใช้';
        // name = 'ไม่มีอีเมล';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'โปรไฟล์ของฉัน',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        backgroundColor: Color.fromARGB(248, 158, 25, 1),
      ),
      drawer: BaseAppDrawer(
        onHomeTap: (context) {
          Navigator.pushNamed(context, '/home');
        },
        onCampTap: (context) {
          Navigator.pushNamed(context, '/dashboard');
        },
        onContactTap: (context) {
          Navigator.pushNamed(context, '/contact');
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ชื่อผู้ใช้:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              username ?? '',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Text(
            //   'อีเมล:',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // Text(
            //   name ?? '',
            //   style: TextStyle(fontSize: 16),
            // ),
            // SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Action for editing profile
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfile(
                      userData: {},
                    ),
                  ),
                );
              },
              child: Text('แก้ไขโปรไฟล์'),
            ),
          ],
        ),
      ),
    );
  }
}
