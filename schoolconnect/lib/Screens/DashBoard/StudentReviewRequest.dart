import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolconnect/constants/Mycolor.dart';
import 'package:schoolconnect/constants/imageAssets.dart';

class StudentReviewRequest extends StatelessWidget {
  const StudentReviewRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorF5F6FA,
      appBar: AppBar(
        surfaceTintColor: MyColor.colorF5F6FA,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: MyColor.color021034,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Review Request',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: MyColor.color021034,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile card
              _buildProfileCard(context),
              const SizedBox(height: 20),

              // Leave Details title
              const Text(
                'Leave Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: MyColor.color0F172A,
                ),
              ),
              const SizedBox(height: 12),

              // Details card
              Container(
                padding: const EdgeInsets.all(0),
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    _buildDetailTile(
                      icon: SvgPicture.asset(
                        AssetsImages.leavetype,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF6B7A9A),
                          BlendMode.srcIn,
                        ),
                      ),
                      title: 'Leave Type',
                      subtitle: 'Sick Leave',
                    ),
                    const Divider(height: 1, color: MyColor.colorF1F5F9),
                    _buildDetailTile(
                      icon: SvgPicture.asset(
                        AssetsImages.calender_,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF6B7A9A),
                          BlendMode.srcIn,
                        ),
                      ),
                      title: 'Duration',
                      subtitle: 'Oct 12, 2023 - Oct 14, 2023',
                      subtitle1: '3 Days duration',
                    ),
                    const Divider(height: 1, color: MyColor.colorF1F5F9),
                    _buildDetailTile(
                      icon: SvgPicture.asset(
                        AssetsImages.appliedon,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF6B7A9A),
                          BlendMode.srcIn,
                        ),
                      ),
                      title: 'Applied On',
                      subtitle: 'Oct 10, 2023',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: _cardDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reason For Leave',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: MyColor.color64748B,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Reason card (uses shared card decoration)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: MyColor.colorF5F9FF,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: MyColor.colorD7E3FC),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.04),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // LEFT VERTICAL LINE
                              Container(width: 6, color: MyColor.colorD7E3FC),

                              // CONTENT
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF4F8FB),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 1,
                                    ),
                                    child: const Text(
                                      '"I have been diagnosed with a severe throat infection and high fever. The doctor has advised complete bed rest for 3 days to recover. Attached is the medical certificate for your reference."',
                                      style: TextStyle(
                                        fontSize: 15,
                                        height: 1.6,
                                        color: Color(0xFF0F1720),
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
                  ],
                ),
              ),

              // Reason for leave
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: _cardDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attachments',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: MyColor.color64748B,
                      ),
                    ),
                    const SizedBox(height: 8),

                    DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(14),
                      dashPattern: const [6, 4],
                      color: MyColor.colorD7E3FC,
                      strokeWidth: 1,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F9FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: MyColor.colorD7E3FC,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SvgPicture.asset(
                                    AssetsImages.pdf,
                                    width: 20,
                                    height: 20,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFF6B7A9A),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Medical_Certificate.pdf',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '1.2 MB',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'VIEW',
                              style: TextStyle(
                                color: MyColor.color64748B,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Reason card (uses shared card decoration)
                  ],
                ),
              ),

              const SizedBox(height: 84),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: MyColor.colorD7E3FC),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.02),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: MyColor.colorD7E3FC),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEEF0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFFEA4B59),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'Reject',
                          style: TextStyle(
                            color: Color(0xFFEA4B59),
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: MyColor.colorD7E3FC),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F7EE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Color(0xFF03A46B),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'Approve',
                          style: TextStyle(
                            color: Color(0xFF03A46B),
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 34,
            backgroundColor: Color(0xFFF6EDE7),
            backgroundImage: AssetImage('assets/Images/avatar.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Johnathan Doe',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: MyColor.color021034,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Grade:',
                      style: TextStyle(
                        color: MyColor.color64748B,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' 10-A ',
                      style: TextStyle(
                        color: MyColor.color64748B,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '• ID: ',
                      style: TextStyle(
                        color: MyColor.color64748B,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' #4412',
                      style: TextStyle(
                        color: MyColor.color64748B,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildDetailTile({
    required Widget icon,
    required String title,
    required String subtitle,
    String? subtitle1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F8FB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: icon,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: MyColor.color64748B,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: MyColor.black,
                  ),
                ),

                // ese hide kese kare?
                subtitle1 != null
                    ? const SizedBox(height: 6)
                    : const SizedBox.shrink(),

                subtitle1 == null
                    ? SizedBox.shrink()
                    : Text(
                        subtitle1 ?? '',
                        style: const TextStyle(
                          color: MyColor.color64748B,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
