import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:boxing_camp_app/page/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:boxing_camp_app/main.dart';
import 'package:boxing_camp_app/page/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String? username;

  const HomePage({super.key, this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String? username;
  bool _isCheckingStatus = false; // เพิ่มตัวแปรเพื่อป้องกันการเรียกซ้ำ

  @override
  void initState() {
    super.initState();
    username = widget.username;
    // เรียก _checkLoginStatus() ครั้งเดียวใน initState
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _checkLoginStatus();
    // });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    final snackbar = SnackBar(
      content: Text('ออกจากระบบเรียบร้อยแล้ว'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _refreshToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      final url = Uri.parse('http://localhost:3000/refresh');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'token': refreshToken});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final newAccessToken = responseData['accessToken'];
        prefs.setString('accessToken', newAccessToken);
      } else {
        await _logout(context);
      }
    } else {
      await _logout(context);
    }
  }

  Future<void> _checkLoginStatus() async {
    if (_isCheckingStatus) return; // ตรวจสอบว่ากำลังตรวจสอบอยู่หรือไม่
    _isCheckingStatus = true;
    try {
      bool isLoggedIn = await checkTokenValidity();
      if (isLoggedIn) {
        // ใช้ Navigator.pushReplacement() เพื่อเปลี่ยนหน้า
        if (ModalRoute.of(context)?.settings.name != '/home') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(username: username),
            ),
          );
        }
      } else {
        if (ModalRoute.of(context)?.settings.name != '/login') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        }
      }
    } finally {
      _isCheckingStatus = false;
    }
  }

  Future<bool> checkTokenValidity() async {
    String? accessToken = await getAccessToken();

    if (accessToken != null) {
      if (_isTokenExpired(accessToken)) {
        await _refreshToken(context);
        accessToken = await getAccessToken(); // ดึง accessToken ใหม่
        if (_isTokenExpired(accessToken ?? '')) {
          await _logout(context);
          return false;
        }
        return true;
      }
      return true;
    } else {
      await _logout(context);
      return false;
    }
  }

  bool _isTokenExpired(String token) {
    final decodedToken = json.decode(
        ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));
    final expiry = decodedToken['exp'];
    final now = DateTime.now().millisecondsSinceEpoch / 1000;
    return expiry < now;
  }

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
        actions: [
          if (username != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'ยินดีต้อนรับคุณ $username',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 16),
        ],
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
      body: Column(
        children: [],
      ),
    );
  }
}
