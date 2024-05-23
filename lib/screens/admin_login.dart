import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_metro/helper/userModelClass.dart';
import 'package:login_metro/screens/taskScreen.dart';

class AdminLoginPage extends StatelessWidget {
  final String adminEmail = 'admin@example.com';
  final String adminPassword = 'admin123';

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    void signIn(BuildContext context, String email, String password) {
      if (email == adminEmail && password == adminPassword) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskListScreen(
              user: Users(
                id: 0, // Assign an ID for admin user
                name: 'Admin', // Set name for admin
                email: adminEmail,
                isAdmin: true,
              ),
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Invalid Credentials'),
            content: Text('Please enter valid admin credentials.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Admin Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                signIn(
                  context,
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
