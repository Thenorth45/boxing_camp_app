import 'package:boxing_camp_app/main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  final String? username;

  const HomePage({super.key, this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Image.asset(
          'assets/images/logomuay.png',
          height: 40,
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
