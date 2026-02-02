import 'dart:convert';

import 'package:schoolconnect/export.dart';
import 'package:schoolconnect/model.dart/attendanceclass.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('AttendanceHistoryScreen: init - triggering fetchAttendance');
      context.read<AttendanceProvider>().fetchAttendance();
    });
  }

  Widget _statusPill(String status) {
    final bool complete = status.toLowerCase() == 'complete';
    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: complete ? const Color(0xFFE8FBEE) : const Color(0xFFFFF6EA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: complete ? const Color(0xFF16A34A) : const Color(0xFFF59E0B),
        ),
      ),
      child: Center(
        child: Text(
          status,
          style: TextStyle(
            color: complete ? const Color(0xFF16A34A) : const Color(0xFFF59E0B),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _countPill(int p, int a, int l) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAF1FF)),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: MyColor.color16A34A,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(p.toString().padLeft(2, '0')),
            ],
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: MyColor.colorE11D48,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(a.toString().padLeft(2, '0')),
            ],
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: MyColor.colorF59E0B,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(l.toString().padLeft(2, '0')),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provAll = context.watch<AttendanceProvider>();
    final daysCount = provAll.attendances
        .map((a) => a.date ?? '')
        .toSet()
        .where((d) => d.isNotEmpty)
        .length;
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
          'Attendance History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
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
            Container(
              // height: 89,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
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
                child: Column(
                  children: [
                    Container(
                      height: 85,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Records',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Select Date',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    LucideIcons.calendar,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            'last $daysCount Day${daysCount == 1 ? '' : 's'} attendance Summary',
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

                    Expanded(
                      child: Consumer<AttendanceProvider>(
                        builder: (context, prov, _) {
                          if (prov.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (prov.error != null) {
                            return Center(child: Text(prov.error!));
                          }
                          final list = prov.attendances;
                          if (list.isEmpty) {
                            return const Center(
                              child: Text('No attendance records'),
                            );
                          }

                          // Group attendances by date string
                          final Map<String, List<AttendanceClass>> byDate = {};
                          for (final a in list) {
                            final d = a.date ?? '';
                            byDate.putIfAbsent(d, () => []).add(a);
                          }

                          final dates = byDate.keys.toList()
                            ..sort((a, b) => b.compareTo(a));

                          return ListView.separated(
                            itemCount: dates.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 12,
                              color: Color(0xFFEAF1FF),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            itemBuilder: (context, idx) {
                              final dateKey = dates[idx];
                              final dayGroup = byDate[dateKey]!;
                              final students = dayGroup
                                  .expand((e) => e.students ?? [])
                                  .toList();

                              final present = students
                                  .where(
                                    (s) => s.status?.toLowerCase() == 'present',
                                  )
                                  .length;
                              final absent = students
                                  .where(
                                    (s) => s.status?.toLowerCase() == 'absent',
                                  )
                                  .length;
                              final leave = students
                                  .where(
                                    (s) => s.status?.toLowerCase() == 'leave',
                                  )
                                  .length;

                              String dayString = '';
                              try {
                                if (dateKey.isNotEmpty) {
                                  final dt = DateTime.parse(dateKey);
                                  const wk = [
                                    'Monday',
                                    'Tuesday',
                                    'Wednesday',
                                    'Thursday',
                                    'Friday',
                                    'Saturday',
                                    'Sunday',
                                  ];
                                  dayString = wk[dt.weekday - 1];
                                }
                              } catch (_) {
                                dayString = '';
                              }

                              final status =
                                  dayGroup.first.status ?? 'Incomplete';

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                dateKey,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              _statusPill(status),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            dayString,
                                            style: TextStyle(
                                              color: MyColor.color64748B,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              _countPill(
                                                present,
                                                absent,
                                                leave,
                                              ),
                                              const Icon(
                                                Icons.chevron_right,
                                                color: MyColor.color737373,
                                                size: 25,
                                              ),
                                            ],
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
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'End of recent history. Detailed records available in reports',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
