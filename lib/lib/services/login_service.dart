import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = "http://127.0.0.1:5000";  // Replace with your Flask server

  Future<Map<String, dynamic>> login(String email, String password) async {
    final Uri url = Uri.parse("$baseUrl/login");
    final Map<String, String> headers = {"Content-Type": "application/json"};
    final Map<String, String> body = {"email": email, "password": password};

    try {
      final response = await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);  // Success
      } else {
        return {"error": jsonDecode(response.body)["message"]};  // Handle errors
      }
    } catch (e) {
      return {"error": "Server error: ${e.toString()}"};
    }
  }
}
