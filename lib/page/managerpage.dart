import 'package:boxing_camp_app/main.dart';
import 'package:flutter/material.dart';

class ManagerHomePage extends StatefulWidget {
  const ManagerHomePage({super.key});

  @override
  State<ManagerHomePage> createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ManagerHomePage",
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