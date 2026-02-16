import 'package:schoolconnect/export.dart';

class MonthlyAttendanceScreen extends StatefulWidget {
  const MonthlyAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<MonthlyAttendanceScreen> createState() =>
      _MonthlyAttendanceScreenState();
}

class _MonthlyAttendanceScreenState extends State<MonthlyAttendanceScreen> {
  DateTime _displayedMonth = DateTime.now();

  void _prevMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  Widget _dayBox(String day, {Color? dotColor, bool selected = false}) {
    return Container(
      width: 44,
      height: 48,
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected ? MyColor.color021034 : MyColor.colorD7E3FC,
          width: selected ? 2 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: MyColor.color021034.withOpacity(0.06),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          if (dotColor != null)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value, {
    Color valueColor = Colors.black87,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        Text(
          value,
          style: TextStyle(color: valueColor, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final year = _displayedMonth.year;
    final month = _displayedMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // 1=Mon, 7=Sun
    final leadingEmpty =
        firstWeekday %
        7; // convert to 0=Sun,1=Mon,... for Sunday-first calendar

    final List<Widget> dayWidgets = [];
    for (int i = 0; i < leadingEmpty; i++) {
      dayWidgets.add(
        Container(width: 44, height: 48, margin: const EdgeInsets.all(6)),
      );
    }
    for (int d = 1; d <= daysInMonth; d++) {
      Color? dot;
      if (d == 5) dot = MyColor.color16A34A;
      if (d == 6) dot = MyColor.red_new;
      if (d == 8) dot = MyColor.ColorFFC907;
      final selected =
          (d == today.day && month == today.month && year == today.year);
      dayWidgets.add(_dayBox(d.toString(), dotColor: dot, selected: selected));
    }

    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Attendance',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month header + calendar box
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MyColor.colorD7E3FC),
              ),
              child: Column(
                children: [
                  // month selector row with blue outline
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: MyColor.color021034),
                              borderRadius: BorderRadius.circular(8),
                              color: MyColor.colorEEF4FF,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                  color: MyColor.color021034,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${monthNames[month - 1]} $year',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: MyColor.color021034,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_left,
                            color: MyColor.color021034,
                          ),
                          onPressed: _prevMonth,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_right,
                            color: MyColor.color021034,
                          ),
                          onPressed: _nextMonth,
                        ),
                      ],
                    ),
                  ),

                  // calendar grid area
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Column(
                      children: [
                        // weekday labels
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            SizedBox(
                              width: 44,
                              child: Center(
                                child: Text(
                                  'SUN',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 44,
                              child: Center(
                                child: Text(
                                  'MON',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 44,
                              child: Center(
                                child: Text(
                                  'TUE',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 44,
                              child: Center(
                                child: Text(
                                  'WED',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 44,
                              child: Center(
                                child: Text(
                                  'THU',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 44,
                              child: Center(
                                child: Text(
                                  'FRI',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 44,
                              child: Center(
                                child: Text(
                                  'SAT',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(children: dayWidgets),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                const SizedBox(width: 8),
                                const Text('PRESENT'),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: MyColor.red_new,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('ABSENT'),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: MyColor.ColorFFC907,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('LEAVE'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bottom sheet style details card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MyColor.colorD7E3FC),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 6,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: MyColor.colorF4F4F5,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Attendance Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${monthNames[month - 1]} ${today.day}, $year',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _detailRow('Clock In', '08:30 AM'),
                        const SizedBox(height: 10),
                        _detailRow('Clock Out', '05:45 PM'),
                        const SizedBox(height: 10),
                        _detailRow(
                          'Total Duration',
                          '9h 15m',
                          valueColor: MyColor.color2750C4,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  AssetsImages.clock,
                                  width: 16,
                                  height: 16,
                                  color: Colors.white,
                                ),
                                label: const Text('View Monthly Attendance'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColor.color021034,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Back to Home'),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
