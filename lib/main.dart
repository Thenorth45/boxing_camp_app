import 'package:boxing_camp_app/page/addboxingcamp.dart';
import 'package:boxing_camp_app/page/contact.dart';
import 'package:boxing_camp_app/page/firstpage.dart';
import 'package:boxing_camp_app/page/homepage.dart';
import 'package:boxing_camp_app/page/loginpage.dart';
import 'package:boxing_camp_app/page/managerpage.dart';
import 'package:boxing_camp_app/page/profilepage.dart';
import 'package:boxing_camp_app/page/trainerpage.dart';
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
          seedColor: const Color.fromARGB(253, 173, 53, 1),
          background: const Color.fromARGB(254, 214, 115, 1),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(), // Replace with your initial page
        '/addCamp': (context) => AddCampPage(), // Define the route for AddCampPage
      },
      home: const HomePage(),
    );
  }
}

class AppDrawer extends StatefulWidget {
  final String? username;

  const AppDrawer({Key? key, this.username}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isLoggedIn = false; // สถานะการล็อกอิน

  void _login(String username) {
    setState(() {
      isLoggedIn = true;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(username: username),
      ),
    );
  }

  void _logout() {
    setState(() {
      isLoggedIn = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(onLogin: _login),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            child: Image.asset(
              'assets/images/logomuay.png',
              height: 100,
            ),
          ),
          ListTile(
            title: const Text('หน้าแรก'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Firstpage()),
              );
            },
          ),
          ListTile(
            title: const Text('โปรไฟล์ของฉัน'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            title: const Text('ติดต่อเรา'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactPage()),
              );
            },
          ),
          ListTile(
            title: const Text('ครูมวย'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrainerHomePage()),
              );
            },
          ),
          ListTile(
            title: const Text('ผู้จัดการค่ายมวย'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManagerHomePage()),
              );
            },
          ),
          ListTile(
            title: isLoggedIn
                ? OutlinedButton(
                    onPressed: _logout,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.red,
                        width: 3,
                      ),
                    ),
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                  )
                : OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(onLogin: _login),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.green,
                        width: 3,
                      ),
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}