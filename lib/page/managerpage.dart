import 'package:boxing_camp_app/main.dart';
import 'package:flutter/material.dart';

class ManagerHomePage extends StatefulWidget {
  final String? username;
  const ManagerHomePage({super.key, this.username});

  @override
  State<ManagerHomePage> createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  late String? username;

  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ผู้จัดการค่ายมวย",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        elevation: 10,
        backgroundColor: Color.fromARGB(248, 158, 25, 1),
        actions: [
          if (username != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'ยินดีต้อนรับคุณ $username',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 16),
        ],
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addCamp');
              },
              child: Text('เพิ่มค่ายมวย'),
            ),
            SizedBox(height: 16), // เพิ่มช่องว่างระหว่างปุ่ม
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addboxer'); // ไปหน้าการเพิ่มนักมวย
              },
              child: Text('เพิ่มนักมวย'),
            ),
          ],
        ),
      ),
    );
  }
}
