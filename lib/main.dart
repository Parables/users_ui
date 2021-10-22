import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey formKey = GlobalKey();

  TextEditingController usernameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  var url = Uri.parse('https://lion-feed.cyclic-app.com/users');

  var allUsers = [];

  void createNewUser() async {
    // get the values from controllers
    var newUser = {
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text,
    };

    print('Posting this: $newUser');

    // make a post request to the parsed URL
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newUser));

    // print out the response of the request
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  void fetchAllUsers() async {
    var response = await http.get(url);
    // print out the response of the request
    print('Response status: ${response.body}');
    setState(() {
      allUsers = jsonDecode(response.body);
    });
    // print('Response body: ${response');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      hintText: "Enter your nickname", labelText: "Username"),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "Enter your email", labelText: "Email"),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      hintText: "Enter your password", labelText: "Password"),
                ),
                ElevatedButton(
                  onPressed: () {
                    createNewUser();
                  },
                  child: Text('CREATE ACCOUNT'),
                ),
                ElevatedButton(
                  onPressed: () {
                    fetchAllUsers();
                  },
                  child: Text('Fetch Users'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Text(allUsers[index]['_id']);
                    },
                    itemCount: allUsers.length,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
