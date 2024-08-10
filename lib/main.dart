import 'package:boxing_camp_app/page/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Boxing Camp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(253, 173, 53, 1),
            background: Color.fromARGB(254, 214, 115, 1),
          ),
          useMaterial3: true,
        ),
        home: const HomePage());
  }
}
