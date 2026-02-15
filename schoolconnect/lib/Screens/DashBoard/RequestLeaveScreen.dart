import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:schoolconnect/export.dart';
import 'package:provider/provider.dart';
import '../../provider/request_leave_provider.dart';

class RequestLeaveScreen extends StatelessWidget {
  const RequestLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RequestLeaveProvider(),
      child: Consumer<RequestLeaveProvider>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: MyColor.background,
            appBar: AppBar(
              backgroundColor: MyColor.background,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Apply Leave",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.help_outline, color: Colors.black54),
                  onPressed: () {},
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _progressSection(model),
                  const SizedBox(height: 20),
                  _leaveDetailsCard(context, model),
                  const SizedBox(height: 16),
                  _supportingDetailsCard(context, model),
                  const SizedBox(height: 16),
                  _reasonCard(context, model),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            bottomNavigationBar: _bottomActionBar(context, model),
          );
        },
      ),
    );
  }

  Widget _progressSection(RequestLeaveProvider model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "APPLICATION PROGRESS",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (context) {
            const int totalSteps = 3;
            int completed = 0;
            if (model.leaveType != null &&
                model.startDate != null &&
                model.endDate != null) {
              completed += 1;
            }
            if (model.reason.trim().isNotEmpty) completed += 1;
            if (model.attachmentPath != null &&
                model.attachmentPath!.isNotEmpty)
              completed += 1;

            final double progress = (totalSteps == 0)
                ? 0.0
                : (completed / totalSteps);
            final int stepNumber = (completed < totalSteps)
                ? (completed + 1)
                : totalSteps;

            return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation(
                      MyColor.color021034,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "STEP $stepNumber OF $totalSteps",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _leaveDetailsCard(BuildContext context, RequestLeaveProvider model) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.calendar_today_outlined, "Leave Type"),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: model.leaveType,
            items: const [
              DropdownMenuItem(value: 'Sick', child: Text('Sick Leave')),
              DropdownMenuItem(value: 'Casual', child: Text('Casual Leave')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: MyColor.colorD7E3FC),
              ),
            ),
            onChanged: model.setLeaveType,
            hint: const Text('Select leave type'),
          ),
          const SizedBox(height: 16),
          _sectionTitle(Icons.date_range_outlined, "Date Range"),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: model.startDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) model.setStartDate(picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: MyColor.colorD7E3FC),
                    ),
                    child: Text(
                      model.startDate == null
                          ? 'Start date'
                          : _formatDate(model.startDate!),
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: model.endDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) model.setEndDate(picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: MyColor.colorD7E3FC),
                    ),
                    child: Text(
                      model.endDate == null
                          ? 'End date'
                          : _formatDate(model.endDate!),
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: _cardDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total duration:",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  "${model.durationDays} Days",
                  style: const TextStyle(
                    color: MyColor.color021034,
                    fontWeight: FontWeight.w600,
                  ),
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
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: MyColor.colorD7E3FC, width: 1.5),
    );
  }

  Widget _supportingDetailsCard(
    BuildContext context,
    RequestLeaveProvider model,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.attachment_outlined, "Attachment"),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                withData: false,
              );
              if (result != null && result.files.isNotEmpty) {
                final file = result.files.first;
                // On mobile platforms this will be a path; on web it's null.
                final path = file.path;
                if (path != null && path.isNotEmpty) {
                  model.setAttachment(path, name: file.name);
                } else if (file.bytes != null) {
                  // fallback: record a placeholder path and set the original file name
                  model.setAttachment('uploaded', name: file.name);
                }
              }
            },
            child: DottedBorder(
              color: MyColor.colorD7E3FC,
              strokeWidth: 1.5,
              radius: const Radius.circular(10),
              dashPattern: const [6, 6],
              child: Container(
                width: double.infinity,
                height: 110,
                padding: const EdgeInsets.all(12),
                child:
                    (model.attachmentPath == null &&
                        model.attachmentName == null)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.cloud_upload_outlined,
                              color: Colors.grey,
                              size: 28,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Upload medical certificate or documents',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'PDF, JPG up to 5MB',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          const Icon(
                            Icons.insert_drive_file,
                            size: 32,
                            color: MyColor.color021034,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.attachmentName ??
                                      (model.attachmentPath ?? '')
                                          .split('/')
                                          .last,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  model.attachmentPath ?? '',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: model.clearAttachment,
                            icon: const Icon(Icons.close, color: Colors.grey),
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

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: MyColor.color021034),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _reasonCard(BuildContext context, RequestLeaveProvider model) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.chat_bubble_outline, "Reason for Leave"),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: model.reason,
            maxLines: 6,
            onChanged: model.setReason,
            decoration: InputDecoration(
              hintText: 'Please describe the reason for your absence...',
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: MyColor.colorD7E3FC),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomActionBar(BuildContext context, RequestLeaveProvider model) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MyColor.colorD7E3FC),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 48,
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: MyColor.color021034,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () async {
                    await model.submit();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request submitted')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Submit Request',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: MyColor.colorD7E3FC),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: MyColor.colorD7E3FC),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return "${d.day}/${d.month}/${d.year}";
  }
}
