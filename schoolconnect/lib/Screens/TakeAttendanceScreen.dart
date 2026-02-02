import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:schoolconnect/export.dart';
import 'package:schoolconnect/model.dart/teacherclass.dart';

import 'package:schoolconnect/model.dart/attendanceclass.dart' as ac;

enum AttendanceStatus { none, present, absent, leave }

class TakeAttendanceScreen extends StatefulWidget {
  const TakeAttendanceScreen({super.key});

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  List<AttendanceStatus> _statuses = [];
  List<Student> _students = [];
  DateTime _selectedDate = DateTime.now();
  // saved statuses removed (not used)

  void _setStatus(int index, AttendanceStatus status) {
    setState(() {
      _statuses[index] = _statuses[index] == status
          ? AttendanceStatus.none
          : status;
    });
  }

  Future<void> _onSavePressed() async {
    final ap = context.read<AttendanceProvider>();
    if (ap.loading) return;

    // build students payload
    final prov = context.read<TeacherProvider>();
    final classId = prov.teacherClass?.classInfo.id ?? '';
    final List<Map<String, String>> studentsPayload = [];
    for (var i = 0; i < _students.length; i++) {
      final s = _students[i];
      final status = i < _statuses.length
          ? _statuses[i]
          : AttendanceStatus.none;

      // Do not auto-fill: only include students explicitly marked
      if (status == AttendanceStatus.none) continue;

      String statusStr;
      switch (status) {
        case AttendanceStatus.present:
          statusStr = 'PRESENT';
          break;
        case AttendanceStatus.absent:
          statusStr = 'ABSENT';
          break;
        case AttendanceStatus.leave:
          statusStr = 'LEAVE';
          break;
        case AttendanceStatus.none:
        default:
          statusStr = 'ABSENT';
      }
      studentsPayload.add({'studentId': s.id, 'status': statusStr});
    }

    final success = await ap.submitAttendance(
      classId: classId,
      date: _selectedDateString,
      students: studentsPayload,
      attendanceId: ap.attendance?.id,
    );

    if (success) {
      if (!mounted) return;
      _showSavedDialog();
      _syncFromProvider();
    } else {
      if (!mounted) return;
      final msg = ap.error ?? 'Failed to save attendance';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  void _showSavedDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppStrings.attendanceSavedBarrier,
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.86,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 26,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.08),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: const BoxDecoration(
                              color: Color(0xFF16A34A),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.verified,
                                color: Colors.white,
                                size: 34,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            AppStrings.attendanceSavedTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            AppStrings.attendanceSavedMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 9,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _syncFromProvider() {
    if (!mounted) return;
    final prov = context.read<TeacherProvider>();
    final students = prov.teacherClass?.students ?? [];
    // Try to get existing attendance (if any) and map statuses
    final ap = context.read<AttendanceProvider>();
    final existing = ap.attendance;
    Map<String, String> attendanceMap = {};
    if (existing?.students != null) {
      for (final s in existing!.students!) {
        if (s.studentId != null && s.status != null) {
          attendanceMap[s.studentId!] = s.status!;
        }
      }
    }
    // if same ids, no change
    final prevIds = _students.map((s) => s.id).toList();
    final newIds = students.map((s) => s.id).toList();
    if (listEquals(prevIds, newIds)) return;
    final newStatuses = List<AttendanceStatus>.filled(
      students.length,
      AttendanceStatus.none,
    );
    // If we have attendance data, prefer that to populate statuses.
    if (attendanceMap.isNotEmpty) {
      for (var i = 0; i < students.length; i++) {
        final sid = students[i].id;
        final sStat = sid != null ? attendanceMap[sid] : null;
        newStatuses[i] = _statusFromString(sStat);
      }
    } else {
      for (var i = 0; i < students.length && i < _statuses.length; i++) {
        newStatuses[i] = _statuses[i];
      }
    }
    setState(() {
      _students = students;
      _statuses = newStatuses;
    });
  }

  AttendanceStatus _statusFromString(String? s) {
    if (s == null) return AttendanceStatus.none;
    final lower = s.toLowerCase();
    if (lower == 'present' || lower == 'p') return AttendanceStatus.present;
    if (lower == 'absent' || lower == 'a') return AttendanceStatus.absent;
    if (lower == 'leave' || lower == 'l' || lower == 'onleave')
      return AttendanceStatus.leave;
    return AttendanceStatus.none;
  }

  String get _selectedDateString =>
      _selectedDate.toLocal().toIso8601String().split('T').first;

  String get _formattedSelectedDate {
    final dt = _selectedDate.toLocal();
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final weekday = weekdays[dt.weekday - 1];
    final month = months[dt.month - 1];
    return '$weekday, $month ${dt.day}.';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      final ap = context.read<AttendanceProvider>();
      await ap.fetchAttendance(
        classId: '99565b63-e04e-41a7-869a-dc8c72a051f7',
        date: _selectedDateString,
      );
      if (!mounted) return;
      _syncFromProvider();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Call attendance API first; if it's empty, fetch teacher class to show students
      final prov = context.read<TeacherProvider>();
      final ap = context.read<AttendanceProvider>();

      ap
          .fetchAttendance(
            classId: '99565b63-e04e-41a7-869a-dc8c72a051f7',
            date: "2026-02-05",
          )
          .then((_) async {
            if (!mounted) return;
            final empty =
                ap.attendance == null ||
                (ap.attendance!.students?.isEmpty ?? true);
            if (empty) {
              await prov.fetchTeacherClass();
              if (!mounted) return;
              _syncFromProvider();
            } else {
              // attendance exists; sync (UI may still fetch class later if needed)
              _syncFromProvider();
            }
          });

      // listen for future updates
      ap.addListener(_syncFromProvider);
      prov.addListener(_syncFromProvider);
    });
  }

  @override
  void dispose() {
    // remove provider listener
    try {
      if (mounted) {
        try {
          context.read<TeacherProvider>().removeListener(_syncFromProvider);
          context.read<AttendanceProvider>().removeListener(_syncFromProvider);
        } catch (_) {}
      }
    } catch (_) {}
    super.dispose();
  }

  int get _presentCount =>
      _statuses.where((s) => s == AttendanceStatus.present).length;
  int get _absentCount =>
      _statuses.where((s) => s == AttendanceStatus.absent).length;
  int get _leaveCount =>
      _statuses.where((s) => s == AttendanceStatus.leave).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          AppStrings.takeAttendance,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.grey),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AttendanceHistoryScreen(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Class info card
            Container(
              height: 89,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: MyColor.colorD7E3FC, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<TeacherProvider>(
                        builder: (context, prov, _) {
                          final ci = prov.teacherClass?.classInfo;
                          final title = ci != null
                              ? 'Class ${ci.name} - Section ${ci.section}'
                              : AppStrings.classTitle;
                          return Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 6),
                      // show formatted selected date and allow tapping to pick a new date
                      InkWell(
                        onTap: _pickDate,
                        child: Text(
                          _formattedSelectedDate,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: MyColor.colorD7E3FC, width: 1),
                    ),
                    child: Center(
                      child: const Text(
                        AppStrings.subjectScience,
                        style: TextStyle(
                          color: MyColor.myblack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            hSized16,

            // Student list card
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: MyColor.colorD7E3FC, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                // padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      height: 85,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.studentListTitle,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    AppStrings.rollNo,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    LucideIcons.filter,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            AppStrings.studentListSubtitle,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 12, color: Color(0xFFEAF1FF)),
                    const SizedBox(height: 12),

                    // students list (dynamic from TeacherProvider)
                    Expanded(
                      child: Consumer<TeacherProvider>(
                        builder: (context, prov, _) {
                          if (prov.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (prov.error != null) {
                            return Center(child: Text(prov.error!));
                          }
                          final students = prov.teacherClass?.students ?? [];
                          if (students.isEmpty) {
                            return const Center(
                              child: Text('No students available'),
                            );
                          }

                          if (_statuses.length != students.length) {
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) => _syncFromProvider(),
                            );
                          }

                          return ListView.separated(
                            itemCount: students.length,
                            separatorBuilder: (context, index) => const Divider(
                              height: 12,
                              color: Color(0xFFEAF1FF),
                            ),
                            itemBuilder: (context, index) {
                              final status = index < _statuses.length
                                  ? _statuses[index]
                                  : AttendanceStatus.none;
                              final s = students[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor: const Color(0xFFEAF1FF),
                                      backgroundImage: s.photoUrl.isNotEmpty
                                          ? NetworkImage(s.photoUrl)
                                          : AssetImage(AssetsImages.loginperson)
                                                as ImageProvider,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            s.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: MyColor.myblack,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${AppStrings.rollNo} ${s.rollNo}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 44,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF4FF),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: const Color(0xFFD7E3FC),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () => _setStatus(
                                              index,
                                              AttendanceStatus.present,
                                            ),
                                            child: Container(
                                              width: 36,
                                              height: 32,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color:
                                                    status ==
                                                        AttendanceStatus.present
                                                    ? MyColor.color16A34A
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color:
                                                      status ==
                                                          AttendanceStatus
                                                              .present
                                                      ? MyColor.color16A34A
                                                      : MyColor.transparent,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                color:
                                                    status ==
                                                        AttendanceStatus.present
                                                    ? Colors.white
                                                    : Colors.grey,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          GestureDetector(
                                            onTap: () => _setStatus(
                                              index,
                                              AttendanceStatus.absent,
                                            ),
                                            child: Container(
                                              width: 36,
                                              height: 32,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color:
                                                    status ==
                                                        AttendanceStatus.absent
                                                    ? MyColor.colorE11D48
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color:
                                                      status ==
                                                          AttendanceStatus
                                                              .absent
                                                      ? MyColor.colorE11D48
                                                      : MyColor.transparent,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                color:
                                                    status ==
                                                        AttendanceStatus.absent
                                                    ? Colors.white
                                                    : Colors.grey,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          GestureDetector(
                                            onTap: () => _setStatus(
                                              index,
                                              AttendanceStatus.leave,
                                            ),
                                            child: Container(
                                              width: 36,
                                              height: 32,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color:
                                                    status ==
                                                        AttendanceStatus.leave
                                                    ? MyColor.colorF59E0B
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color:
                                                      status ==
                                                          AttendanceStatus.leave
                                                      ? MyColor.colorF59E0B
                                                      : MyColor.transparent,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.access_time,
                                                color:
                                                    status ==
                                                        AttendanceStatus.leave
                                                    ? Colors.white
                                                    : Colors.grey,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // summary row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF16A34A),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${AppStrings.present}: ${_presentCount.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE30B5C),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${AppStrings.absent}: ${_absentCount.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${AppStrings.leave}: ${_leaveCount.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '${_students.length.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // bottom buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
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
                  child: Builder(
                    builder: (context) {
                      final ap = context.watch<AttendanceProvider>();
                      final hasAttendance =
                          ap.attendance != null &&
                          (ap.attendance!.students?.isNotEmpty == true);
                      final label = hasAttendance
                          ? AppStrings.editSave
                          : AppStrings.saveAttendance;
                      return ElevatedButton(
                        onPressed: _onSavePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A1F44),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      );
                    },
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
