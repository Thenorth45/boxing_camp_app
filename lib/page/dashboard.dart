// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:boxing_camp_app/main.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  final String? username;
  const DashboardPage({super.key, this.username});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

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
          "แดชบอร์ด",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center column content vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center column content horizontally
          children: []
        ),
      ),
    );
  }
}
