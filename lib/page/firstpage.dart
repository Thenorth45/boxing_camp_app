import 'dart:convert';
import 'package:boxing_camp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Firstpage extends StatefulWidget {
  final String? username;
  const Firstpage({super.key, this.username});

  @override
  _FirstpageState createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  late Future<List<User>> futureUsers;
  late String? username;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
    username = widget.username;
  }

  Future<List<User>> fetchUsers() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/users'),
      headers: {
        'Content-Type': 'application/json',
        'Cache-Control': 'no-cache',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> usersJson = json.decode(response.body);
      // Filter users with role "นักมวย"
      final List<User> users = usersJson
          .map((json) => User.fromJson(json))
          .where((user) => user.role == 'นักมวย')
          .toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Cache-Control': 'no-cache',
      },
    );
    if (response.statusCode == 200) {
      // Successfully deleted
      setState(() {
        futureUsers = fetchUsers(); // Refresh the user list
      });
    } else {
      throw Exception('Failed to delete user');
    }
  }

  void _editUser(User user) {
    // Handle user edit logic here
    // For example, navigate to an edit page and pass user data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(248, 158, 25, 1),
        title: Text(
          'รายชื่อนักมวย',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editUser(users[index]),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _confirmDelete(users[index]),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _confirmDelete(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${user.fullname}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // deleteUser(user.id); // Call deleteUser method
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class User {
  // final String id; // Added id field
  final String fullname;
  final String email;
  final String role; // Added role field

  User({
    // required this.id, // Include id in constructor
    required this.fullname,
    required this.email,
    required this.role, // Include role in constructor
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // id: json['_id']['\$oid'], // Assuming the ID is stored in this format
      fullname: json['fullname'],
      email: json['email'],
      role: json['role'], // Parse role from JSON
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Firstpage(),
  ));
}
