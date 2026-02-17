import 'package:schoolconnect/export.dart';

class MonthlyAttendanceScreen extends StatefulWidget {
  const MonthlyAttendanceScreen({super.key});

  @override
  State<MonthlyAttendanceScreen> createState() =>
      _MonthlyAttendanceScreenState();
}

class AttendanceRecord {
  final String clockIn;
  final String clockOut;
  final String duration;
  final String status; // e.g., 'Present','Absent'
  AttendanceRecord(this.clockIn, this.clockOut, this.duration, this.status);
}

class _MonthlyAttendanceScreenState extends State<MonthlyAttendanceScreen> {
  DateTime _displayedMonth = DateTime.now();
  DateTime? _selectedDate;

  // sample data keyed by day number (for demo). In real app replace with API/provider.
  final Map<int, AttendanceRecord> _sample = {
    1: AttendanceRecord('08:35 AM', '05:20 PM', '8h 45m', 'Present'),
    2: AttendanceRecord('08:30 AM', '05:45 PM', '9h 15m', 'Present'),
    5: AttendanceRecord('08:30 AM', '05:45 PM', '9h 15m', 'Present'),
    6: AttendanceRecord('', '', '0h 0m', 'Absent'),
    8: AttendanceRecord('09:00 AM', '03:00 PM', '6h 0m', 'Leave'),
  };

  void _prevMonth() {
    setState(
      () => _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      ),
    );
  }

  void _nextMonth() {
    setState(
      () => _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      ),
    );
  }

  void _showMonthPicker(BuildContext context) {
    final monthNames = const [
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

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        return SizedBox(
          height: 360,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6EDF8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    // increase height per cell so long month names can wrap
                    childAspectRatio: 2.2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: List.generate(12, (i) {
                      final isSelected = _displayedMonth.month == i + 1;
                      return InkWell(
                        onTap: () {
                          setState(
                            () => _displayedMonth = DateTime(
                              _displayedMonth.year,
                              i + 1,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? MyColor.colorEEF4FF
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? MyColor.color2750C4
                                  : const Color(0xFFF1F5F9),
                            ),
                          ),
                          child: Text(
                            monthNames[i],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? MyColor.color2750C4
                                  : const Color(0xFF0F1724),
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dayCell(
    int day, {
    bool isOther = false,
    bool selected = false,
    Color? dotColor,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 64,
      height: 98,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? MyColor.color2750C4 : MyColor.colorF4F4F5,
                  width: selected ? 2.2 : 1.0,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: selected
                            ? FontWeight.w700
                            : (isOther ? FontWeight.w400 : FontWeight.w600),
                        color: isOther
                            ? const Color(0xFF9CA3AF)
                            : (selected
                                  ? MyColor.color2750C4
                                  : const Color(0xFF111827)),
                      ),
                    ),
                  ),
                  if (!isOther)
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: dotColor ?? Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AttendanceRecord _recordFor(DateTime date) {
    final r = _sample[date.day];
    if (r != null) return r;
    // default: present with sample times
    return AttendanceRecord('08:30 AM', '05:30 PM', '9h 0m', 'Present');
  }

  @override
  Widget build(BuildContext context) {
    final monthNames = const [
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

    final year = _displayedMonth.year;
    final month = _displayedMonth.month;
    final first = DateTime(year, month, 1);
    final startWeekday = first.weekday % 7; // 0=Sun
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final prevMonthLast = DateTime(year, month, 0).day;

    final List<Widget> cells = [];
    // leading prev-month days
    for (int i = 0; i < startWeekday; i++) {
      final day = prevMonthLast - (startWeekday - 1) + i;
      cells.add(_dayCell(day, isOther: true));
    }
    // current month
    for (int d = 1; d <= daysInMonth; d++) {
      Color? dot;
      if (_sample.containsKey(d)) {
        final s = _sample[d]!.status;
        if (s == 'Present') dot = MyColor.color16A34A;
        if (s == 'Absent') dot = MyColor.red_new;
        if (s == 'Leave') dot = MyColor.ColorFFC907;
      }
      final sel =
          _selectedDate != null &&
          _selectedDate!.year == year &&
          _selectedDate!.month == month &&
          _selectedDate!.day == d;
      cells.add(
        _dayCell(
          d,
          selected: sel,
          dotColor: dot,
          onTap: () => setState(() => _selectedDate = DateTime(year, month, d)),
        ),
      );
    }
    // trailing next-month days
    final total = cells.length;
    final trailing = (7 - (total % 7)) % 7;
    for (int t = 1; t <= trailing; t++) {
      cells.add(_dayCell(t, isOther: true));
    }

    return Scaffold(
      backgroundColor: MyColor.colorEFF3FA,
      appBar: AppBar(
        backgroundColor: MyColor.colorEFF3FA,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _showMonthPicker(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: MyColor.transparent,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: MyColor.color021034,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${monthNames[month - 1]} $year',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
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

            // calendar card (weekday header, grid, legend)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // weekday header with subtle bottom divider
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Center(
                            child: Text(
                              'SUN',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'MON',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'TUE',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'WED',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'THU',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'FRI',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'SAT',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  GridView.count(
                    crossAxisCount: 7,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 64 / 98,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    children: cells,
                  ),

                  // legend area
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 24,
                      runSpacing: 8,
                      children: [
                        _legendItem(MyColor.color16A34A, 'PRESENT'),
                        _legendItem(MyColor.red_new, 'ABSENT'),
                        _legendItem(MyColor.ColorFFC907, 'LEAVE'),
                        _legendItem(const Color(0xFF9CA3AF), 'HOLIDAY'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // bottom details card
            if (_selectedDate != null)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MyColor.colorD7E3FC),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 6,
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6EDF8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Builder(
                        builder: (ctx) {
                          final rec = _recordFor(_selectedDate!);
                          final monthNames = const [
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
                          final dateLabel =
                              '${monthNames[_selectedDate!.month - 1]} ${_selectedDate!.day}, ${_selectedDate!.year}';
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Attendance Details',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: rec.status == 'Present'
                                          ? MyColor.color16A34A.withOpacity(
                                              0.12,
                                            )
                                          : const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Text(
                                      rec.status,
                                      style: TextStyle(
                                        color: rec.status == 'Present'
                                            ? MyColor.color16A34A
                                            : const Color(0xFF374151),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              _detailRow('Date', dateLabel),
                              const Divider(
                                color: Color(0xFFF1F5F9),
                                height: 28,
                                thickness: 1,
                              ),
                              _detailRow(
                                'Clock In',
                                rec.clockIn.isEmpty ? '--' : rec.clockIn,
                              ),
                              const Divider(
                                color: Color(0xFFF1F5F9),
                                height: 28,
                                thickness: 1,
                              ),
                              _detailRow(
                                'Clock Out',
                                rec.clockOut.isEmpty ? '--' : rec.clockOut,
                              ),
                              const Divider(
                                color: Color(0xFFF1F5F9),
                                height: 28,
                                thickness: 1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Duration',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF374151),
                                    ),
                                  ),
                                  Text(
                                    rec.duration,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: MyColor.color2750C4,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Color(0xFFF1F5F9),
                                height: 28,
                                thickness: 1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Status',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF374151),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: const Text(
                                      'Verified',
                                      style: TextStyle(
                                        color: Color(0xFF0F1724),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF6B7280))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11),
        ),
      ],
    );
  }

  // AttendanceRecord _recordFor(DateTime dt) =>
  //     _sample[dt.day] ??
  //     AttendanceRecord('08:30 AM', '05:30 PM', '9h 0m', 'Present');
}
