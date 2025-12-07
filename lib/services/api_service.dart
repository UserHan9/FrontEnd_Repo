import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Adjust this based on your emulator/device
  // Android Emulator: 'http://10.0.2.2:8080'
  // iOS Simulator / Windows / Web: 'http://localhost:8080'
  static String get baseUrl {
    if (kIsWeb) return 'https://spring.alzee23.com/api';
    if (defaultTargetPlatform == TargetPlatform.android) {
       return 'https://spring.alzee23.com/api'; 
    }
    return 'https://spring.alzee23.com/api';
  }

  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'auth_username';

  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // --- Auth ---

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveAuth(data['token'], data['username']);
      return data;
    } else {
      throw Exception(_parseError(response));
    }
  }

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _saveAuth(data['token'], data['username']);
      return data;
    } else {
      throw Exception(_parseError(response));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
  }

  // --- Storage Helpers ---

  Future<void> _saveAuth(String token, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usernameKey, username);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // --- Tracking ---

  Future<String> updateTracking(String vendorId, double lat, double lng) async {
    final url = Uri.parse('$baseUrl/api/tracking/update');
    final headers = await _getHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'vendorId': vendorId,
        'latitude': lat,
        'longitude': lng,
      }),
    );

    if (response.statusCode == 200) {
      return response.body; // "Location received and logged"
    } else {
      throw Exception(_parseError(response));
    }
  }

  // --- Sales ---

  Future<String> recordSale(String vendorId) async {
    final url = Uri.parse('$baseUrl/api/sales/record');
    final headers = await _getHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({'vendorId': vendorId}),
    );

    if (response.statusCode == 200) {
      return response.body; // "Counter ++ Success"
    } else {
      throw Exception(_parseError(response));
    }
  }

  // --- Route Advice ---

  Future<Map<String, dynamic>> getRouteAdvice(String vendorId) async {
    final url = Uri.parse('$baseUrl/api/route/advice?vendorId=$vendorId');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(_parseError(response));
    }
  }

  // --- Hello/User ---

  Future<String> getHelloUser() async {
    final url = Uri.parse('$baseUrl/api/hello/user');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Hello';
    } else {
      throw Exception(_parseError(response));
    }
  }

  String _parseError(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Unknown error';
    } catch (e) {
      return 'Error ${response.statusCode}: ${response.body}';
    }
  }
}
