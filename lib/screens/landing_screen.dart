import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // To parse JSON
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool isLogin = true; // Toggle between Login & Sign-Up
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> handleAuth() async {  // ✅ FIX: Added `Future<void>`
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = emailController.text;
    String password = passwordController.text;

    String apiUrl = isLogin
        ? "http://10.0.2.2:5000/login" // Use "127.0.0.1:5000" if testing outside an emulator
        : "http://10.0.2.2:5000/signup";

    Map<String, String> body = {"email": email, "password": password};

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String token = data["token"];
        print("✅ Authentication successful: $token");

        await prefs.setString("auth_token", token); // Save token for session

        // Navigate to home screen
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        var errorData = jsonDecode(response.body);
        showError(errorData["message"]);
      }
    } catch (e) {
      showError("Server error, please try again later.");
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome to Articulate")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLogin ? "Sign In" : "Create an Account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            if (!isLogin) ...[
              SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Confirm Password"),
              ),
            ],
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: handleAuth, // ✅ FIX: Calls the function correctly
              child: Text(isLogin ? "Login" : "Sign Up"),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin ? "Don't have an account? Sign up" : "Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
