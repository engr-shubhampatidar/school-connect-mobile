import 'package:schoolconnect/export.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorEFF3FA,
      appBar: AppBar(
        backgroundColor: MyColor.colorEFF3FA,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ), // outer bg light blue
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Title
              const Text(
                "View Your personal and academic information",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: MyColor.color737373,
                ),
              ),

              const SizedBox(height: 16),

              /// Profile Header Card
              _profileHeader(),

              const SizedBox(height: 16),

              /// Personal Info
              _sectionCard(
                title: "Personal Information",
                children: [
                  Row(
                    children: [
                      Expanded(child: _infoBox("Full Name", "Rahul Sharma")),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoBox("Date of Birth", "18 march 2005"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _infoBox("Gender", "Male")),
                      const SizedBox(width: 12),
                      Expanded(child: _infoBox("Blood Group", "B+")),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _infoBox("Category", "OBC")),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoBox("Aadhar Number", "123-12546-1425"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _infoBox("Phone No.", "+91 9856316754")),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoBox(
                          "Email Address",
                          "rahulsharma@gmail.com",
                        ),
                      ),
                    ],
                  ),

                  _infoBoxFull(
                    "Address",
                    "123 Park Avenue 15, new delhi - 100101",
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Parent Info
              _sectionCard(
                title: "Parent / Guardian Information",
                children: [
                  Row(
                    children: [
                      Expanded(child: _infoBox("Father Name", "Rajesh Jain")),
                      const SizedBox(width: 12),
                      Expanded(child: _infoBox("Mother Name", "Priya sharma")),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _infoBox("Parent Contact", "+91 7986321565"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoBox(
                          "Parent Mail",
                          "rajeshsharma@gmail.com",
                        ),
                      ),
                    ],
                  ),

                  _infoBoxFull(
                    "Local Address",
                    "123 Park Avenue 15, new delhi - 100101",
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Documents
              _documentsCard(),

              const SizedBox(height: 16),

              /// Footer Note
              Row(
                children: const [
                  wSized10,
                  Icon(Icons.info_outline, size: 16, color: Colors.grey),
                  hSized6,
                  Expanded(
                    child: Text(
                      "If any information is incorrect, please contact the school office for assistance.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= PROFILE HEADER =================

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFE2E8F0),
            child: Icon(Icons.person, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Deepak Patidar",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: MyColor.color021034,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  children: [
                    const Text(
                      "Student ID : ",
                      style: TextStyle(
                        fontSize: 13,
                        color: MyColor.color737373,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Text(
                      "ST-200-305",
                      style: TextStyle(
                        fontSize: 13,
                        color: MyColor.color021034,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 30,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,

                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 6),
                    itemBuilder: (context, index) {
                      final items = [
                        _chip("Class 11-A"),
                        _chip(
                          "Science Stream",
                          bgColor: MyColor.colorDBEAFF,
                          textColor: MyColor.color2750C4,
                        ),
                        _chip(
                          "2025-26",
                          textColor: MyColor.color6930B3,
                          bgColor: MyColor.colorF4E8FF,
                        ),

                        _chip(
                          "Active",
                          textColor: MyColor.color16A34A,
                          bgColor: MyColor.colorDCFCE6,
                        ),
                        // _activeChip(),
                      ];
                      return items[index];
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SECTION CARD =================

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 16),
          Wrap(spacing: 12, runSpacing: 12, children: children),
        ],
      ),
    );
  }

  /// ================= INFO BOX =================

  Widget _infoBox(String label, String value) {
    return SizedBox(
      width: 160,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: _innerBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: MyColor.color021034,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBoxFull(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: _innerBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: MyColor.color021034,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= DOCUMENT CARD =================

  Widget _documentsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Uploaded Documents",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 16),

          _documentTile("Aadhar Card"),
          _documentTile("Previous Markshit"),
          _documentTile("Birth Certificate"),
          _documentTile("Transfer Certificate"),
        ],
      ),
    );
  }

  Widget _documentTile(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: _innerBoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // center alignment
        children: [
          const Icon(Icons.description_outlined, size: 30),
          const SizedBox(width: 12),

          /// Title + PDF badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text("PDF", style: TextStyle(fontSize: 10)),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// Eye + View
          Row(
            children: const [
              Icon(Icons.remove_red_eye_outlined, size: 18),
              SizedBox(width: 4),
              Text(
                "View",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= CHIPS =================

  Widget _chip(
    String text, {
    Color? bgColor,
    Color? borderColor,
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor ?? const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: borderColor ?? const Color(0xFFE2E8F0)),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: textColor ?? const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _activeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFD1FAE5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "Active",
        style: TextStyle(fontSize: 11, color: Colors.green),
      ),
    );
  }

  /// ================= DECORATION =================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: MyColor.colorD7E3FC),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.04),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  BoxDecoration _innerBoxDecoration() {
    return BoxDecoration(
      color: const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: MyColor.colorD7E3FC),
    );
  }
}
