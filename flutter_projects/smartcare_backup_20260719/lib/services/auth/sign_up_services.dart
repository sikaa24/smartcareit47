import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api_config.dart';

class SignUpService {
  SignUpService._();

  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String middleName,
    required String lastName,
    required String dateOfBirth,
    required String gender,
    required String email,
    required String password,
    required String phone,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/auth/register.php');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'email': email,
        'password': password,
        'phone': phone,
      }),
    );

    final Map<String, dynamic> body = jsonDecode(response.body);

    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to create account.');
    }

    return body['user'] as Map<String, dynamic>;
  }
}
