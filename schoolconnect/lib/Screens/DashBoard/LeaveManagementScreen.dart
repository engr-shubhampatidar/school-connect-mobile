import 'package:schoolconnect/Screens/DashBoard/RequestLeaveScreen.dart';
import 'package:schoolconnect/export.dart';

class LeaveManagementScreen extends StatelessWidget {
  LeaveManagementScreen({super.key});

  final List<Map<String, dynamic>> leaveRequests = [
    {
      "type": "Sick Leave",
      "date": "Oct 12 - Oct 14",
      "days": "3 Days Requested",
      "status": "Approved",
      "statusColor": const Color(0xFF1E7A3E),
      "remarks": "Hope you feel better soon. Substituted by Mr. Wilson.",
    },
    {
      "type": "Casual Leave",
      "date": "Nov 02 - Nov 03",
      "days": "2 Days Requested",
      "status": "Pending",
      "statusColor": const Color(0xFFF59E0B),
      "remarks": "Awaiting principal approval.",
    },
    {
      "type": "Medical Leave",
      "date": "Nov 10",
      "days": "1 Day Requested",
      "status": "Rejected",
      "statusColor": const Color(0xFFDC2626),
      "remarks": "Insufficient documents provided.",
    },
  ];

  final List<Map<String, String>> studentRequests = [
    {
      "name": "Marcus Thompson",
      "gradeRoll": "Grade 10-B • Roll #42",
      "type": "Medical",
      "date": "Oct 24 - Oct 25",
      "days": "2 Days",
      "imagePath": "https://randomuser.me/api/portraits/men/32.jpg",
    },
    {
      "name": "Emma Watson",
      "gradeRoll": "Grade 9-A • Roll #18",
      "type": "Personal",
      "date": "Oct 20 - Oct 21",
      "days": "2 Days",
      "imagePath": "https://randomuser.me/api/portraits/women/44.jpg",
    },
    {
      "name": "John Carter",
      "gradeRoll": "Grade 11-C • Roll #12",
      "type": "Family Function",
      "date": "Nov 02 - Nov 03",
      "days": "2 Days",
      "imagePath": "https://randomuser.me/api/portraits/men/65.jpg",
    },
    {
      "name": "Sophia Brown",
      "gradeRoll": "Grade 8-A • Roll #07",
      "type": "Medical",
      "date": "Nov 10",
      "days": "1 Day",
      "imagePath": "https://randomuser.me/api/portraits/women/22.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: MyColor.color021034,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.event_note,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Leave Management",
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),

        actions: [
          /// Notification Icon
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Color(0xFF64748B),
            ),
          ),

          /// Profile Image
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFE2E8F0),
              backgroundImage: NetworkImage(
                "https://randomuser.me/api/portraits/men/32.jpg",
              ),
              // 👆 apna image asset yaha lagana
            ),
          ),
        ],

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEAVE BALANCE SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "LEAVE BALANCE",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),

                /// Academic Year Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: _cardDecoration(),
                  child: const Text(
                    "Academic Year 2024",
                    style: TextStyle(
                      fontSize: 11,
                      color: MyColor.color021034,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            leaveCard(title: "Sick Leave", used: 14, total: 20),

            const SizedBox(height: 12),

            // _leaveBalanceCard(
            //   title: "Casual Leave",
            //   used: "4 / 10 days",
            //   remaining: "6 Remaining",
            //   progress: 0.4,
            // ),
            // _leaveBalanceCard(title: "Casual Leave", used: 14, total: 20),
            leaveCard(title: "Casual Leave", used: 4, total: 10),
            const SizedBox(height: 20),

            /// APPLY BUTTON
            PrimaryButton(
              text: "Apply for New Leave",
              svgAsset: AssetsImages.plus,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RequestLeaveScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            /// MY REQUESTS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "MY LEAVE REQUESTS",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: MyColor.color021034,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            ListView.builder(
              itemCount: leaveRequests.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final leave = leaveRequests[index];

                return _requestCard(
                  type: leave["type"],
                  date: leave["date"],
                  days: leave["days"],
                  status: leave["status"],
                  statusColor: leave["statusColor"],
                  remarks: leave["remarks"],
                );
              },
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "STUDENT REQUESTS",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE2E2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "2 NEW",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: MyColor.Colore30b5c,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),

            // _studentRequestCard(
            //   name: "Marcus Thompson",
            //   gradeRoll: "Grade 10-B • Roll #42",
            //   type: "Medical",
            //   date: "Oct 24 - Oct 25",
            //   days: "2 Days",
            //   imagePath: "assets/student1.png",
            // ),
            ListView.builder(
              itemCount: studentRequests.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final student = studentRequests[index];

                return _studentRequestCard(
                  name: student["name"]!,
                  gradeRoll: student["gradeRoll"]!,
                  type: student["type"]!,
                  date: student["date"]!,
                  days: student["days"]!,
                  imagePath: student["imagePath"]!,
                );
              },
            ),

            // _requestCard(
            //   type: "Casual Leave",
            //   date: "Nov 05 - Nov 05",
            //   days: "1 Day Requested",
            //   status: "Pending",
            //   statusColor: const Color(0xFFF59E0B),
            // ),
          ],
        ),
      ),
    );
  }

  /// COMMON CARD STYLE
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: MyColor.colorD7E3FC, width: 1.5),
    );
  }

  /// LEAVE BALANCE CARD
  Widget leaveCard({
    required String title,
    required int used,
    required int total,
  }) {
    final double progress = used / total;
    final int remaining = total - used;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF475569),
            ),
          ),

          const SizedBox(height: 14),

          /// Count Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 14 / 20 days
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$used",
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    TextSpan(
                      text: " / $total days",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              /// Remaining Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7EEF9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  "$remaining Remaining",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: MyColor.color021034,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: const Color(0xFFE2E8F0),
              color: MyColor.color021034,
            ),
          ),
        ],
      ),
    );
  }

  /// REQUEST CARD
  Widget _requestCard({
    required String type,
    required String date,
    required String days,
    required String status,
    required Color statusColor,
    required String remarks,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Leave Type Tag (Blue Box)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE7F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  type,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: MyColor.color021034,
                  ),
                ),
              ),

              /// Status Pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Date (Big & Bold)
          Text(
            date,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),

          const SizedBox(height: 8),

          /// Days
          Text(
            days,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 1),

          /// Admin Remarks Box
          // Container(
          //   padding: const EdgeInsets.all(18),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFF1F5F9),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Text(
          //         "Admin Remarks:",
          //         style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.w600,
          //           color: Color(0xFF64748B),
          //         ),
          //       ),
          //       const SizedBox(height: 10),
          //       Text(
          //         remarks,
          //         style: const TextStyle(
          //           fontSize: 16,
          //           color: Color(0xFF475569),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// LEFT VERTICAL LINE
                    Container(
                      width: 5,
                      color: const Color(
                        0xFFCBD5E1,
                      ), // <-- This will now show properly
                    ),

                    /// CONTENT
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Admin Remarks:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "\"Hope you feel better soon. Substituted by Mr. Wilson.\"",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _studentRequestCard({
    required String name,
    required String gradeRoll,
    required String type,
    required String date,
    required String days,
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Avatar
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(imagePath),
              ),

              const SizedBox(width: 16),

              /// Name + Grade
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: MyColor.color021034,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      gradeRoll,
                      style: const TextStyle(
                        fontSize: 12,
                        color: MyColor.color94A3B8,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              /// Leave Type Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  type,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Date + Days
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 15,
                    color: Color(0xFF64748B),
                  ),
                  SizedBox(width: 8),
                ],
              ),
              Expanded(
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
              Text(
                days,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Buttons
          Row(
            children: [
              /// View Button
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        size: 20,
                        color: Color(0xFF0F172A),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "View",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              /// Approve Button
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE7F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 22,
                        color: MyColor.color021034,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Approve",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: MyColor.color021034,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
