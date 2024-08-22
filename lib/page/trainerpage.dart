import 'package:boxing_camp_app/main.dart';
import 'package:flutter/material.dart';

class TrainerHomePage extends StatefulWidget {
  const TrainerHomePage({super.key});

  @override
  State<TrainerHomePage> createState() => _TrainerHomePageState();
}

class _TrainerHomePageState extends State<TrainerHomePage> {
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TrainerHomePage",
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