
import 'package:phd_monitoring_mobile_app/model/user_role.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String gender;
  final int roleId;
  final String status;
  final String? profilePicture;
  final UserRole role;
  final List<UserRole> availableRoles;
  final String token;

  User({
    this.id = 0,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.gender,
    this.roleId = 0,
    this.status = 'active',
    this.profilePicture,
    required this.role,
    required this.availableRoles,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json, String token) {
    Map<String, dynamic> userJson =
        json.containsKey('user') ? json['user'] : json;

    return User(
      firstName: userJson['first_name'] ?? '',
      lastName: userJson['last_name'] ?? '',
      phone: userJson['phone'] ?? '',
      email: userJson['email'] ?? '',
      gender: userJson['gender'] ?? '',
      role: _parseRole(userJson['role']?['role'] ?? ''),
      availableRoles: (json['available_roles'] as List<dynamic>?)
              ?.map((role) => _parseRole(role.toString()))
              .toList() ??
          [],
      token: token,
    );
  }

  get rollNo => null;

  static UserRole _parseRole(String roleString) {
    switch (roleString.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'phd_coordinator':
        return UserRole.phdCoordinator;
      case 'faculty':
        return UserRole.faculty;
      case 'hod':
        return UserRole.hod;
      case 'dra':
        return UserRole.dra;
      case 'dordc':
        return UserRole.dordc;
      case 'director':
        return UserRole.director;
      default:
        return UserRole.guest;
    }
  }
}
