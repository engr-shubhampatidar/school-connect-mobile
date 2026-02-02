import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schoolconnect/constants/ApiServer.dart';
import 'package:schoolconnect/model.dart/attendanceclass.dart';

class AttendanceProvider extends ChangeNotifier {
  List<AttendanceClass> attendances = [];
  AttendanceClass? attendance; // keep for compatibility
  bool loading = false;
  String? error;

  Future<void> fetchAttendance({String? classId, String? date}) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      // build uri with optional query params
      final uri = Uri.parse(Apiserver.attendanceclass).replace(
        queryParameters: {
          if (classId != null && classId.isNotEmpty) 'classId': classId,
          if (date != null && date.isNotEmpty) 'date': date,
        },
      );
      debugPrint('AttendanceProvider: fetching $uri');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      debugPrint(
        'AttendanceProvider: auth_token=${token == null ? 'null' : 'REDACTED'}',
      );
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        // headers['x-auth-token'] = token;
      } else {
        debugPrint('AttendanceProvider: no auth token found in prefs');
      }
      final res = await http.get(uri, headers: headers);
      debugPrint('AttendanceProvider: response status ${res.statusCode}');
      // If server returns an empty body (200 but no content), treat as no attendance
      if (res.body.trim().isEmpty) {
        debugPrint(
          'AttendanceProvider: empty response body, treating as no attendance',
        );
        attendances = [];
        attendance = null;
        loading = false;
        notifyListeners();
        return;
      }

      try {
        final parsed = json.decode(res.body);
        final pretty = const JsonEncoder.withIndent('  ').convert(parsed);
        debugPrint('AttendanceProvider: response body (pretty):\n$pretty');
      } catch (e) {
        debugPrint('AttendanceProvider: response body (raw): ${res.body}');
      }

      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        List<dynamic> list = [];
        if (body is List) {
          list = body;
        } else if (body is Map) {
          if (body['data'] is List) {
            list = body['data'];
          } else {
            list = [body];
          }
        }

        attendances = list
            .whereType<Map<String, dynamic>>()
            .map((e) => AttendanceClass.fromJson(e))
            .toList();
        attendance = attendances.isNotEmpty ? attendances.first : null;

        try {
          final pretty = const JsonEncoder.withIndent(
            '  ',
          ).convert(attendances.map((a) => a.toJson()).toList());
          debugPrint(
            'AttendanceProvider: parsed attendances (pretty):\n$pretty',
          );
        } catch (_) {
          debugPrint(
            'AttendanceProvider: parsed attendances (count): ${attendances.length}',
          );
        }
      } else {
        error = 'Server error: ${res.statusCode}';
        debugPrint('AttendanceProvider: $error');
      }
    } catch (e) {
      error = e.toString();
      debugPrint('AttendanceProvider: exception $error');
    }
    loading = false;
    notifyListeners();
  }

  /// Submit attendance for a class on a given date.
  /// If [attendanceId] is provided, attempts to update existing attendance (PUT),
  /// otherwise creates a new attendance record (POST).
  /// Expects `students` as a list of maps with keys: 'studentId' and 'status'.
  Future<bool> submitAttendance({
    required String classId,
    required String date,
    required List<Map<String, String>> students,
    String? attendanceId,
  }) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final uri = attendanceId != null && attendanceId.isNotEmpty
          ? Uri.parse('${Apiserver.attendance}/$attendanceId')
          : Uri.parse(Apiserver.attendance);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final body = {'classId': classId, 'date': date, 'students': students};

      final payload = json.encode(body);
      debugPrint('AttendanceProvider: submitting to $uri');
      debugPrint('AttendanceProvider: payload: $payload');

      final res = attendanceId != null && attendanceId.isNotEmpty
          ? await http.put(uri, headers: headers, body: payload)
          : await http.post(uri, headers: headers, body: payload);

      debugPrint('AttendanceProvider: submit response ${res.statusCode}');
      if (res.statusCode == 200 || res.statusCode == 201) {
        // refresh attendance for this class/date
        await fetchAttendance(classId: classId, date: date);
        loading = false;
        notifyListeners();
        return true;
      } else {
        error = 'Failed to submit attendance: ${res.statusCode}';
        debugPrint('AttendanceProvider: $error');
      }
    } catch (e) {
      error = e.toString();
      debugPrint('AttendanceProvider: exception $error');
    }
    loading = false;
    notifyListeners();
    return false;
  }
}
