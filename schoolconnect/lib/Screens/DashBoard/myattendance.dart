import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schoolconnect/Screens/DashBoard/MonthlyAttendanceScreen.dart';
import 'package:schoolconnect/Screens/dashboard.dart';
import 'package:schoolconnect/export.dart';

class MyAttendance extends StatefulWidget {
  const MyAttendance({Key? key}) : super(key: key);

  @override
  State<MyAttendance> createState() => _MyAttendanceState();
}

class _MyAttendanceState extends State<MyAttendance> {
  final Completer<GoogleMapController> _mapController = Completer();
  static const LatLng _schoolCenter = LatLng(
    19.0760,
    72.8777,
  ); // example: Mumbai
  final Set<Circle> _circles = {
    Circle(
      circleId: const CircleId('school_zone'),
      center: _schoolCenter,
      radius: 120, // meters
      strokeWidth: 3,
      strokeColor: MyColor.color2750C4.withOpacity(0.35),
      fillColor: MyColor.colorDBEAFF.withOpacity(0.18),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Status bar area colored like header
          Container(height: topPadding, color: const Color(0xFF021034)),
          Expanded(
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (copied style from TeacherHomePage)
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF021034),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            child: Image.asset(AssetsImages.loginperson),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 0),
                                Text(
                                  AppStrings.welcomeBack,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Monday, Oct 23 · ",
                                        style: TextStyle(
                                          color: Colors.white70,
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
                          SvgPicture.asset(
                            AssetsImages.bell,
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Scrollable content below header
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          // Attendance card (header + divider + body)
                          Container(
                            decoration: _cardDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Card header
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    16,
                                    16,
                                    12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Today Attendance Status',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                          color: MyColor.color021034,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'You can clock in only within school radius',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: MyColor.colorD7E3FC,
                                  height: 1,
                                ),

                                // Card body
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'School Campus',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                          Row(
                                            children: const [
                                              Icon(
                                                Icons.location_on_outlined,
                                                color: Colors.grey,
                                                size: 16,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                'Within Zone (0m)',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),

                                      // Map placeholder
                                      Container(
                                        height: 160,
                                        decoration: _innerBoxDecoration(),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Positioned.fill(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: GoogleMap(
                                                  initialCameraPosition:
                                                      const CameraPosition(
                                                        target: LatLng(
                                                          19.0760,
                                                          72.8777,
                                                        ),
                                                        zoom: 15,
                                                      ),
                                                  onMapCreated: (controller) async {
                                                    if (!_mapController
                                                        .isCompleted) {
                                                      _mapController.complete(
                                                        controller,
                                                      );
                                                    }
                                                    try {
                                                      await controller
                                                          .setMapStyle(
                                                            MyColor
                                                                .googleMapStyle,
                                                          );
                                                    } catch (_) {
                                                      // ignore: avoid_print
                                                    }
                                                  },
                                                  myLocationEnabled: false,
                                                  zoomControlsEnabled: false,
                                                  mapType: MapType.normal,
                                                  circles: _circles,
                                                ),
                                              ),
                                            ),

                                            // Blue zone ring + inner dot + centered label (matches screenshot)
                                            Center(
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    width: 140,
                                                    height: 140,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: MyColor.colorDBEAFF
                                                          .withOpacity(0.3),
                                                      border: Border.all(
                                                        color: MyColor
                                                            .color2750C4
                                                            .withOpacity(0.35),
                                                        width: 3,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          MyColor.colorF4F4F5,
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'SCH',
                                                            style: TextStyle(
                                                              color: MyColor
                                                                  .color021034,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              letterSpacing:
                                                                  1.2,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          Container(
                                                            width: 10,
                                                            height: 10,
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: MyColor
                                                                      .color021034,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            'ZONE',
                                                            style: TextStyle(
                                                              color: MyColor
                                                                  .color021034,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              letterSpacing:
                                                                  1.2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 14),

                                      // Status row with pill
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Status',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Text(
                                              'Not Checked In',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 18),

                                      // Times rows
                                      _labelValueRow('Clock In Time', '--:--'),
                                      const SizedBox(height: 12),
                                      _labelValueRow('Clock Out Time', '--:--'),
                                      const SizedBox(height: 12),
                                      _labelValueRow('Total Hours', '--:--'),

                                      const SizedBox(height: 14),

                                      Row(
                                        children: const [
                                          Icon(
                                            Icons.error_outline,
                                            color: MyColor.red,
                                            size: 18,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Pls make sure you are in School Zone',
                                              style: TextStyle(
                                                color: MyColor.red,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 14),

                                      PrimaryButton(
                                        text: 'Clock In Now',
                                        svgAsset: AssetsImages.clock,
                                        onPressed: () =>
                                            _showClockOutConfirmDialog(context),
                                        backgroundColor: MyColor.color021034,
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: MyColor.color021034
                                                  .withOpacity(0.12),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const MonthlyAttendanceScreen(),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  AssetsImages.clock,
                                                  width: 16,
                                                  height: 16,
                                                  color: MyColor.color021034,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Attendance History',
                                                  style: TextStyle(
                                                    color: MyColor.color021034,
                                                    fontFamily: 'Roboto',
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
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Monthly Summary card
                          Container(
                            decoration: _cardDecoration(),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Monthly Summary',
                                      style: AppTextStyles.heading.copyWith(
                                        fontSize: 34,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'View ',
                                            style: AppTextStyles.subtitle
                                                .copyWith(fontSize: 16),
                                          ),
                                          TextSpan(
                                            text: 'oct ',
                                            style: AppTextStyles.subtitle
                                                .copyWith(
                                                  fontSize: 16,
                                                  color: MyColor.color16A34A,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          TextSpan(
                                            text: '2025',
                                            style: AppTextStyles.subtitle
                                                .copyWith(
                                                  fontSize: 16,
                                                  color: MyColor.color16A34A,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                          TextSpan(
                                            text: ' attendance Summary',
                                            style: AppTextStyles.subtitle
                                                .copyWith(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _summaryBox(
                                      'PRESENT',
                                      '20',
                                      MyColor.colorDCFCE6,
                                      MyColor.color16A34A,
                                    ),
                                    _summaryBox(
                                      'ABSENT',
                                      '02',
                                      MyColor.redF5F4F4,
                                      MyColor.red_new,
                                    ),
                                    _summaryBox(
                                      'LEAVES',
                                      '01',
                                      MyColor.colorF4E8FF,
                                      MyColor.Colore30b5c,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  void _showClockOutConfirmDialog(BuildContext context) {
    // Sample times - replace with real values from state/provider as needed
    const String clockInTime = '08:30 AM';
    const String clockOutTime = '05:45 PM';
    const String totalDuration = '9h 15m';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Container(
                decoration: _cardDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title row with close (centered title to match summary dialog)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 12, 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Clock Out?',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ),

                    // Subtitle / description (centered)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'You have been active for 3h 14m. Are you sure you want to clock out now?',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Info card with dividers (consistent styling)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: _innerBoxDecoration(),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            _infoRow('Clock In', clockInTime),
                            const Divider(
                              color: MyColor.colorD7E3FC,
                              height: 1,
                            ),
                            _infoRow('Clock Out', clockOutTime),
                            const Divider(
                              color: MyColor.colorD7E3FC,
                              height: 1,
                            ),
                            _infoRow(
                              'Total Duration',
                              totalDuration,
                              valueStyle: TextStyle(
                                color: MyColor.color2750C4,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Confirm button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColor.color021034,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            // TODO: perform actual clock-out action here (API/provider)
                            Future.delayed(
                              const Duration(milliseconds: 200),
                              () {
                                _showShiftSummaryDialog(
                                  context,
                                  clockIn: clockInTime,
                                  clockOut: clockOutTime,
                                  totalDuration: totalDuration,
                                );
                              },
                            );
                          },
                          icon: SvgPicture.asset(
                            AssetsImages.clock,
                            width: 18,
                            height: 18,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Confirm Clock Out',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Cancel button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                      child: SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(color: Color(0xFFE6E9F0)),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
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
        );
      },
    );
  }

  void _showShiftSummaryDialog(
    BuildContext context, {
    required String clockIn,
    required String clockOut,
    required String totalDuration,
  }) {
    final String dateString = DateTime.now().toLocal().toString().split(' ')[0];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Container(
                decoration: _cardDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close icon row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 12, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ),

                    // Top icon (use provided SVG)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: SvgPicture.asset(
                        AssetsImages.rightpop,
                        width: 60,
                        height: 60,
                      ),
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      'Today Shift Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Clocked out successfully',
                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 14),

                    // Info card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: MyColor.colorF4F4F5,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  dateString,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Clock In',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  clockIn,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Clock Out',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  clockOut,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Duration',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  totalDuration,
                                  style: TextStyle(
                                    color: MyColor.color2750C4,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Status',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColor.colorF4F4F5,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Text(
                                    'Verified',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Primary action
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColor.color021034,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            // navigate to monthly attendance screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MonthlyAttendanceScreen(),
                              ),
                            );
                          },
                          icon: SvgPicture.asset(
                            AssetsImages.clock,
                            width: 18,
                            height: 18,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'View Monthly Attendance',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                      child: SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TeacherBottomNav(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Back to Home',
                            style: TextStyle(color: Colors.black87),
                          ),
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

  Widget _labelValueRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontFamily: 'Roboto',
          ),
        ),
        Text(value, style: const TextStyle(fontSize: 14, fontFamily: 'Roboto')),
      ],
    );
  }

  Widget _infoRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(
            value,
            style:
                valueStyle ??
                const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _summaryBox(String title, String count, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: textColor.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: textColor,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= DECORATION (reused from MyProfileScreen)

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
