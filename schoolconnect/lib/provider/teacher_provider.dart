import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schoolconnect/constants/ApiServer.dart';
import 'package:schoolconnect/model.dart/teacherclass.dart';

class TeacherProvider extends ChangeNotifier {
  TeacherClass? teacherClass;
  bool loading = false;
  String? error;

  Future<void> fetchTeacherClass() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      debugPrint('TeacherProvider: fetching ${Apiserver.teacherclass}');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      final res = await http.get(
        Uri.parse(Apiserver.teacherclass),
        headers: headers,
      );
      debugPrint('TeacherProvider: status ${res.statusCode}');
      try {
        final parsed = json.decode(res.body);
        debugPrint(
          'TeacherProvider: body ${const JsonEncoder.withIndent('  ').convert(parsed)}',
        );
      } catch (_) {
        debugPrint('TeacherProvider: body raw: ${res.body}');
      }
      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        Map<String, dynamic> data;
        if (body is Map<String, dynamic>) {
          data = body;
        } else {
          error = 'Unexpected format for teacher class';
          loading = false;
          notifyListeners();
          return;
        }

        teacherClass = TeacherClass.fromJson(data);
      } else {
        error = 'Server error: ${res.statusCode}';
      }
    } catch (e) {
      error = e.toString();
      debugPrint('TeacherProvider: exception $error');
    }
    loading = false;
    notifyListeners();
  }
}
