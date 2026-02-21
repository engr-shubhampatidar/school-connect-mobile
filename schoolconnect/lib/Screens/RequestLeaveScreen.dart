import 'package:flutter/material.dart';
import 'package:schoolconnect/export.dart';
// import 'package:shadcn_ui/shadcn_ui.dart' hide LucideIcons; // not used here

enum LeaveStatus { none, approve, reject, pending }

class RequestLeaveScreen extends StatefulWidget {
  const RequestLeaveScreen({super.key});

  @override
  State<RequestLeaveScreen> createState() => _RequestLeaveScreenState();
}

class _RequestLeaveScreenState extends State<RequestLeaveScreen> {
  LeaveStatus _status = LeaveStatus.none;

  void _setStatus(LeaveStatus status) {
    setState(() {
      _status = _status == status ? LeaveStatus.none : status;
    });
  }

  void _onSubmit() {
    final label = _status == LeaveStatus.none
        ? 'No selection made'
        : 'Request: ${_status.name.toUpperCase()}';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: MyColor.color021034,
            fontWeight: FontWeight.w600,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Request Leave',
          style: TextStyle(
            color: MyColor.color021034,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Simple info card / placeholder
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MyColor.colorD7E3FC, width: 1.2),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFEAF1FF),
                    child: Image.asset(
                      AssetsImages.loginperson,
                      width: 36,
                      height: 36,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Student Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: MyColor.myblack,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Class 5 - Section A',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Select the leave type below (buttons match AttendanceStatus UI)',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 18),

            // Buttons container matching TakeAttendanceScreen
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD7E3FC)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _setStatus(LeaveStatus.approve),
                    child: Container(
                      width: 36,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _status == LeaveStatus.approve
                            ? MyColor.color16A34A
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _status == LeaveStatus.approve
                              ? MyColor.color16A34A
                              : MyColor.transparent,
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        color: _status == LeaveStatus.approve
                            ? Colors.white
                            : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _setStatus(LeaveStatus.reject),
                    child: Container(
                      width: 36,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _status == LeaveStatus.reject
                            ? MyColor.colorE11D48
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _status == LeaveStatus.reject
                              ? MyColor.colorE11D48
                              : MyColor.transparent,
                        ),
                      ),
                      child: Icon(
                        Icons.close,
                        color: _status == LeaveStatus.reject
                            ? Colors.white
                            : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _setStatus(LeaveStatus.pending),
                    child: Container(
                      width: 36,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _status == LeaveStatus.pending
                            ? MyColor.colorF59E0B
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _status == LeaveStatus.pending
                              ? MyColor.colorF59E0B
                              : MyColor.transparent,
                        ),
                      ),
                      child: Icon(
                        Icons.access_time,
                        color: _status == LeaveStatus.pending
                            ? Colors.white
                            : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom buttons similar to TakeAttendanceScreen
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(AppStrings.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A1F44),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Request Leave',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.info_outline, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  AppStrings.editableNote,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
