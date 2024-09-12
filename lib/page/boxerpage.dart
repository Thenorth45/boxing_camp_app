import 'package:boxing_camp_app/main.dart';
import 'package:flutter/material.dart';

class Boxerpage extends StatefulWidget {
  final String? username;
  const Boxerpage({super.key, this.username});

  @override
  State<Boxerpage> createState() => _BoxerpageState();
}

class _BoxerpageState extends State<Boxerpage> {
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
          "นักมวย",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        elevation: 10,
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
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/addtraining');
          },
          child: Text('เพิ่มการฝึก'),
        ),
      ),
    );
  }
}
