import 'package:boxing_camp_app/main.dart';
import 'package:boxing_camp_app/page/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {

  final String? username;

  const ProfilePage({super.key, this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _username;
  String? name;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'ไม่มีชื่อผู้ใช้';
      name = prefs.getString('email') ?? 'ไม่มีอีเมล';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์ของฉัน'),
      ),
      drawer: const AppDrawer(),
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
              _username ?? '',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'อีเมล:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              name ?? '',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Action for editing profile
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfile(userData: {},),
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