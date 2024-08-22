import 'package:boxing_camp_app/main.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AdminHomePage",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        elevation: 10,
        backgroundColor: Color.fromARGB(248, 158, 25, 1),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [],
      ),
    );
  }
}