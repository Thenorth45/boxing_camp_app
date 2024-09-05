import 'package:boxing_camp_app/main.dart';
import 'package:flutter/material.dart';

class Boxerpage extends StatefulWidget {
  const Boxerpage({super.key});

  @override
  State<Boxerpage> createState() => _BoxerpageState();
}

class _BoxerpageState extends State<Boxerpage> {
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
      drawer: const AppDrawer(),
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