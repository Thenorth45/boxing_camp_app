import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  _FirstpageState createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  Future<List<User>> fetchUsers() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/boxerdata'),
      headers: {
      'Content-Type': 'application/json',
      'Cache-Control': 'no-cache',
    },
    );

    if (response.statusCode == 200) {
      final List<dynamic> usersJson = json.decode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
      ),
      body: Center(
        child: FutureBuilder<List<User>>(
          future: futureUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data found');
            } else {
              final users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(users[index].fullname),
                    subtitle: Text(users[index].email),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class User {
  final String fullname;
  final String email;

  User({
    required this.fullname,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullname: json['fullname'],
      email: json['email'],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Firstpage(),
  ));
}
