import 'dart:ui';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolconnect/constants/Mycolor.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'AttendanceHistoryScreen.dart';
import 'package:schoolconnect/export.dart';
import 'package:schoolconnect/constants/strings.dart';

enum AttendanceStatus { none, present, absent, leave }

class TakeAttendanceScreen extends StatefulWidget {
  const TakeAttendanceScreen({super.key});

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  static const int studentCount = 8;
  final List<AttendanceStatus> _statuses = List.filled(
    studentCount,
    AttendanceStatus.none,
  );
  List<AttendanceStatus>? _savedStatuses;
  bool _isSaved = false;

  void _setStatus(int index, AttendanceStatus status) {
    setState(() {
      _statuses[index] = _statuses[index] == status
          ? AttendanceStatus.none
          : status;
    });
  }

  void _onSavePressed() {
    _savedStatuses = List.from(_statuses);
    _isSaved = true;
    _showSavedDialog();
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
                        horizontal: 24,
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
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            AppStrings.attendanceSavedMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                    Positioned(
                      right: MediaQuery.of(context).size.width * 0.07,
                      top: MediaQuery.of(context).size.height * 0.29,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, size: 18),
                        ),
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
                    children: const [
                      Text(
                        AppStrings.classTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        AppStrings.classDate,
                        style: TextStyle(color: Colors.grey, fontSize: 13),
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
                    child: const Text(
                      AppStrings.subjectScience,
                      style: TextStyle(
                        color: MyColor.myblack,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Student list card
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEAF1FF)),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // header
                    Column(
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
                                Icon(LucideIcons.filter, color: Colors.grey),
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

                    const SizedBox(height: 12),

                    // students list
                    Expanded(
                      child: ListView.separated(
                        itemCount: _statuses.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 12, color: Color(0xFFEAF1FF)),
                        itemBuilder: (context, index) {
                          final status = _statuses[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Color(0xFFEAF1FF),
                                  child: Image.asset(
                                    AssetsImages.loginperson,
                                    width: 49,
                                    height: 47,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Rajbir Bhangi',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: MyColor.myblack
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${AppStrings.rollNo} 0${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // action pill
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
                                      // present
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
                                                ? const Color(0xFF16A34A)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color:
                                                  status ==
                                                      AttendanceStatus.present
                                                  ? const Color(0xFF16A34A)
                                                  : MyColor.transparent
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
                                      // absent
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
                                                ? const Color(0xFFE30B5C)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color:
                                                  status ==
                                                      AttendanceStatus.absent
                                                  ? const Color(0xFFE30B5C)
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
                                      // leave
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
                                                status == AttendanceStatus.leave
                                                ? const Color(0xFFF59E0B)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color:
                                                  status ==
                                                      AttendanceStatus.leave
                                                  ? const Color(0xFFF59E0B)
                                                  : MyColor.transparent,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.access_time,
                                            color:
                                                status == AttendanceStatus.leave
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
                    '${studentCount.toString().padLeft(2, '0')}',
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
                  child: ElevatedButton(
                    onPressed: _onSavePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A1F44),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      AppStrings.editSave,
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
