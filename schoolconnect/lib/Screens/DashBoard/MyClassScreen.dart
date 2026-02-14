import 'package:schoolconnect/Screens/DashBoard/StudentProfileScreen.dart';
import 'package:schoolconnect/export.dart';

class MyClassScreen extends StatelessWidget {
  const MyClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              const Text(
                "My Class",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              /// Class Info Card
              _classInfoCard(),

              const SizedBox(height: 16),

              /// Attendance Warning Card
              _attendanceWarningCard(context),

              const SizedBox(height: 16),

              /// Attendance Today Card
              _attendanceTodayCard(context),

              const SizedBox(height: 16),

              /// Student List Header
              const Text(
                AppStrings.studentListTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                AppStrings.manageStudentProfile,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),

              /// Search & Filter
              _searchBar(),

              const SizedBox(height: 16),

              /// Student Cards
              _studentCard(context),
              _studentCard(context),
              _studentCard(context),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  AppStrings.viewMoreStudents,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- Widgets ----------------

  Widget _classInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Class: 10-A",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: MyColor.colorF5F9FF,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: MyColor.colorD7E3FC, width: 1),
                ),
                child: const Text(
                  "ACADEMIC YEAR 2025-26",
                  style: TextStyle(fontSize: 10, color: MyColor.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Second Floor, Room 204",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          const Text(
            "32",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            AppStrings.totalStudentsLabel,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _attendanceWarningCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.error, color: Colors.red, size: 18),
              SizedBox(width: 8),
              Text(
                "Morning attendance not yet submitted",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _primaryButton(
            AppStrings.takeAttendance,
            svgAsset: AssetsImages.plus,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _attendanceTodayCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Attendance Today",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Todays Update",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _StatusItem(
                count: "30",
                label: "Present",
                color: MyColor.color16A34A,
              ),
              _StatusItem(
                count: "02",
                label: "Absent",
                color: MyColor.colorE11D48,
              ),
              _StatusItem(
                count: "02",
                label: "Leave",
                color: MyColor.colorF59E0B,
              ),
            ],
          ),

          const SizedBox(height: 16),

          _primaryButtonskyblue(
            "Download Monthly Report",
            svgAsset: AssetsImages.download,
            svgHeight: 15,
            onPressed: () {},
            context: context,
          ),
          hSized10,
          _primaryButtonskyblue(
            "View Attendance History",
            svgAsset: AssetsImages.clock,
            onPressed: () {},
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: _cardDecoration(),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppStrings.searchByNameHint,
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none, // remove default border
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.all(12),
          decoration: _cardDecoration(), // same decoration applied
          child: Row(
            children: [
              Icon(LucideIcons.filter, color: Colors.grey, size: 15),
              wSized10,
              Text(AppStrings.filter),
            ],
          ),
        ),
      ],
    );
  }

  Widget _studentCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(
              "https://randomuser.me/api/portraits/men/1.jpg",
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rajbir Bhangi",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  "RajbirBhangi@gmail.com",
                  style: TextStyle(fontSize: 12, color: MyColor.color94A3B8),
                ),
                SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      "Male",

                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    wSized5,
                    CircleAvatar(
                      radius: 3,
                      backgroundColor: MyColor.color94A3B8,
                    ),
                    wSized5,

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: MyColor.colorF1F5F9, // #475569
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        AppStrings.active,
                        style: TextStyle(
                          fontSize: 12,
                          color: MyColor
                              .color475569, // white text better rahega dark bg par
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(
                color: MyColor.colorD7E3FC, // same as card border
                width: 1.2,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyProfileScreen(),
                ),
              );
            },
            child: const Text(
              AppStrings.view,
              style: TextStyle(
                color: Colors.black, // text color change if needed
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton(
    String text, {
    String? svgAsset,
    VoidCallback? onPressed,
    required BuildContext context,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColor.color021034,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed:
            onPressed ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TakeAttendanceScreen(),
                ),
              );
            },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (svgAsset != null) ...[
              SvgPicture.asset(
                svgAsset,
                width: 15,
                height: 12,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _primaryButtonskyblue(
    String text, {
    String? svgAsset,
    double? svgWidth,
    double? svgHeight,
    VoidCallback? onPressed,
    required BuildContext context,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColor.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
        ),
        onPressed:
            onPressed ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TakeAttendanceScreen(),
                ),
              );
            },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (svgAsset != null) ...[
              SvgPicture.asset(
                svgAsset,
                width: svgWidth ?? 15, // default width
                height: svgHeight ?? 12, // default height
                color: MyColor.color475569,
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: MyColor.color475569),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
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
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const _StatusItem({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ],
    );
  }
}
