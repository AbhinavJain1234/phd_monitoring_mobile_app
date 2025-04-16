import "dart:convert";
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phd_monitoring_mobile_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

Future<Map<String, dynamic>> fetchData({
  required String url,
  String method = 'GET',
  dynamic body,
  bool isFormData = false,
  bool showToast = true,
  required BuildContext context,
}) async {
  try {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final headers = {
      'Authorization': 'Bearer ${userProvider.user?.token}',
      'Accept': 'application/json',
    };

    if (!isFormData) {
      headers['Content-Type'] = 'application/json';
    }

    http.Request request = http.Request(method, Uri.parse(url));
    request.headers.addAll(headers);

    if (method != 'GET' && method != 'HEAD') {
      if (isFormData) {
        // For form data, you can use the `http.MultipartRequest` class
        http.MultipartRequest multipartRequest =
            http.MultipartRequest(method, Uri.parse(url));
        multipartRequest.headers.addAll(headers);
        multipartRequest.fields.addAll(body);
        request = (await multipartRequest.send()) as http.Request;
      } else {
        request.body = jsonEncode(body);
      }
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {'success': true, 'response': jsonDecode(responseBody)};
    } else {
      final errorData = jsonDecode(responseBody);
      _handleError(
          context, response.statusCode, errorData, showToast, userProvider);
      return {'success': false, 'response': errorData};
    }
  } catch (e) {
    _showToast(context, 'Unexpected error: $e');
    return {'success': false, 'response': e};
  }
}

void _showToast(BuildContext context, String message) {
  // Implement your toast notification logic here
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 10),
    ),
  );
}

void _handleError(BuildContext context, int statusCode, dynamic errorData,
    bool showToast, UserProvider userProvider) {
  if (statusCode == 422) {
    if (showToast) _showToast(context, errorData['message']);
  } else if (statusCode == 401) {
    if (showToast) _showToast(context, errorData['error']);
    // Navigate to login screen
    Navigator.of(context).pushNamed('/login');
    userProvider.logout(); // Log the user out
  } else if (statusCode == 500) {
    if (showToast) _showToast(context, 'Internal server error');
  } else if (statusCode == 400) {
    String errorString = '';
    errorData.forEach((key, value) {
      errorString += '$key: $value\n';
    });
    if (showToast) _showToast(context, errorString);
  } else {
    if (showToast) _showToast(context, errorData['message']);
  }
}
