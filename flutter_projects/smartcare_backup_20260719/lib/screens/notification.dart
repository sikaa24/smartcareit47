import 'package:flutter/material.dart';
import '../state/app_session.dart';
import '../widgets/smartcare_bottom_nav.dart';
import '../widgets/smartcare_dashboard_header.dart';

class NotificationModel {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;
  final String type; // 'Alerts', 'Reminders', 'Announcements', 'System'

  NotificationModel({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.type,
  });
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String selectedFilter = 'All';

  final List<NotificationModel> allNotifications = [
    NotificationModel(
      title: 'Doctor Arrived',
      subtitle:
          'Dr. Camagay has arrived at Sta. Rita.\nYour Queue #12 is now active.',
      time: '2:50 PM',
      icon: Icons.location_on,
      iconColor: const Color(0xFF146F1B),
      type: 'Alerts',
    ),
    NotificationModel(
      title: 'Appointment Reminder',
      subtitle:
          'You have an appointment with Dr. Camagay\non May 13, 2026 at 2:00 PM.',
      time: '2:00 PM',
      icon: Icons.calendar_today,
      iconColor: const Color(0xFF146F1B),
      type: 'Reminders',
    ),
    NotificationModel(
      title: 'Clinic Announcement',
      subtitle:
          'Please be informed that clinic will be closed\non May 15, 2026 (Labor Day).',
      time: 'Yesterday',
      icon: Icons.campaign,
      iconColor: const Color(0xFF146F1B),
      type: 'Announcements',
    ),
    NotificationModel(
      title: 'Geofence Check-in',
      subtitle: 'You have entered the clinic area.\nThank you!',
      time: 'Yesterday',
      icon: Icons.wifi,
      iconColor: const Color(0xFF146F1B),
      type: 'Alerts',
    ),
    NotificationModel(
      title: 'Appointment Confirmed',
      subtitle:
          'Your appointment with Dr. Camagay\non May 13, 2026 at 2:00 PM is confirmed.',
      time: 'May 10',
      icon: Icons.calendar_today,
      iconColor: const Color(0xFFFFA500),
      type: 'Reminders',
    ),
    NotificationModel(
      title: 'System Notification',
      subtitle: 'Your profile information has been updated\nsuccessfully.',
      time: 'May 9',
      icon: Icons.security,
      iconColor: const Color(0xFF7C3AED),
      type: 'System',
    ),
  ];

  List<NotificationModel> getFilteredNotifications() {
    if (selectedFilter == 'All') {
      return allNotifications;
    }
    return allNotifications
        .where((notification) => notification.type == selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDECD9),
      bottomNavigationBar: const SmartCareBottomNav(
        currentItem: SmartCareBottomItem.menu,
      ),

      body: SafeArea(
        child: ListView(
          children: [
            const SmartCareDashboardHeader(
              title: "Notifications",
              subtitle:
                  "Stay updated with important announcements, reminders, and alerts.",
            ),

            // ================= BODY =================
            Container(
              width: double.infinity,
              color: const Color(0xFFDDECD9),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

              child: Column(
                children: [
                  // ================= DOCTOR ARRIVED CARD =================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF1D6F22),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // AVATAR
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(0xFFDCE9D0),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF1B7A1F),
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Doctor Arrived!",
                                    style: TextStyle(
                                      color: Color(0xFF14731D),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Dr. Camagay has arrived at Sta. Rita.\nYour Queue #12 is now active.",
                                    style: TextStyle(
                                      color: Color(0xFF49A34D),
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFF1D6F22),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Sta. Rita Clinic",
                              style: TextStyle(
                                color: Color(0xFF1D6F22),
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.access_time,
                              color: Color(0xFF1D6F22),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "2:50 PM",
                              style: TextStyle(
                                color: Color(0xFF1D6F22),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  smartCareGoTo(context, '/queue');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF146F1B),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "View Queue",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ================= FILTER TABS =================
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterTab(
                          label: "All",
                          isActive: selectedFilter == 'All',
                          onTap: () {
                            setState(() {
                              selectedFilter = 'All';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterTab(
                          label: "Alerts",
                          isActive: selectedFilter == 'Alerts',
                          onTap: () {
                            setState(() {
                              selectedFilter = 'Alerts';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterTab(
                          label: "Reminders",
                          isActive: selectedFilter == 'Reminders',
                          onTap: () {
                            setState(() {
                              selectedFilter = 'Reminders';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterTab(
                          label: "Announcements",
                          isActive: selectedFilter == 'Announcements',
                          onTap: () {
                            setState(() {
                              selectedFilter = 'Announcements';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterTab(
                          label: "System",
                          isActive: selectedFilter == 'System',
                          onTap: () {
                            setState(() {
                              selectedFilter = 'System';
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ================= NOTIFICATIONS LIST =================
                  ...getFilteredNotifications().asMap().entries.map((entry) {
                    int index = entry.key;
                    NotificationModel notification = entry.value;
                    return Column(
                      children: [
                        _NotificationListItem(
                          title: notification.title,
                          subtitle: notification.subtitle,
                          time: notification.time,
                          icon: notification.icon,
                          iconColor: notification.iconColor,
                          onTap: () {},
                        ),
                        if (index < getFilteredNotifications().length - 1)
                          const SizedBox(height: 12),
                      ],
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

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF146F1B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF146F1B), width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF146F1B),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _NotificationListItem extends StatelessWidget {
  const _NotificationListItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF146F1B),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF7A9B76),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      color: Color(0xFFA2C989),
                      fontSize: 11,
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
}
