import 'package:flutter/material.dart';
import '../widgets/smartcare_bottom_nav.dart';
import '../widgets/smartcare_bottom_nav.dart' show smartCareGoTo;
import '../widgets/smartcare_dashboard_header.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  late DateTime _selectedDate;
  bool _showAllSchedule = false;

  final List<Map<String, String>> _defaultAppointments = [
    {
      "time": "10:15 AM - 10:45 AM",
      "patient": "Jesika Guiao",
      "type": "Consultation",
      "status": "Completed",
    },
    {
      "time": "10:45 AM - 11:15 AM",
      "patient": "Rayne Ocampo",
      "type": "Follow-up Checkup",
      "status": "In Progress",
    },
    {
      "time": "11:00 AM - 11:30 AM",
      "patient": "Mary Rose Valencia",
      "type": "BP Monitoring",
      "status": "Current",
    },
    {
      "time": "11:30 AM - 12:00 PM",
      "patient": "Mark Felizardo",
      "type": "Consultation",
      "status": "Upcoming",
    },
  ];

  final List<Map<String, String>> _allAppointments = [
    {
      "time": "10:15 AM - 10:45 AM",
      "patient": "Jesika Guiao",
      "type": "Consultation",
      "status": "Completed",
    },
    {
      "time": "10:45 AM - 11:15 AM",
      "patient": "Rayne Ocampo",
      "type": "Follow-up Checkup",
      "status": "In Progress",
    },
    {
      "time": "11:00 AM - 11:30 AM",
      "patient": "Mary Rose Valencia",
      "type": "BP Monitoring",
      "status": "Current",
    },
    {
      "time": "11:30 AM - 12:00 PM",
      "patient": "Mark Felizardo",
      "type": "Consultation",
      "status": "Upcoming",
    },
    {
      "time": "12:00 PM - 12:30 PM",
      "patient": "Carl Zita",
      "type": "Consultation",
      "status": "Upcoming",
    },
    {
      "time": "12:30 PM - 1:00 PM",
      "patient": "Jeric Magtibay",
      "type": "Follow-up",
      "status": "Upcoming",
    },
    {
      "time": "1:00 PM - 1:30 PM",
      "patient": "Jaz Rozas",
      "type": "Consultation",
      "status": "Upcoming",
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2027),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _showMessage(
        "Date selected: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleShowAllSchedule() {
    setState(() {
      _showAllSchedule = !_showAllSchedule;
    });
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A3320),
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(double heightPercentage, String time) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: heightPercentage,
          decoration: BoxDecoration(
            color: heightPercentage >= 50
                ? const Color(0xFF16A34A)
                : const Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          time,
          style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  List<Widget> _buildScheduleList() {
    List<Widget> children = [];
    List<Map<String, String>> displayedAppointments = _showAllSchedule
        ? _allAppointments
        : _defaultAppointments;

    for (int i = 0; i < displayedAppointments.length; i++) {
      final item = displayedAppointments[i];
      children.add(
        _AppointmentCard(
          time: item["time"]!,
          patient: item["patient"]!,
          type: item["type"]!,
          status: item["status"]!,
        ),
      );
      if (i < displayedAppointments.length - 1) {
        children.add(
          const Divider(height: 1, thickness: 1, color: Color(0xFFE3EFE1)),
        );
      }
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      bottomNavigationBar: const SmartCareBottomNav(
        currentItem: SmartCareBottomItem.schedule,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 380 ? 12.0 : 16.0;

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const SmartCareDashboardHeader(
                  title: "Schedule",
                  subtitle: "View and manage your daily schedule.",
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    20,
                    horizontalPadding,
                    24,
                  ),
                  child: Column(
                    children: [
                      // Summary Cards Grid - MOVED TO TOP
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.6,
                        children: [
                          _SummaryCard(
                            icon: Icons.calendar_today,
                            value: "18",
                            label: "Appointments",
                            detail: "Total scheduled",
                          ),
                          _SummaryCard(
                            icon: Icons.check_circle,
                            value: "6",
                            label: "Completed",
                            detail: "Finished today",
                          ),
                          _SummaryCard(
                            icon: Icons.access_time,
                            value: "3",
                            label: "In Progress",
                            detail: "In consultation",
                          ),
                          _SummaryCard(
                            icon: Icons.schedule,
                            value: "9",
                            label: "Remaining",
                            detail: "Still waiting",
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Date Picker with Calendar Icon
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFD2E7D1),
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: _selectDate,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: Colors.green.shade700,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Select Date",
                                          style: TextStyle(
                                            color: Colors.green.shade700,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                                          style: const TextStyle(
                                            color: Color(0xFF1A3320),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.green.shade700,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Today's Schedule Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Today's Schedule",
                            style: TextStyle(
                              color: Color(0xFF1B6F2A),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: _toggleShowAllSchedule,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF16751F),
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 32),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                            child: Text(
                              _showAllSchedule ? "View Less >" : "View All >",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFD5E4D5)),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF0F6B2F,
                              ).withValues(alpha: 0.05),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(children: _buildScheduleList()),
                      ),
                      const SizedBox(height: 24),
                      // Schedule Overview Section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Schedule Overview",
                          style: TextStyle(
                            color: Color(0xFF1B6F2A),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFD5E4D5)),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF0F6B2F,
                              ).withValues(alpha: 0.05),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Donut Chart
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Completed (Green - 33%)
                                  SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: CircularProgressIndicator(
                                      value: 0.33,
                                      strokeWidth: 14,
                                      valueColor: const AlwaysStoppedAnimation(
                                        Color(0xFF16A34A),
                                      ),
                                      backgroundColor: const Color(
                                        0xFFDCDCDC,
                                      ).withValues(alpha: 0.3),
                                    ),
                                  ),
                                  // In Progress (Orange - 17%)
                                  Transform.rotate(
                                    angle: 2.07, // 33% of 2π
                                    child: SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: CircularProgressIndicator(
                                        value: 0.17,
                                        strokeWidth: 14,
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                              Color(0xFFFB923C),
                                            ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  // Center text
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "18",
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF16751F),
                                        ),
                                      ),
                                      Text(
                                        "Total",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),
                            // Legend
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildLegendItem(
                                    "Completed",
                                    "6 (33%)",
                                    const Color(0xFF16A34A),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildLegendItem(
                                    "In Progress",
                                    "3 (17%)",
                                    const Color(0xFFFB923C),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildLegendItem(
                                    "Upcoming",
                                    "9 (50%)",
                                    const Color(0xFFD1D5DB),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Peak Hours Section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Peak Hours",
                          style: TextStyle(
                            color: Color(0xFF1B6F2A),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFD5E4D5)),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF0F6B2F,
                              ).withValues(alpha: 0.05),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bar Chart
                            SizedBox(
                              height: 120,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildBarChart(20, "6 AM"),
                                  _buildBarChart(35, "9 AM"),
                                  _buildBarChart(60, "9 AM"),
                                  _buildBarChart(50, "12 PM"),
                                  _buildBarChart(30, "3 PM"),
                                  _buildBarChart(45, "6 PM"),
                                  _buildBarChart(40, "6 PM"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String detail;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD2E7D1)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: const Color(0xFFE0F4E1),
            child: Icon(icon, color: const Color(0xFF16751F), size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF16751F),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF1A3320),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF6E8D73), fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String time;
  final String patient;
  final String type;
  final String status;
  final VoidCallback? onTap;

  const _AppointmentCard({
    required this.time,
    required this.patient,
    required this.type,
    required this.status,
    this.onTap,
  });

  Color get statusColor {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "In Progress":
        return Colors.orange;
      case "Current":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Patient Initials Badge
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF16751F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                patient.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Appointment Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF1A3320),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "$time • $type",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF506D54),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
