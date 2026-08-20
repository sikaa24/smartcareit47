import 'package:flutter/material.dart';

import '../state/app_session.dart';
import '../widgets/smartcare_dashboard_header.dart';
import '../widgets/smartcare_bottom_nav.dart'
    show SmartCareBottomNav, SmartCareBottomItem, smartCareGoTo;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    SmartCareSession.switchRole(UserRole.patient);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F2E4),
      bottomNavigationBar: const SmartCareBottomNav(
        currentItem: SmartCareBottomItem.home,
        roleOverride: UserRole.patient,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 380 ? 12.0 : 16.0;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const _DashboardHeader(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      14,
                      horizontalPadding,
                      24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _StatGrid(
                              stats: [
                                _DashboardStat(
                                  icon: Icons.groups,
                                  value: "12",
                                  label: "Queue #",
                                  detail: "You're in line",
                                  iconBackground: const Color(0xFFE0F4E1),
                                  iconColor: const Color(0xFF16751F),
                                  onTap: () {
                                    smartCareGoTo(context, '/queue');
                                  },
                                ),
                                _DashboardStat(
                                  icon: Icons.calendar_month,
                                  value: "5",
                                  label: "Visit this month",
                                  detail: "Keep your checkups",
                                  iconBackground: const Color(0xFFE7F6EA),
                                  iconColor: const Color(0xFF1E8D3E),
                                  onTap: () {
                                    smartCareGoTo(context, '/visits');
                                  },
                                ),
                                _DashboardStat(
                                  icon: Icons.event_available,
                                  value: "2",
                                  label: "Upcoming",
                                  detail: "Appointments",
                                  iconBackground: const Color(0xFFE5F4ED),
                                  iconColor: const Color(0xFF128049),
                                  onTap: () {
                                    smartCareGoTo(context, '/appointment');
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _SectionTitle(
                              title: "Upcoming Appointment",
                              routeName: '/appointment',
                            ),
                            const SizedBox(height: 10),
                            _UpcomingAppointmentCard(
                              onViewDetails: () {
                                smartCareGoTo(context, '/appointment');
                              },
                              onReschedule: () {
                                smartCareGoTo(context, '/appointment');
                              },
                              onCancel: () {
                                _showMessage(
                                  "Appointment cancellation request sent.",
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            _AiRecommendationCard(
                              onAccept: () {
                                smartCareGoTo(context, '/appointment');
                              },
                              onAlternatives: () {
                                _showMessage(
                                  "Showing alternative appointment schedules.",
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            const _SectionTitle(title: "Doctor Availability"),
                            const SizedBox(height: 10),
                            _DoctorAvailabilityCard(
                              onRefresh: () {
                                _showMessage("Doctor availability refreshed.");
                              },
                            ),
                            const SizedBox(height: 8),
                            const _DoctorLocationCard(),
                            const SizedBox(height: 8),
                            const _SectionTitle(title: "Quick Actions"),
                            const SizedBox(height: 10),
                            _QuickActionGrid(
                              actions: [
                                _DashboardAction(
                                  icon: Icons.event_available,
                                  label: "Book Appointment",
                                  iconColor: const Color(0xFF147C28),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    200,
                                    226,
                                    186,
                                  ),
                                  onPressed: () {
                                    smartCareGoTo(context, '/appointment');
                                  },
                                ),
                                _DashboardAction(
                                  icon: Icons.assignment_turned_in,
                                  label: "Queue Status",
                                  iconColor: const Color.fromARGB(
                                    255,
                                    74,
                                    189,
                                    246,
                                  ),
                                  backgroundColor: const Color.from(
                                    alpha: 1,
                                    red: 0.769,
                                    green: 0.91,
                                    blue: 0.906,
                                  ),
                                  onPressed: () {
                                    smartCareGoTo(context, '/queue');
                                  },
                                ),
                                _DashboardAction(
                                  icon: Icons.person,
                                  label: "Profile Settings",
                                  iconColor: const Color(0xFFFF8B00),
                                  backgroundColor: const Color(0xFFFFF1E3),
                                  onPressed: () {
                                    smartCareGoTo(context, '/profile');
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _SectionTitle(
                              title: "Notifications",
                              routeName: '/notifications',
                            ),
                            const SizedBox(height: 10),
                            _NotificationsCard(
                              onLabResult: () {
                                smartCareGoTo(context, '/results');
                              },
                              onAppointment: () {
                                smartCareGoTo(context, '/appointment');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return const SmartCareDashboardHeader(
      title: "Good morning, Carise!",
      subtitle: "Here's your health overview today.",
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.stats});

  final List<_DashboardStat> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        stats.length,
        (index) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: stats[index],
          ),
        ),
      ),
    );
  }
}

class _DashboardStat extends StatelessWidget {
  const _DashboardStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.detail,
    required this.iconBackground,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final String detail;
  final Color iconBackground;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(minHeight: 75),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD2E7D1)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: iconBackground,
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1A3320),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            detail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6E8D73), fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.routeName});

  final String title;
  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1B6F2A),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (routeName != null)
          TextButton(
            onPressed: () {
              smartCareGoTo(context, routeName!);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF16751F),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: const Text("View all >"),
          ),
      ],
    );
  }
}

class _UpcomingAppointmentCard extends StatelessWidget {
  const _UpcomingAppointmentCard({
    required this.onViewDetails,
    required this.onReschedule,
    required this.onCancel,
  });

  final VoidCallback onViewDetails;
  final VoidCallback onReschedule;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFDDF6DD),
                child: Icon(Icons.person, color: Color(0xFF16751F), size: 32),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dr. Camagay",
                      style: TextStyle(
                        color: Color(0xFF1A3320),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "General Consultation",
                      style: TextStyle(color: Color(0xFF506D54), fontSize: 12),
                    ),
                    SizedBox(height: 8),
                    _AppointmentMeta(
                      icon: Icons.calendar_today,
                      text: "June 15, 2026 (Mon) - 2:00 PM",
                    ),
                    SizedBox(height: 5),
                    _AppointmentMeta(
                      icon: Icons.location_on,
                      text: "Sta. Rita - Main Clinic",
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const _StatusPill(
                label: "Confirmed",
                color: Color(0xFFDDF6DD),
                textColor: Color(0xFF16751F),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SolidActionButton(
                  label: "View Details",
                  onPressed: onViewDetails,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OutlineActionButton(
                  label: "Reschedule",
                  borderColor: const Color(0xFF16751F),
                  textColor: const Color(0xFF16751F),
                  onPressed: onReschedule,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OutlineActionButton(
                  label: "Cancel",
                  borderColor: const Color(0xFFFF4B4B),
                  textColor: const Color(0xFFE83232),
                  onPressed: onCancel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppointmentMeta extends StatelessWidget {
  const _AppointmentMeta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF506D54), size: 14),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF506D54), fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class _AiRecommendationCard extends StatelessWidget {
  const _AiRecommendationCard({
    required this.onAccept,
    required this.onAlternatives,
  });

  final VoidCallback onAccept;
  final VoidCallback onAlternatives;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F3FF),
        border: Border.all(color: const Color(0xFFE2D2FF)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFF5C28D6), size: 18),
              SizedBox(width: 7),
              Text(
                "AI Schedule Recommendation",
                style: TextStyle(
                  color: Color(0xFF5C28D6),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE8DFFF)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFEDE3FF),
                  child: Icon(
                    Icons.calendar_month,
                    color: Color(0xFF5C28D6),
                    size: 19,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recommended for you",
                        style: TextStyle(
                          color: Color(0xFF6E8D73),
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "June 15, 2026 (Mon) - 2:00 PM",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF5C28D6),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Dr. Camagay",
                        style: TextStyle(
                          color: Color(0xFF1A3320),
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        "SmartCare Clinic - Main Branch",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF506D54),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PurpleActionButton(
                  label: "Accept",
                  onPressed: onAccept,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PurpleOutlineButton(
                  label: "View Alternatives",
                  onPressed: onAlternatives,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DoctorAvailabilityCard extends StatelessWidget {
  const _DoctorAvailabilityCard({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor info section
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFDDF6DD),
                child: Icon(Icons.person, color: Color(0xFF16751F), size: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dr. Camagay",
                      style: TextStyle(
                        color: Color(0xFF1A3320),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const _AvailabilityStatus(
                      color: Color(0xFF0DA94C),
                      text: "In Clinic",
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFE3EFE1)),
          const SizedBox(height: 8),
          // Branch list - side by side layout
          Row(
            children: [
              Expanded(
                child: _BranchListItem(
                  branch: "Sta. Rita",
                  inClinic: true,
                  timestamp: "15 mins ago",
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BranchListItem(
                  branch: "Lubao",
                  inClinic: false,
                  timestamp: "1 hr ago",
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BranchListItem(
                  branch: "Guagua",
                  inClinic: false,
                  timestamp: "2 hrs ago",
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8F0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Color(0xFF506D54),
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Last updated: Just now",
                  style: TextStyle(color: Color(0xFF506D54), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailabilityStatus extends StatelessWidget {
  const _AvailabilityStatus({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF16751F),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _BranchListItem extends StatelessWidget {
  const _BranchListItem({
    required this.branch,
    required this.inClinic,
    required this.timestamp,
  });

  final String branch;
  final bool inClinic;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    final statusColor = inClinic ? const Color(0xFF0DA94C) : Colors.orange;
    final statusText = inClinic ? "In Clinic" : "Not in Clinic";

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD2E7D1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, color: Color(0xFF506D54), size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  branch,
                  style: const TextStyle(
                    color: Color(0xFF1A3320),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            timestamp,
            style: const TextStyle(color: Color(0xFF71B17A), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _DoctorLocationCard extends StatelessWidget {
  const _DoctorLocationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Doctor's Location",
            style: TextStyle(
              color: Color(0xFF1B6F2A),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8F0),
              border: Border.all(color: const Color(0xFFE3EFE1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F4E1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Color(0xFF16751F),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Doctor is near the Sta.Rita Clinic",
                            style: TextStyle(
                              color: Color(0xFF1B6F2A),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Estimated arrival in 8 mins",
                            style: TextStyle(
                              color: Color(0xFF506D54),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF506D54),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        "Sta. Rita - Main Clinic",
                        style: TextStyle(
                          color: Color(0xFF506D54),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to map
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF16751F),
                      side: const BorderSide(color: Color(0xFF16751F)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "View on Map",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8F0),
              border: Border.all(color: const Color(0xFFD2E7D1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFF16751F),
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "We'll notify you when your doctor arrives at the clinic or if they are on their way out after your consultation.",
                    style: TextStyle(
                      color: Color(0xFF506D54),
                      fontSize: 11,
                      height: 1.4,
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

class _QuickActionGrid extends StatelessWidget {
  const _QuickActionGrid({required this.actions});

  final List<_DashboardAction> actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = 2;
        final spacing = 12.0;
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          alignment: WrapAlignment.center,
          spacing: spacing,
          runSpacing: 10,
          children: actions.map((action) {
            return SizedBox(
              width: itemWidth,
              height: 82,
              child: _QuickActionTile(action: action),
            );
          }).toList(),
        );
      },
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});

  final _DashboardAction action;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: action.backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: action.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, color: action.iconColor, size: 28),
              const SizedBox(height: 7),
              Text(
                action.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF1A3320),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationsCard extends StatelessWidget {
  const _NotificationsCard({
    required this.onLabResult,
    required this.onAppointment,
  });

  final VoidCallback onLabResult;
  final VoidCallback onAppointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _NotificationTile(
            dotColor: const Color(0xFF0DA94C),
            title: "Your lab result is now available.",
            subtitle: "May 10, 2026 - 10:00 am",
            onTap: onLabResult,
          ),
          const Divider(height: 1, color: Color(0xFFE3EFE1)),
          _NotificationTile(
            dotColor: Colors.orange,
            title: "You have an appointment tomorrow.",
            subtitle: "May 11, 2026 - 04:30 pm",
            onTap: onAppointment,
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.dotColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Color dotColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF1A3320),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF6E8D73),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF506D54)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      constraints: const BoxConstraints(minWidth: 78),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          maxLines: 1,
          style: TextStyle(
            color: textColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _SolidActionButton extends StatelessWidget {
  const _SolidActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF16751F),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.label,
    required this.borderColor,
    required this.textColor,
    required this.onPressed,
  });

  final String label;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _PurpleActionButton extends StatelessWidget {
  const _PurpleActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5C28D6),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _PurpleOutlineButton extends StatelessWidget {
  const _PurpleOutlineButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF5C28D6),
          side: const BorderSide(color: Color(0xFF7E50DD)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "View Alternatives",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _DashboardAction {
  const _DashboardAction({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.backgroundColor,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onPressed;
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    border: Border.all(color: const Color(0xFFD2E7D1)),
    borderRadius: BorderRadius.circular(8),
  );
}
