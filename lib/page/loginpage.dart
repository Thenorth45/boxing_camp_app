import 'dart:convert';
import 'package:boxing_camp_app/page/homepage.dart';
import 'package:boxing_camp_app/page/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final void Function(String) onLogin;

  const LoginScreen({super.key, required this.onLogin});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _selectedRole;

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Username: ${data.name}, Password: ${data.password}');

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        body: {
          'username': data.name,
          'password': data.password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final accessToken = responseData['accessToken'];
        final refreshToken = responseData['refreshToken'];

        // Save the token and username to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('accessToken', accessToken);
        prefs.setString('refreshToken', refreshToken);

        Future<void> _saveUserId(String user_id) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_id', user_id);
        }

        void loginUser(String user_id) {
          _saveUserId(user_id); // บันทึก userId ลงใน SharedPreferences
        }

        // Login successful
        return null;
      } else if (response.statusCode == 401) {
        // Login Fail
        return 'ชื่อผู้ใช้ หรือ พาสเวิร์ดไม่ถูกต้อง กรุณาลองใหม่';
      } else {
        // Other errors
        return 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';
      }
    } catch (e) {
      // Handle exceptions (e.g., network errors)
      // return 'เกิดข้อผิดพลาด';
    }
  }

  Future<void> refreshAccessToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Update accessToken and refreshToken
      String accessToken = data['accessToken'];
      String newRefreshToken = data['refreshToken'];
      // Store tokens securely
    } else {
      throw Exception('Failed to refresh access token');
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    print("------------------------------------");
    print("Email: ${data.additionalSignupData!['email']}");
    print("Username: ${data.name}");
    print("password: ${data.password}");
    print("ConfirmPassoword: ${data.password}");
    print("address: ${data.additionalSignupData!['address']}");
    print("name: ${data.additionalSignupData!['fullname']}");
    print("Telephone: ${data.additionalSignupData!['phone_number']}");
    print("Role: ${data.additionalSignupData!['selectedRole']}");
    print("-----------------------------------");

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fullname": data.additionalSignupData!["fullname"],
          "username": data.name,
          "email": data.additionalSignupData!["email"],
          "password": data.password,
          "address": data.additionalSignupData!["address"],
          "telephone": data.additionalSignupData!["phone_number"],
          "role": data.additionalSignupData![
              "selectedRole"], // ส่ง role ไปยังเซิร์ฟเวอร์
        }),
      );

      if (response.statusCode == 201) {
        // Registration successful
        return null;
      } else {
        // Registration failed
        final responseData = json.decode(response.body);
        print(response.statusCode);
        return responseData['message'] ??
            'ไม่สามารถสมัครสมาชิกได้ กรุณาลองใหม่';
      }
    } catch (e) {
      // Handle exceptions (e.g., network errors)
      print('Error during registration: $e');
      return 'เกิดข้อผิดพลาด';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterLogin(
            userType: LoginUserType.name,
            theme: LoginTheme(
              primaryColor: Color.fromARGB(254, 214, 115, 1),
              accentColor: Colors.white,
            ),
            userValidator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกชื่อผู้ใช้'; // ตรวจสอบแค่ว่าชื่อผู้ใช้ไม่ว่างเปล่า
              }
              return null;
            },
            onLogin: _authUser,
            onSignup: (data) async {
              // Add role to signup data
              final role = _selectedRole;
              if (role != null) {
                data.additionalSignupData!['selectedRole'] = role;
                return await _signupUser(data);
              } else {
                return 'กรุณาเลือกสิทธิ์การใช้งาน';
              }
            },
            loginAfterSignUp: false,
            hideForgotPasswordButton: true,
            additionalSignupFields: [
              const UserFormField(
                keyName: 'fullname',
                displayName: 'ชื่อ-นามสกุล',
                icon: Icon(FontAwesomeIcons.user),
              ),
              const UserFormField(
                keyName: 'email',
                displayName: 'อีเมล',
                icon: Icon(FontAwesomeIcons.envelope),
              ),
              const UserFormField(
                keyName: 'address',
                displayName: 'ที่อยู่',
                icon: Icon(FontAwesomeIcons.locationDot),
              ),
              UserFormField(
                keyName: 'phone_number',
                displayName: 'เบอร์โทรศัพท์',
                userType: LoginUserType.phone,
                icon: const Icon(FontAwesomeIcons.phone),
                fieldValidator: (value) {
                  final phoneRegExp = RegExp(
                    r'^0[0-9]{9}$', // รูปแบบหมายเลขโทรศัพท์ไทย
                  );
                  if (value == null || !phoneRegExp.hasMatch(value)) {
                    return "เบอร์โทรศัพท์ไม่ถูกต้อง";
                  }
                  return null;
                },
              ),
            ],
            onSubmitAnimationCompleted: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
            },
            onRecoverPassword: (_) => Future(() => null),
            messages: LoginMessages(
              userHint: 'ชื่อผู้ใช้',
              passwordHint: 'รหัสผ่าน',
              confirmPasswordHint: 'ยืนยันรหัสผ่าน',
              loginButton: 'เข้าสู่ระบบ',
              signupButton: 'สมัครสมาชิก',
              additionalSignUpSubmitButton: "สมัครสมาชิก",
              recoverPasswordButton: 'ยืนยัน',
              goBackButton: 'ย้อนกลับ',
              confirmPasswordError: 'พาสเวิร์ดไม่ตรงกัน!!',
              signUpSuccess: "สมัครสมาชิกสำเร็จ",
              additionalSignUpFormDescription:
                  "กรอกข้อมูลของท่านให้ครบและตรวจสอบให้ครบถ้วน!! ก่อนทำการสมัครสมาชิก",
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, -2), // Shadow direction
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'กรุณาเลือกสิทธิ์การใช้งาน:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ...['ครูมวย', 'นักมวย', 'ผู้จัดการค่ายมวย'].map((role) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedRole = role;
                        });
                      },
                      child: Text(role),
                    );
                  }).toList(),
                  if (_selectedRole != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'สิทธิ์การใช้งานที่เลือก: $_selectedRole',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: (MediaQuery.of(context).size.width - 500) / 2,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Image.asset(
                'assets/images/logomuay.png',
                width: 500,
                height: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
