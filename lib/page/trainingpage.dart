import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityFormPage extends StatefulWidget {
  @override
  _ActivityFormPageState createState() => _ActivityFormPageState();
}

class _ActivityFormPageState extends State<ActivityFormPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final TextEditingController runingController = TextEditingController();
  final TextEditingController ropejumpingController = TextEditingController();
  final TextEditingController punchingandkickingController =
      TextEditingController();
  final TextEditingController weighttrainingController =
      TextEditingController();

  String? user_id;

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('_id');
    });

    if (user_id == null || user_id!.isEmpty) {
      print('User ID is null or empty');
      return;
    }
  }

  Future<void> submitActivity() async {
    if (user_id == null) {
      print('ไม่พบ userId');
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost:3000/addtraining'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'user_id': user_id,
        'date': _selectedDay
            .toIso8601String(), // ส่งวันที่ที่เลือก (ซึ่งคือวันที่ปัจจุบัน)
        'runing': int.tryParse(runingController.text) ?? 0,
        'ropejumping': int.tryParse(ropejumpingController.text) ?? 0,
        'punchingandkicking':
            int.tryParse(punchingandkickingController.text) ?? 0,
        'weighttraining': int.tryParse(weighttrainingController.text) ?? 0,
      }),
    );

    if (response.statusCode == 201) {
      print('กิจกรรมบันทึกสำเร็จ');
    } else {
      print('เกิดข้อผิดพลาดในการบันทึกกิจกรรม');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(248, 158, 25, 1),
          title: Text(
            'บันทึกกิจกรรมรายวัน',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          )),
      body: Column(
        children: [
          TableCalendar(
            firstDay: _focusedDay,
            lastDay: _focusedDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {},
            calendarFormat: CalendarFormat.week,
            onFormatChanged: (format) {
              // ไม่ต้องเปลี่ยนรูปแบบ
            },
            onPageChanged: (focusedDay) {
              // ไม่ให้เลื่อนปฏิทินไปยังเดือนอื่น
            },
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: runingController,
                  decoration:
                      InputDecoration(labelText: 'เวลาในการวิ่ง (นาที)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: ropejumpingController,
                  decoration: InputDecoration(labelText: 'กระโดดเชือก (นาที)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: punchingandkickingController,
                  decoration: InputDecoration(labelText: 'ต่อยและเตะ (นาที)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: weighttrainingController,
                  decoration: InputDecoration(labelText: 'ยกน้ำหนัก (นาที)'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    submitActivity();
                  },
                  child: Text('บันทึกกิจกรรม'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
