// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:boxing_camp_app/main.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final String? username;
  const ContactPage({super.key, this.username});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

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
          "ติดต่อเรา",
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
          children: [
            // Display an image
            Center(
              child: Image.asset(
                'assets/contact/not.jpg', // Ensure this is your image path
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 20),
            // Display contact details for the first person
            Align(
              alignment: Alignment.center, // Center text horizontally
              child: Text(
                'Watcharapong Chaisangsri',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center, // Center text horizontally
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center row content horizontally
                    children: [
                      Icon(Icons.email, size: 20),
                      SizedBox(width: 10),
                      Text(
                        '642021157@tsu.ac.th',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Display contact details for the second person
            Center(
              child: Image.asset(
                'assets/contact/aom.jpg', // Ensure this is your image path
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center, // Center text horizontally
              child: Text(
                'Sunita Kanjanaprom',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center, // Center text horizontally
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center row content horizontally
                    children: [
                      Icon(Icons.email, size: 20),
                      SizedBox(width: 10),
                      Text(
                        '642021161@tsu.ac.th',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
