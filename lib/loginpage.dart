import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minor/dashboard.dart';
import 'package:minor/components/mytext_field.dart'; // Import the necessary files, adjust the path accordingly
import 'package:minor/forgot_password.dart';
import 'package:minor/register.dart'; // Import RegisterPage if not imported

class LoginPage extends StatelessWidget {
  LoginPage();

  // text editing controller
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signUserIn(BuildContext context) async {
    final String apiUrl = 'http://127.0.0.1:8000/auth/jwt/create/';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Authentication successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else {
      // Authentication failed, show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Authentication Failed"),
            content: Text("Invalid username or password."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                'Smart Home',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Empower your Living!!!',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 10),
              const Icon(
                Icons.home_work_outlined,
                size: 80,
              ),
              SizedBox(height: 20),
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obsecureText: false,
                obscureText: false,
              ),
              SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obsecureText: true,
                obscureText: true,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()),
                        );
                      },
                      child: Text('Forgot Password?',
                          style: TextStyle(
                              color: Colors.black, fontSize: 17)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[200],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: 130,
                child: ElevatedButton(
                    onPressed: () {
                      signUserIn(context);
                    },
                    child: Text('Sign In',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    )),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?',
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                  SizedBox(width: 4),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    child: Text('Register now',
                        style:
                        TextStyle(fontSize: 20, color: Colors.black87)),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
