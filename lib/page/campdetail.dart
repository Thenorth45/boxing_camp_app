import 'package:flutter/material.dart';

class CampDetailScreen extends StatelessWidget {
  final Map<String, dynamic> camp;

  CampDetailScreen({required this.camp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(camp['name']),
        backgroundColor: Color.fromARGB(248, 158, 25, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ชื่อค่าย: ${camp['name']}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'คำอธิบาย: ${camp['description']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'ตำแหน่งที่ตั้ง:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'ละติจูด: ${camp['location']['latitude']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'ลองจิจูด: ${camp['location']['longitude']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'อัปเดตเมื่อ: ${camp['updated_at']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
