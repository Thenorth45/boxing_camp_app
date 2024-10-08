import 'dart:convert';
import 'package:boxing_camp_app/main.dart';
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

  Future<void> deleteUser(String id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/boxerdata/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Cache-Control': 'no-cache',
      },
    );
    print(id);
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
        title: Text('User Data'),
      ),
      drawer: const AppDrawer(),
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
                deleteUser(user.id);
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
  final String id;
  final String fullname;
  final String email;

  User({
    required this.id,
    required this.fullname,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id']['\$oid'],
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
