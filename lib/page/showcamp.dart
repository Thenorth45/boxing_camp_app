import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApiService {
  final String baseUrl = 'http://localhost:3000/getcamp';

  Future<List<dynamic>> fetchCamps() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load camps');
    }
  }
}

class CampsScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  Future<List<dynamic>> _fetchCamps() async {
    return await apiService.fetchCamps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ค่ายมวย',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        backgroundColor: Color.fromARGB(248, 158, 25, 1),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchCamps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No camps available'));
          } else {
            final camps = snapshot.data!;
            return ListView.builder(
              itemCount: camps.length,
              itemBuilder: (context, index) {
                final camp = camps[index];
                return ListTile(
                  title: Text(camp['name']),
                  subtitle: Text(camp['description']),
                  trailing: Text(
                      'Lat: ${camp['location']['latitude']}, Long: ${camp['location']['longitude']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
