import 'package:flutter/material.dart';
import '../widgets/smartcare_bottom_nav.dart';
import '../widgets/smartcare_dashboard_header.dart';

class ActivityLog {
  final String name;
  final String action;
  final String actionType;
  final String timestamp;
  final IconData icon;
  final Color iconColor;
  final String role;

  ActivityLog({
    required this.name,
    required this.action,
    required this.actionType,
    required this.timestamp,
    required this.icon,
    required this.iconColor,
    required this.role,
  });
}

class NotificationDoctorNursePage extends StatefulWidget {
  const NotificationDoctorNursePage({super.key});

  @override
  State<NotificationDoctorNursePage> createState() =>
      _NotificationDoctorNursePageState();
}

class _NotificationDoctorNursePageState
    extends State<NotificationDoctorNursePage> {
  String sortBy = 'Newest First';

  final List<ActivityLog> activityLogs = [
    ActivityLog(
      name: 'Dr. Camagay',
      action: 'viewed the patient record of Juan Dela Cruz.',
      actionType: 'Patient Record',
      timestamp: '2:50 PM',
      icon: Icons.person,
      iconColor: const Color(0xFF146F1B),
      role: 'Doctor',
    ),
    ActivityLog(
      name: 'Secretary Ana',
      action:
          'updated the appointment of Maria Santos\nfrom May 18, 8:30 AM to May 18, 9:00 AM.',
      actionType: 'Appointment',
      timestamp: '2:35 PM',
      icon: Icons.assignment,
      iconColor: const Color(0xFF7C3AED),
      role: 'Secretary',
    ),
    ActivityLog(
      name: 'Secretary Ana',
      action: 'added a new patient record for Pedro Reyes.',
      actionType: 'Patient Record',
      timestamp: '2:20 PM',
      icon: Icons.person_add,
      iconColor: const Color(0xFFFFA500),
      role: 'Secretary',
    ),
    ActivityLog(
      name: 'Dr. Camagay',
      action:
          'rescheduled an appointment of Ligaya Bonifacio\nfrom May 20, 10:00 AM to May 21, 10:00 AM.',
      actionType: 'Appointment',
      timestamp: '1:45 PM',
      icon: Icons.calendar_today,
      iconColor: const Color(0xFF146F1B),
      role: 'Doctor',
    ),
    ActivityLog(
      name: 'Secretary Ana',
      action:
          'cancelled the appointment of Ana Aquino\nscheduled on May 18, 9:30 AM.',
      actionType: 'Appointment',
      timestamp: '11:30 AM',
      icon: Icons.cancel,
      iconColor: const Color(0xFFFF304B),
      role: 'Secretary',
    ),
    ActivityLog(
      name: 'Dr. Camagay',
      action: 'viewed the patient record of Maria Santos.',
      actionType: 'Patient Record',
      timestamp: '4:15 PM',
      icon: Icons.person,
      iconColor: const Color(0xFF146F1B),
      role: 'Doctor',
    ),
    ActivityLog(
      name: 'Secretary Ana',
      action:
          'rescheduled an appointment of Juan Dela Cruz\nfrom May 17, 3:00 PM to May 18, 8:00 AM.',
      actionType: 'Appointment',
      timestamp: '3:40 PM',
      icon: Icons.calendar_today,
      iconColor: const Color(0xFF7C3AED),
      role: 'Secretary',
    ),
  ];

  List<ActivityLog> getSortedLogs() {
    final sorted = List<ActivityLog>.from(activityLogs);
    if (sortBy == 'Oldest First') {
      return sorted.reversed.toList();
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBF5),
      bottomNavigationBar: const SmartCareBottomNav(
        currentItem: SmartCareBottomItem.menu,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SmartCareDashboardHeader(
              title: 'Activity Logs',
              subtitle:
                  'Audit logs to ensure accountability by recording important actions',
            ),
            // ================= HEADER WITH SORT AND EXPORT =================
            Container(
              width: double.infinity,
              color: const Color(0xFFF6FBF5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  // Sort dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFFD2E7D1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Sort by: ',
                          style: TextStyle(
                            color: Color(0xFF6E8D73),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        PopupMenuButton<String>(
                          initialValue: sortBy,
                          onSelected: (value) {
                            setState(() {
                              sortBy = value;
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem(
                                value: 'Newest First',
                                child: Text('Newest First'),
                              ),
                              const PopupMenuItem(
                                value: 'Oldest First',
                                child: Text('Oldest First'),
                              ),
                            ];
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                sortBy,
                                style: const TextStyle(
                                  color: Color(0xFF1A3320),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF1A3320),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ================= ACTIVITY LOG ENTRIES =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                children: [
                  // May 18, 2026
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'May 18, 2026',
                        style: TextStyle(
                          color: const Color(0xFF6E8D73),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  ...getSortedLogs().sublist(0, 5).map((log) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ActivityLogCard(log: log),
                    );
                  }).toList(),
                  // May 17, 2026
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'May 17, 2026',
                        style: TextStyle(
                          color: const Color(0xFF6E8D73),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  ...getSortedLogs().sublist(5).map((log) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ActivityLogCard(log: log),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityLogCard extends StatelessWidget {
  const _ActivityLogCard({required this.log});

  final ActivityLog log;

  Color _getActionTypeColor(String actionType) {
    switch (actionType) {
      case 'Patient Record':
        return const Color(0xFFECF1EE);
      case 'Appointment':
        return const Color(0xFFF3E8FF);
      default:
        return const Color(0xFFFFF8E1);
    }
  }

  Color _getActionTypeBadgeColor(String actionType) {
    switch (actionType) {
      case 'Patient Record':
        return const Color(0xFF146F1B);
      case 'Appointment':
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFFFFA500);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3EFE1), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: log.iconColor.withOpacity(0.15),
            ),
            child: Center(
              child: Icon(log.icon, color: log.iconColor, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and timestamp
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log.name,
                            style: const TextStyle(
                              color: Color(0xFF1A3320),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            log.action,
                            style: const TextStyle(
                              color: Color(0xFF6E8D73),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      log.timestamp,
                      style: const TextStyle(
                        color: Color(0xFF9CB0A0),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Action type badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getActionTypeColor(log.actionType),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    log.actionType,
                    style: TextStyle(
                      color: _getActionTypeBadgeColor(log.actionType),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
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
