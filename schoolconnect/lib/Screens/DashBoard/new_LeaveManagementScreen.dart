import 'package:flutter/material.dart';
import 'package:schoolconnect/Screens/DashBoard/StudentReviewRequest.dart';
import 'package:schoolconnect/constants/Mycolor.dart';
import 'package:provider/provider.dart';
import 'package:schoolconnect/provider/leave_provider.dart';
import 'package:schoolconnect/Screens/DashBoard/RequestLeaveScreen.dart';
import 'package:schoolconnect/constants/strings.dart';

class NewLeaveManagementScreen extends StatefulWidget {
  const NewLeaveManagementScreen({Key? key}) : super(key: key);

  @override
  State<NewLeaveManagementScreen> createState() =>
      _NewLeaveManagementScreenState();
}

class _NewLeaveManagementScreenState extends State<NewLeaveManagementScreen> {
  // selected index is now managed by LeaveProvider

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorF5F6FA,
      appBar: AppBar(
        surfaceTintColor: MyColor.colorF5F6FA,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          AppStrings.leaveManagementTitle,
          style: const TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/dashboard',
            (route) => false,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: SizedBox(
              height: 48,
              child: Container(
                decoration: BoxDecoration(
                  color: MyColor.colorF5F9FF,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: MyColor.colorD7E3FC, width: 2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            context.read<LeaveProvider>().selectIndex(0),
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.centerLeft,
                          decoration:
                              context.watch<LeaveProvider>().selectedIndex == 0
                              ? BoxDecoration(
                                  color: MyColor.colorEEF4FF,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: MyColor.colorD7E3FC,
                                    width: 1.6,
                                  ),
                                )
                              : null,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 18,
                                color:
                                    context
                                            .watch<LeaveProvider>()
                                            .selectedIndex ==
                                        0
                                    ? MyColor.color021034
                                    : MyColor.color64748B,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                AppStrings.myLeaves,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      context
                                              .watch<LeaveProvider>()
                                              .selectedIndex ==
                                          0
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: MyColor.color021034,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            context.read<LeaveProvider>().selectIndex(1),
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.centerLeft,
                          decoration:
                              context.watch<LeaveProvider>().selectedIndex == 1
                              ? BoxDecoration(
                                  color: MyColor.colorEEF4FF,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: MyColor.colorD7E3FC,
                                    width: 1.6,
                                  ),
                                )
                              : null,
                          child: Text(
                            AppStrings.studentRequests,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  context
                                          .watch<LeaveProvider>()
                                          .selectedIndex ==
                                      1
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: MyColor.color021034,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: context.watch<LeaveProvider>().selectedIndex == 0
                ? _buildMyLeaves(context)
                : _buildStudentRequests(context),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: context.watch<LeaveProvider>().selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RequestLeaveScreen(),
                  ),
                );
              },
              backgroundColor: MyColor.myblack,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildMyLeaves(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  AppStrings.paidLeave,
                  '02',
                  AppStrings.paidLeaveSubtitle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  AppStrings.totalUsed,
                  '17',
                  AppStrings.totalUsedSubtitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _leaveTypeCard(
                  'Casual Leave',
                  '10',
                  '3 Complete 7 Remaining',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _leaveTypeCard(
                  'Sick Leave',
                  '05',
                  '3 Complete 2 Remaining',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.recentLeaveRequests,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Column(
            children: List.generate(
              _mockRequests.length,
              (i) => _requestTile(_mockRequests[i]),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.pendingStudentRequests,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.lock_outline, color: Colors.grey),
                const SizedBox(height: 8),
                Text(
                  AppStrings.switchTabsMessage,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStudentRequests(BuildContext context) {
    // Keep the search/filter row fixed and make only the request cards scrollable.
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: MyColor.colorE7EEF9),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                          ).copyWith(hintText: AppStrings.searchHint),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE6EEF9)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune, color: Colors.grey),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),

        // The list of student request cards — scrollable area
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            children: [
              const SizedBox(height: 4),
              ...List.generate(
                _studentRequests.length,
                (i) => _studentRequestCard(_studentRequests[i], i),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  Widget _studentRequestCard(_StudentRequest r, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MyColor.colorDBEAFF),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header with light blue background
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentReviewRequest(
                    // studentName: r.name,
                    // gradeRoll: r.gradeRoll,
                    // dateRange: r.dateRange,
                    // leaveType: r.leaveType,
                    // reason: r.reason,
                    // status: r.status,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MyColor.colorF5F9FF,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: MyColor.colorF4E8FF,
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r.gradeRoll,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusPill(r.status),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                r.dateRange,
                style: TextStyle(
                  color: MyColor.color475569,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Text(
                r.leaveType,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"${r.reason}"',
            style: TextStyle(color: MyColor.color475569, fontSize: 16),
          ),
          const SizedBox(height: 14),
          // actions: Reject (left) and Approve (right)
          if (r.status == _RequestStatus.pending)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _setRequestStatus(index, _RequestStatus.pending),
                    icon: const Icon(Icons.close, color: MyColor.red),
                    label: Text(
                      AppStrings.reject,
                      style: const TextStyle(
                        color: MyColor.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: MyColor.redF5F4F4),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _setRequestStatus(index, _RequestStatus.approved),
                    icon: const Icon(Icons.check, color: MyColor.green),
                    label: Text(
                      AppStrings.approve,
                      style: const TextStyle(
                        color: MyColor.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: MyColor.colorDCFCE6),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColor.colorF4F4F5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    AppStrings.takeAction,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _setRequestStatus(int index, _RequestStatus s) {
    setState(() {
      _studentRequests[index].status = s;
    });
  }

  Widget _summaryCard(String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD6E8FF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A2540).withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.black54)),
              const Icon(Icons.credit_card, color: Colors.grey, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.green, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _leaveTypeCard(String title, String count, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD6E8FF), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Icon(Icons.event_note, color: Colors.grey, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _requestTile(_LeaveRequest r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD6E8FF)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        r.dateRange,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: MyColor.color021034,
                        ),
                      ),
                    ),
                    _statusPill(r.status),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  r.type + ' • Applied ' + r.appliedDate,
                  style: const TextStyle(color: Colors.blue, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  r.reason,
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusPill(_RequestStatus s) {
    Color bg;
    Color text;
    String label;
    switch (s) {
      case _RequestStatus.approved:
        bg = const Color(0xFFE6F6EA);
        text = const Color(0xFF2E8B57);
        label = 'Approved';
        break;
      case _RequestStatus.pending:
        bg = const Color(0xFFFFF3E0);
        text = const Color(0xFFB36B00);
        label = 'Pending';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

enum _RequestStatus { approved, pending }

class _LeaveRequest {
  final String dateRange;
  final String type;
  final String appliedDate;
  final String reason;
  final _RequestStatus status;

  _LeaveRequest(
    this.dateRange,
    this.type,
    this.appliedDate,
    this.reason,
    this.status,
  );
}

final List<_LeaveRequest> _mockRequests = [
  _LeaveRequest(
    'Oct 12 - Oct 14, 2023',
    'Casual Leave',
    'Oct 05',
    'Family function attendance',
    _RequestStatus.approved,
  ),
  _LeaveRequest(
    'Oct 12 - Oct 14, 2023',
    'Casual Leave',
    'Oct 05',
    'Family function attendance',
    _RequestStatus.approved,
  ),
  _LeaveRequest(
    'Nov 20 - Nov 21, 2023',
    'Sick Leave',
    'Nov 19',
    'Severe fever and flu',
    _RequestStatus.pending,
  ),
  _LeaveRequest(
    'Nov 20 - Nov 21, 2023',
    'Sick Leave',
    'Nov 19',
    'Severe fever and flu',
    _RequestStatus.pending,
  ),
];

class _StudentRequest {
  final String name;
  final String gradeRoll;
  final String dateRange;
  final String leaveType;
  final String reason;
  _RequestStatus status;

  _StudentRequest({
    required this.name,
    required this.gradeRoll,
    required this.dateRange,
    required this.leaveType,
    required this.reason,
    this.status = _RequestStatus.pending,
  });
}

final List<_StudentRequest> _studentRequests = [
  _StudentRequest(
    name: 'Marcus Thompson',
    gradeRoll: 'Grade 10 - B • Roll #42',
    dateRange: 'Oct 24 - Oct 25',
    leaveType: 'Medical',
    reason:
        'High fever and severe throat infection. Doctor has advised complete bed rest for 3 days.',
    status: _RequestStatus.pending,
  ),
  _StudentRequest(
    name: 'Marcus Thompson',
    gradeRoll: 'Grade 10 - B • Roll #42',
    dateRange: 'Oct 24 - Oct 25',
    leaveType: 'Sick Leave',
    reason:
        'High fever and severe throat infection. Doctor has advised complete bed rest for 3 days.',
    status: _RequestStatus.pending,
  ),
  _StudentRequest(
    name: 'Marcus Thompson',
    gradeRoll: 'Grade 10 - B • Roll #42',
    dateRange: 'Oct 24 - Oct 25',
    leaveType: 'Casual',
    reason: 'Family function attendance',
    status: _RequestStatus.approved,
  ),
];
