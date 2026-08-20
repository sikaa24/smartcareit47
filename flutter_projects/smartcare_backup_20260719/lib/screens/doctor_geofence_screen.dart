import 'package:flutter/material.dart';
import '../state/app_session.dart';
import '../widgets/smartcare_bottom_nav.dart';
import '../widgets/smartcare_dashboard_header.dart';

class DoctorGeofenceScreen extends StatefulWidget {
  const DoctorGeofenceScreen({super.key});

  @override
  State<DoctorGeofenceScreen> createState() => _DoctorGeofenceScreenState();
}

class _DoctorGeofenceScreenState extends State<DoctorGeofenceScreen> {
  bool _entryAlertEnabled = true;
  bool _exitAlertEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBF5),
      bottomNavigationBar: const SmartCareBottomNav(
        currentItem: SmartCareBottomItem.geofence,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SmartCareDashboardHeader(
              title: "Geofencing",
              subtitle:
                  "Manage your clinic area and get alerts when you or patients enter or exit.",
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Geofencing Status Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFD5E4D5)),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF0F6B2F,
                          ).withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F8E3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Color(0xFF0F6B2F),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Geofencing Status',
                                style: TextStyle(
                                  color: Color(0xFF1A3320),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Active',
                                style: TextStyle(
                                  color: Color(0xFF0F6B2F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'You are inside the clinic area',
                                style: TextStyle(
                                  color: Color(0xFF506D54),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Check-in: 7:58 AM',
                                style: TextStyle(
                                  color: const Color(0xFF6E8D73),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.map, size: 16),
                          label: const Text('View on Map'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0F6B2F),
                            side: const BorderSide(color: Color(0xFF0F6B2F)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Geofence Rules
                  const Text(
                    'Geofence Rules',
                    style: TextStyle(
                      color: Color(0xFF1B6F2A),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Entry Alert Rule
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE0E8E0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F8E3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.login,
                            color: Color(0xFF0F6B2F),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Entry Alert',
                                style: TextStyle(
                                  color: Color(0xFF1A3320),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Notify when you or patients enter the clinic area',
                                style: TextStyle(
                                  color: Color(0xFF506D54),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _entryAlertEnabled,
                          onChanged: (value) {
                            setState(() => _entryAlertEnabled = value);
                          },
                          activeColor: const Color(0xFF0F6B2F),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Exit Alert Rule
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE0E8E0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F8E3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.logout,
                            color: Color(0xFF0F6B2F),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Exit Alert',
                                style: TextStyle(
                                  color: Color(0xFF1A3320),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Notify when you or patients exit the clinic area',
                                style: TextStyle(
                                  color: Color(0xFF506D54),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _exitAlertEnabled,
                          onChanged: (value) {
                            setState(() => _exitAlertEnabled = value);
                          },
                          activeColor: const Color(0xFF0F6B2F),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Activity Log
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Activity Log',
                        style: TextStyle(
                          color: Color(0xFF1B6F2A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFD5E4D5)),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF0F6B2F,
                          ).withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _ActivityLogItem(
                          key: const ValueKey('log1'),
                          icon: Icons.login,
                          iconColor: const Color(0xFF0F6B2F),
                          title: 'You entered the clinic area',
                          time: 'Today, 7:58 AM',
                          radius: '200m radius',
                        ),
                        const SizedBox(height: 12),
                        _ActivityLogItem(
                          key: const ValueKey('log2'),
                          icon: Icons.groups,
                          iconColor: const Color(0xFFA4D98D),
                          title:
                              'Patient Juan Dela Rosa entered the clinic area',
                          time: 'Today, 8:05 AM',
                          radius: '200m radius',
                        ),
                        const SizedBox(height: 12),
                        _ActivityLogItem(
                          key: const ValueKey('log3'),
                          icon: Icons.logout,
                          iconColor: const Color(0xFFFF9800),
                          title: 'Patient Maria Santos exited the clinic area',
                          time: 'Today, 10:12 AM',
                          radius: '200m radius',
                        ),
                        const SizedBox(height: 12),
                        _ActivityLogItem(
                          key: const ValueKey('log4'),
                          icon: Icons.login,
                          iconColor: const Color(0xFF0F6B2F),
                          title: 'You entered the clinic area',
                          time: 'Today, 10:45 AM',
                          radius: '200m radius',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityLogItem extends StatelessWidget {
  const _ActivityLogItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.time,
    required this.radius,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String time;
  final String radius;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1A3320),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(color: Color(0xFF6E8D73), fontSize: 11),
              ),
            ],
          ),
        ),
        Text(
          radius,
          style: const TextStyle(color: Color(0xFF6E8D73), fontSize: 11),
        ),
      ],
    );
  }
}
