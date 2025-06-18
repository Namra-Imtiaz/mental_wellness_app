import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  // Change these URLs based on your deployment environment
  final String baseUrl =
      kIsWeb
          ? 'http://127.0.0.1:5000' // For web testing
          : 'http://192.168.0.107:5000'; // For Android emulator accessing localhost

  // Device ID storage key
  static const String _deviceIdKey = 'device_id';

  // Get device ID for tracking rate limits
  Future<String> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);

    if (deviceId == null) {
      // Generate a new device ID if not found
      deviceId = await _generateDeviceId();
      await prefs.setString(_deviceIdKey, deviceId);
    }

    return deviceId;
  }

  // Generate a device ID based on platform
  Future<String> _generateDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      return const Uuid().v4();
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else {
      return const Uuid().v4();
    }
  }

  // Send message to backend and get response
  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final deviceId = await _getDeviceId();

      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {'Content-Type': 'application/json', 'X-Device-Id': deviceId},
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {'success': true, 'data': responseData['response']};
      } else if (response.statusCode == 429) {
        return {
          'success': false,
          'error':
              'You\'ve reached the maximum number of messages per hour. Please try again later.',
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to get response from AI. Please try again.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Connection error. Please check your internet connection.',
      };
    }
  }       
}
