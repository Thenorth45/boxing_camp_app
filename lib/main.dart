import 'package:boxing_camp_app/page/homepage.dart';
import 'package:boxing_camp_app/page/loginpage.dart';
import 'package:boxing_camp_app/page/profilepage.dart';
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
      home: const HomePage(),
    );
  }
}

class AppDrawer extends StatefulWidget {
  final String? username; // รับชื่อผู้ใช้ผ่าน constructor

  const AppDrawer({super.key, this.username});

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
      MaterialPageRoute(builder: (context) => HomePage(username: username)),
    );
  }

  void _logout() {
    setState(() {
      isLoggedIn = false;
    });
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen(onLogin: _login)),
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
            title: const Text('โปรไฟล์ของฉัน'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage()),
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
                            builder: (context) =>
                                LoginScreen(onLogin: _login)),
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

// class HomePage extends StatelessWidget {
//   final String? username;

//   const HomePage({super.key, this.username});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('หน้าแรก'),
//         actions: [
//           if (username != null)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(child: Text('สวัสดี, $username')),
//             ),
//         ],
//       ),
//       drawer: AppDrawer(username: username), // ส่ง username ไปยัง Drawer
//       body: const Center(
//         child: Text('เนื้อหาหน้าแรก'),
//       ),
//     );
//   }
// }
