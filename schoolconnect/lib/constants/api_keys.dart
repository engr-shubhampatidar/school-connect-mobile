// JSON key constants aligned to the `NewLeaveManagementScreen` UI model.
// Keys use camelCase to match the Dart models shown in the screen.

class ApiKeys {
  // Common
  static const String id = 'id';

  // Leave (user leaves)
  // Matches `_LeaveRequest` fields used in the UI
  static const String dateRange = 'dateRange';
  static const String type = 'type';
  static const String appliedDate = 'appliedDate';
  static const String reason = 'reason';
  static const String status = 'status';

  // Optional: backend might provide ISO dates
  static const String startDate = 'startDate';
  static const String endDate = 'endDate';

  // Student request specific (matches `_StudentRequest`)
  static const String name = 'name';
  static const String gradeRoll = 'gradeRoll';
  static const String leaveType = 'leaveType';
}

class ApiStatus {
  static const String approved = 'approved';
  static const String pending = 'pending';
  static const String rejected = 'rejected';
}

/// Simple mapper helpers to convert JSON maps (from API) to the
/// UI-friendly field names used in `NewLeaveManagementScreen`.
///
/// Use these if the backend returns keys in snake_case; they will
/// normalize keys to camelCase expected by the app. If backend already
/// returns camelCase, you can pass through the map unchanged.
class ApiMappers {
  /// Converts keys from snake_case to camelCase for known fields.
  static Map<String, dynamic> normalize(Map<String, dynamic> json) {
    final Map<String, dynamic> out = {};

    // Helper to prefer existing camelCase, otherwise read snake_case
    dynamic pick(String camel, String snake) => json[camel] ?? json[snake];

    out[ApiKeys.id] = pick(ApiKeys.id, 'id');
    out[ApiKeys.dateRange] =
        pick(ApiKeys.dateRange, 'date_range') ?? _tryBuildDateRange(json);
    out[ApiKeys.type] = pick(ApiKeys.type, 'type');
    out[ApiKeys.appliedDate] = pick(ApiKeys.appliedDate, 'applied_date');
    out[ApiKeys.reason] = pick(ApiKeys.reason, 'reason');
    out[ApiKeys.status] = pick(ApiKeys.status, 'status');

    out[ApiKeys.startDate] = pick(ApiKeys.startDate, 'start_date');
    out[ApiKeys.endDate] = pick(ApiKeys.endDate, 'end_date');

    out[ApiKeys.name] = pick(ApiKeys.name, 'name');
    out[ApiKeys.gradeRoll] = pick(ApiKeys.gradeRoll, 'grade_roll');
    out[ApiKeys.leaveType] = pick(ApiKeys.leaveType, 'leave_type');

    return out;
  }

  // If API returns start_date and end_date, build a human-friendly range.
  static String? _tryBuildDateRange(Map<String, dynamic> json) {
    final s = json['start_date'] ?? json['startDate'];
    final e = json['end_date'] ?? json['endDate'];
    if (s != null && e != null) return '$s - $e';
    return null;
  }
}
