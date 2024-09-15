import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActivityHistoryPage extends StatefulWidget {
  final String? username;

  const ActivityHistoryPage({super.key, this.username});

  @override
  _ActivityHistoryPageState createState() => _ActivityHistoryPageState();
}

class _ActivityHistoryPageState extends State<ActivityHistoryPage> {

  late String? username;
  List<dynamic> activities = [];

  @override
  void initState() {
    super.initState();
    _fetchActivities();
    username = widget.username;
  }

  Future<void> _fetchActivities() async {
    final url = Uri.parse('http://localhost:3000/getTraining');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          activities = jsonDecode(response.body);
        });
      } else {
        print('Failed to load activities. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching activities: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ประวัติการฝึกซ้อม',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
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
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          final running = activity['runing'] ?? {};
          final ropeJumping = activity['ropejumping'] ?? {};
          final punching = activity['punchingandkicking'] ?? {};
          final weightTraining = activity['weighttraining'] ?? {};
          final updatedAt = activity['updated_at']; // Get the updated_at date

          // Format the date
          final formattedDate = updatedAt != null
              ? DateTime.parse(updatedAt).toLocal().toString().split(' ')[0]
              : 'Unknown date';

          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'เจ้าของข้อมูล: ${activity['username'] ?? 'Unknown'}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'วิ่ง: ${running['duration']} นาที, ระยะทาง: ${running['distance']} กม.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'กระโดดเชือก: ${ropeJumping['duration']} นาที, จำนวนครั้ง: ${ropeJumping['count']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'การชกกระสอบทราย: ${punching['duration']} นาที, จำนวนครั้ง: ${punching['count']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ยกน้ำหนัก: ${weightTraining['duration']} นาที, จำนวนครั้ง: ${weightTraining['count']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'วันที่บันทึกข้อมูล: $formattedDate',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
