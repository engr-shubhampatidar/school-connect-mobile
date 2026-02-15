import 'package:flutter/material.dart';

class RequestLeaveProvider extends ChangeNotifier {
  String? leaveType;
  DateTime? startDate;
  DateTime? endDate;
  String reason = '';
  String? attachmentPath;
  String? attachmentName;

  void setLeaveType(String? v) {
    leaveType = v;
    notifyListeners();
  }

  void setStartDate(DateTime? d) {
    startDate = d;
    _updateDurationIfNeeded();
    notifyListeners();
  }

  void setEndDate(DateTime? d) {
    endDate = d;
    _updateDurationIfNeeded();
    notifyListeners();
  }

  void setReason(String v) {
    reason = v;
    notifyListeners();
  }

  void setAttachment(String? path, {String? name}) {
    attachmentPath = path;
    attachmentName = name ?? (path != null ? path.split('/').last : null);
    notifyListeners();
  }

  void clearAttachment() {
    attachmentPath = null;
    attachmentName = null;
    notifyListeners();
  }

  int get durationDays {
    if (startDate == null || endDate == null) return 0;
    return endDate!.difference(startDate!).inDays.abs() + 1;
  }

  void _updateDurationIfNeeded() {
    // placeholder for derived updates (e.g., validations)
  }

  Future<void> submit() async {
    // TODO: wire API call here
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
