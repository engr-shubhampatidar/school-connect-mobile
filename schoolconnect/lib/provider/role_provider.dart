

import 'package:schoolconnect/export.dart';

export 'package:flutter/material.dart';
enum UserRole { admin, teacher, student }

class RoleProvider extends ChangeNotifier {
  UserRole _selectedRole = UserRole.admin;

  UserRole get selectedRole => _selectedRole;

  void selectRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }
}
