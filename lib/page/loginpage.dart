import 'dart:convert';
import 'package:boxing_camp_app/page/adminpage.dart';
import 'package:boxing_camp_app/page/firstpage.dart';
import 'package:boxing_camp_app/page/managerpage.dart';
import 'package:boxing_camp_app/page/trainerpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool _obscureText = true;

  Future<String?> _authUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        final username = responseData['user']['name'];

        // บันทึก token และ username ลงใน shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userToken', token);
        prefs.setString('username', username);

        // เข้าสู่ระบบสำเร็จ
        return null;
      } else if (response.statusCode == 400) {
        // เข้าสู่ระบบไม่สำเร็จ
        return 'ชื่อผู้ใช้ หรือ รหัสผ่านไม่ถูกต้อง กรุณาลองใหม่';
      } else {
        // ข้อผิดพลาดอื่นๆ
        return 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';
      }
    } catch (e) {
      // จัดการข้อยกเว้น (เช่น ข้อผิดพลาดของเครือข่าย)
      return 'เกิดข้อผิดพลาด';
    }
  }

  void _navigateToRoleSpecificPage(String role) {
    switch (role) {
      case 'admin':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
        break;
      case 'trainer':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TrainerHomePage()),
        );
        break;
      case 'manager':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ManagerHomePage()),
        );
        break;
      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Firstpage()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เข้าสู่ระบบ'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'อีเมล'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกอีเมล';
                      }
                      email = value;
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'รหัสผ่าน',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกรหัสผ่าน';
                      }
                      password = value;
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _authUser(email!, password!).then((error) async {
                          if (error == null) {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            String role = prefs.getString('userRole') ?? '';
                            _navigateToRoleSpecificPage(role);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error)),
                            );
                          }
                        });
                      }
                    },
                    child: Text('เข้าสู่ระบบ'),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // นำทางไปยังหน้าลงทะเบียน
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistrationScreen()),
                      );
                    },
                    child: Text('สมัครสมาชิก'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedRole;
  String? email;
  String? password;
  String? confirmPassword;
  String? fullname;
  String? address;
  String? telephone;
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  final List<String> roles = [
    'ผู้ดูแลระบบ',
    'ครูมวย',
    'ผู้จัดการค่ายมวย',
  ];

  Future<String?> _signupUser() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fullname": fullname,
          "email": email,
          "password": password,
          "address": address,
          "telephone": telephone,
          "role": selectedRole, // ส่ง role ไปยังเซิร์ฟเวอร์
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        // บันทึก token ลงใน shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userToken', token);

        // Registration successful
        return null;
      } else {
        // Registration failed
        final responseData = json.decode(response.body);
        return responseData['message'] ?? 'ไม่สามารถสมัครสมาชิกได้ กรุณาลองใหม่';
      }
    } catch (e) {
      // Handle exceptions (e.g., network errors)
      return 'เกิดข้อผิดพลาด';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สมัครสมาชิก'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'ชื่อ-นามสกุล'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อ-นามสกุล';
                      }
                      fullname = value;
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'ที่อยู่'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกที่อยู่';
                      }
                      address = value;
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'เบอร์โทรศัพท์'),
                    validator: (value) {
                      final phoneRegExp = RegExp(
                        r'^0[0-9]{9}$', // Thai phone number format
                      );
                      if (value == null || !phoneRegExp.hasMatch(value)) {
                        return "เบอร์โทรศัพท์ไม่ถูกต้อง";
                      }
                      telephone = value;
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    hint: Text('เลือกตำแหน่ง'),
                    value: selectedRole,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue!;
                      });
                    },
                    validator: (value) => value == null ? 'กรุณาเลือกตำแหน่ง' : null,
                    items: roles.map<DropdownMenuItem<String>>((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'อีเมล'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกอีเมล';
                      }
                      email = value;
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'รหัสผ่าน',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureTextPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureTextPassword = !_obscureTextPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureTextPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกรหัสผ่าน';
                      }
                      password = value;
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'ยืนยันรหัสผ่าน',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureTextConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureTextConfirmPassword,
                    validator: (value) {
                      if (value == null || value != password) {
                        return 'พาสเวิร์ดไม่ตรงกัน!!';
                      }
                      confirmPassword = value;
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _signupUser().then((error) {
                          if (error == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('สมัครสมาชิกสำเร็จ')),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()), // เปลี่ยน LoginScreen() ให้เป็นหน้าล็อกอินของคุณ
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error)),
                            );
                          }
                        });
                      }
                    },
                    child: Text('สมัครสมาชิก'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}