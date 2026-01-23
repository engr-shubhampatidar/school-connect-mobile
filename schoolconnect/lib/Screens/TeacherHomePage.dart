import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolconnect/constants/Mycolor.dart';
import 'package:schoolconnect/constants/imageAssets.dart';
import 'package:schoolconnect/constants/sizesbox.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 HEADER (static, not inside scroll view)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey,
                    child: Image.asset(AssetsImages.loginperson),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Welcome back, Sarah",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Monday, Oct 23 · ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: "Class Teacher - 10A",
                                style: TextStyle(
                                  color: MyColor.color16A34A,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(AssetsImages.bell, width: 24, height: 24),
                ],
              ),
            ),

            // Scrollable content below the static header
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    /// 🔹 STATS CARDS (horizontal scroll)
                    SizedBox(
                      height: 111,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _infoCard(
                            title: "05",
                            subtitle: "Today’s Classes",
                            footer: "3 Complete  2 Remaining",
                            svgAsset: AssetsImages.person,
                          ),
                          const SizedBox(width: 12),
                          _infoCard(
                            title: "Pending",
                            subtitle: "Attendance Status",
                            footer: "For Class 10A",
                            svgAsset: AssetsImages.calendar,
                          ),
                          const SizedBox(width: 12),
                          _infoCard(
                            title: "Pending marks",
                            subtitle: "02",
                            footer: "2 subject marks are pending",
                            svgAsset: AssetsImages.editpage,
                          ),
                          const SizedBox(width: 12),
                          _infoCard(
                            title: "Next Class",
                            subtitle: "Physics",
                            footer: "Start in 15 min, Room(105) in 11thB",
                            svgAsset: AssetsImages.remainclock,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    _myClassCard(), hSized20,

                    /// 🔹 MY CLASS
                    /// 🔹 ASSIGNED SUBJECTS (NEW UI)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: MyColor.colorD7E3FC,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Header (padded)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Assigned Subjects",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Manage your teaching assignment and mark entry",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: MyColor.colorD7E3FC,
                            thickness: 1,
                            height: 1,
                          ),
                          hSized5,
                          // Subject rows with full-width dividers between them
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _assignedSubjectItem(),
                          ),
                          const Divider(
                            color: MyColor.colorD7E3FC,
                            thickness: 1,
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _assignedSubjectItem(),
                          ),
                          const Divider(
                            color: MyColor.colorD7E3FC,
                            thickness: 1,
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _assignedSubjectItem(),
                          ),
                          const Divider(
                            color: MyColor.colorD7E3FC,
                            thickness: 1,
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _assignedSubjectItem(),
                          ),
                          // const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    hSized20,

                    /// 🔹 ASSIGNED SUBJECTS
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _cardDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Assigned Subjects",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Manage your teaching assignment and mark entry",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(height: 12),

                          _subjectTile(),
                          _subjectTile(),
                          _subjectTile(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 TODAY’S CLASSES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today’s Classes",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFEFF4FF),
                          ),
                          child: const Text("Tuesday"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _classTile(),
                    _classTile(),
                    _classTile(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.blue.shade200, thickness: 1, height: 1);
  }

  Widget _myClassCard() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with horizontal padding
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "My Class: 10-A",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Class Teacher Responsibilities",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "32",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Total Students",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          hSized20,
          // Full-width divider (no horizontal padding)
          const Divider(color: MyColor.colorD7E3FC, thickness: 1, height: 1),

          // Rest of content with horizontal padding
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              children: [
                /// Warning (centered)
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.error_outline, size: 18, color: Colors.red),
                      SizedBox(width: 6),
                      Text(
                        "Morning attendance not yet submitted",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                _primaryButton("Take Attendance", svgAsset: AssetsImages.plus),
                const SizedBox(height: 10),
                _primaryButton(
                  "Attendance History",
                  svgAsset: AssetsImages.clock,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _assignedSubjectItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: MyColor.colorF5F9FF,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: MyColor.colorD7E3FC)
                      ),
                      child: const Text(
                        "10-A",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: MyColor.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Mathematics",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Row(
                  children: [
                    SvgPicture.asset(AssetsImages.doubleperson, height: 20),
                    SizedBox(width: 4),
                    Text(
                      "28 Students",
                      style: TextStyle(
                        color: MyColor.color737373,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: MyColor.colorD7E3FC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: Text(
              "View Students",
              style: TextStyle(color: MyColor.black),
            ),
          )
        ],
      ),
    );
  }

  /// 🔹 REUSABLE WIDGETS

  Widget _infoCard({
    required String title,
    required String subtitle,
    required String footer,
    String? svgAsset,
  }) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (svgAsset != null)
                SvgPicture.asset(svgAsset, width: 20, height: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: MyColor.color737373,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              footer,
              style: TextStyle(
                color: title == "Pending marks"
                    ? MyColor.color16A34A
                    : MyColor.color737373,
                overflow: TextOverflow.ellipsis,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subjectTile() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Chip(label: Text("10-A")),
              SizedBox(width: 8),
              Text(
                "Mathematics",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Icon(Icons.people, size: 18),
              SizedBox(width: 4),
              Text("28 Students"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _outlineButton("View Students")),
              const SizedBox(width: 10),
              Expanded(child: _outlineButton("Enter Marks")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _classTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mathematics",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                SizedBox(height: 4),
                Text("8:00 - 8:30", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFEFF4FF),
            ),
            child: const Text("Room 204"),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton(String text, {String? svgAsset}) {
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
        onPressed: () {},
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

  Widget _outlineButton(String text) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {},
        child: Text(text),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: MyColor.colorD7E3FC, width: 1.5),
    );
  }
}
