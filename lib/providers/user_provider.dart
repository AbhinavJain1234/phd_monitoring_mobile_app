import 'package:flutter/material.dart';
import 'package:phd_monitoring_mobile_app/model/user.dart';
import 'package:phd_monitoring_mobile_app/model/user_role.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// UserProvider manages authentication, user info, role-based access,
/// and persistent storage using SharedPreferences.
class UserProvider extends ChangeNotifier {
  User? _user; // Holds the current logged-in user

  User? get user => _user; // Getter for user object
  bool get isAuthenticated => _user != null; // True if a user is logged in

  bool _isInitialized = false; // True once initialization is complete
  bool get isInitialized => _isInitialized;

  // Role-based access checks
  bool get isStudent => _user?.role == UserRole.student;
  bool get isFaculty => _user?.role == UserRole.faculty;
  UserRole? get currentRole => _user?.role;


  /// Loads user data from SharedPreferences during app startup
  Future<void> initializeUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    _isInitialized = true;

    if (userData != null) {
      try {
        final data = json.decode(userData);
        _user = User.fromJson(data['user_data'], data['token']);
      } catch (e) {
        // Handle corrupted or invalid data
        print('Error initializing user data: $e');
        await prefs.remove('user_data');
      }
    }

    notifyListeners(); // Notify UI about changes
  }

  /// Saves user data to memory and SharedPreferences
  Future<void> setUser(Map<String, dynamic> userData, String token) async {
    _user = User.fromJson(userData, token);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'user_data',
      json.encode({
        'user_data': userData,
        'token': token,
      }),
    );

    notifyListeners(); // Notify UI about new user
  }

  /// Updates the user's role (implementation placeholder)
  Future<void> updateRole(UserRole newRole) async {
    if (_user != null) {
      // Future: Update the _user's role and persist it if needed
      notifyListeners(); // Notify UI after role change
    }
  }

  /// Logs out the user and clears SharedPreferences
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data'); // Clear saved data
    _user = null;

    notifyListeners(); // Notify UI about logout
  }
}
