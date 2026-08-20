import 'package:flutter/material.dart';
import '../state/app_session.dart';
import '../widgets/smartcare_dashboard_header.dart';
import '../widgets/smartcare_bottom_nav.dart';

class SecretaryDashboardScreen extends StatefulWidget {
  const SecretaryDashboardScreen({super.key});

  @override
  State<SecretaryDashboardScreen> createState() =>
      _SecretaryDashboardScreenState();
}

class _SecretaryDashboardScreenState extends State<SecretaryDashboardScreen> {
  bool _isInClinic = true;

  @override
  void initState() {
    super.initState();
    SmartCareSession.switchRole(UserRole.secretary);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleClinicStatus() {
    setState(() {
      _isInClinic = !_isInClinic;
    });

    _showMessage(
      _isInClinic
          ? "Clinic status updated to In Clinic."
          : "Clinic status updated to Out/Unavailable.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBF5),
      bottomNavigationBar: const SmartCareBottomNav(
        currentItem: SmartCareBottomItem.home,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 380 ? 12.0 : 16.0;

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const _DashboardHeader(
                  title: "Good morning, Ms. Secretary!",
                  subtitle: "Here's your overview for today.",
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    28,
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
                                value: "18",
                                label: "Patients Today",
                                detail: "Total patients scheduled",
                                onTap: () {
                                  smartCareGoTo(context, '/doctor-view');
                                },
                              ),
                              _DashboardStat(
                                icon: Icons.groups,
                                value: "15",
                                label: "In Queue",
                                detail: "Waiting for consultation",
                                onTap: () {
                                  smartCareGoTo(context, '/queue');
                                },
                              ),
                              _DashboardStat(
                                icon: Icons.medical_services,
                                value: "#8",
                                label: "Now Serving",
                                detail: "Currently in consultation",
                                onTap: () {
                                  smartCareGoTo(context, '/doctor-view');
                                },
                              ),
                              _DashboardStat(
                                icon: Icons.notifications_active,
                                value: "3",
                                label: "New Requests",
                                detail: "Appointment requests",
                                onTap: () {
                                  smartCareGoTo(context, '/appointment');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _SecretaryStatusBanner(
                            isDeskOpen: _isInClinic,
                            onToggle: _toggleClinicStatus,
                          ),
                          const SizedBox(height: 16),
                          _SectionHeader(
                            title: "Today's Consultations",
                            actionLabel: "View all",
                            onTap: () {
                              smartCareGoTo(context, '/secretary-schedule');
                            },
                          ),
                          const SizedBox(height: 12),
                          _ConsultationsCard(
                            children: [
                              _PatientTile(
                                initials: "AG",
                                name: "Carise Pineda",
                                detail: "9:00 AM - follow-up",
                                isActive: true,
                                onTap: () {
                                  smartCareGoTo(context, '/doctor-view');
                                },
                                onButtonPressed: () {
                                  smartCareGoTo(context, '/doctor-view');
                                },
                              ),
                              _PatientTile(
                                initials: "AZ",
                                name: "Jesika Guiao",
                                detail: "9:30 AM - Consultation",
                                onTap: () {
                                  _showMessage("Akym Zurc selected.");
                                },
                                onButtonPressed: () {
                                  smartCareGoTo(context, '/doctor-view');
                                },
                              ),
                              _PatientTile(
                                initials: "AA",
                                name: "Rayne Ocampo",
                                detail: "10:00 AM - Follow-up",
                                onTap: () {
                                  _showMessage("Acoc Aloc selected.");
                                },
                                onButtonPressed: () {
                                  smartCareGoTo(context, '/doctor-view');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const _ScheduleInsightCard(),
                        ],
                      ),
                    ),
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

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SmartCareDashboardHeader(title: title, subtitle: subtitle);
  }
}

class _SecretaryStatusBanner extends StatelessWidget {
  const _SecretaryStatusBanner({
    required this.isDeskOpen,
    required this.onToggle,
  });

  final bool isDeskOpen;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD2E7D1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Secretary info section
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
                      "Secretary Desk",
                      style: TextStyle(
                        color: Color(0xFF1A3320),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isDeskOpen
                          ? "Desk is open - ready to assist"
                          : "Desk is closed",
                      style: const TextStyle(
                        color: Color(0xFF16751F),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFE3EFE1)),
          const SizedBox(height: 8),
          // Availability and status controls
          Row(
            children: [
              _AvailabilityPill(isAvailable: isDeskOpen),
              const Spacer(),
              Transform.scale(
                scale: 0.86,
                child: Switch(
                  value: isDeskOpen,
                  onChanged: (_) => onToggle(),
                  activeThumbColor: const Color(0xFF16751F),
                  activeTrackColor: const Color(0xFFA4D98D),
                  inactiveThumbColor: const Color(0xFF8FA193),
                  inactiveTrackColor: const Color(0xFFDDE8DF),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Today's hours info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8F0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              children: [
                Icon(Icons.schedule, color: Color(0xFF506D54), size: 16),
                SizedBox(width: 8),
                Text(
                  "Today's Hours: 8:00 AM - 5:00 PM",
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

class _DoctorStatusBanner extends StatelessWidget {
  const _DoctorStatusBanner({required this.isInClinic, required this.onToggle});

  final bool isInClinic;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD2E7D1)),
        borderRadius: BorderRadius.circular(8),
      ),
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
                    Text(
                      isInClinic
                          ? "In Clinic - ready for patients"
                          : "Out of Clinic",
                      style: const TextStyle(
                        color: Color(0xFF16751F),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFE3EFE1)),
          const SizedBox(height: 8),
          // Availability and status controls
          Row(
            children: [
              _AvailabilityPill(isAvailable: isInClinic),
              const Spacer(),
              Transform.scale(
                scale: 0.86,
                child: Switch(
                  value: isInClinic,
                  onChanged: (_) => onToggle(),
                  activeThumbColor: const Color(0xFF16751F),
                  activeTrackColor: const Color(0xFFA4D98D),
                  inactiveThumbColor: const Color(0xFF8FA193),
                  inactiveTrackColor: const Color(0xFFDDE8DF),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Today's hours info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8F0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              children: [
                Icon(Icons.schedule, color: Color(0xFF506D54), size: 16),
                SizedBox(width: 8),
                Text(
                  "Today's Hours: 8:00 AM - 5:00 PM",
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

class _ScheduleInsightCard extends StatelessWidget {
  const _ScheduleInsightCard();

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
                "AI Schedule Insight",
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Peak Hours",
                  style: TextStyle(color: Color(0xFF6E8D73), fontSize: 10),
                ),
                const SizedBox(height: 2),
                const Text(
                  "10:00 AM - 12:00 PM",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF5C28D6),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Expected Patients",
                  style: TextStyle(color: Color(0xFF6E8D73), fontSize: 10),
                ),
                const SizedBox(height: 2),
                const Text(
                  "18",
                  style: TextStyle(
                    color: Color(0xFF5C28D6),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Based on historical data",
                  style: TextStyle(color: Color(0xFF506D54), fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GeofencingStatusCard extends StatelessWidget {
  const _GeofencingStatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD5E4D5)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F6B2F).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Color(0xFF16751F), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Geofencing Status",
                      style: TextStyle(
                        color: Color(0xFF16751F),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "You are inside the clinic area",
                      style: TextStyle(color: Color(0xFF506D54), fontSize: 12),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Check-in: 7:58 AM",
                      style: TextStyle(color: Color(0xFF6E8D73), fontSize: 11),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F8E3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.circle, color: Color(0xFF0E8A2C), size: 8),
                        SizedBox(width: 6),
                        Text(
                          "Active",
                          style: TextStyle(
                            color: Color(0xFF0E8A2C),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusInfoRow extends StatelessWidget {
  const _StatusInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SoftSquareIcon(icon: icon),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Color(0xFF5F6F63), fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF16751F),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvailabilityPill extends StatelessWidget {
  const _AvailabilityPill({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isAvailable ? const Color(0xFFCFEFCD) : const Color(0xFFE8ECE7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: isAvailable
                  ? const Color(0xFF0E8A2C)
                  : const Color(0xFF879188),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            isAvailable ? "Available" : "Away",
            style: TextStyle(
              color: isAvailable
                  ? const Color(0xFF16751F)
                  : const Color(0xFF58655B),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD5E4D5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F6B2F).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF16751F),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _SoftIcon extends StatelessWidget {
  const _SoftIcon({required this.icon, this.size = 58});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFE5F4E6),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Color(0xFF16751F), size: size * 0.48),
    );
  }
}

class _SoftSquareIcon extends StatelessWidget {
  const _SoftSquareIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F6B2F).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, color: const Color(0xFF16751F), size: 24),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SectionTitle(title)),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF16751F),
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: const TextStyle(fontSize: 12),
          ),
          child: Text("$actionLabel >"),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF1B6F2A),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.stats});

  final List<_DashboardStat> stats;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 620 ? 4 : 2;

        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: columns == 4 ? 1.22 : 1.6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: stats,
        );
      },
    );
  }
}

class _DashboardStat extends StatelessWidget {
  const _DashboardStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.detail,
    required this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final String detail;
  final VoidCallback onTap;

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

class _ConsultationsCard extends StatelessWidget {
  const _ConsultationsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD5E4D5)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F6B2F).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            children[index],
            if (index != children.length - 1)
              const Divider(height: 1, thickness: 1, color: Color(0xFFE3EFE1)),
          ],
        ],
      ),
    );
  }
}

class _PatientTile extends StatelessWidget {
  const _PatientTile({
    required this.initials,
    required this.name,
    required this.detail,
    required this.onTap,
    required this.onButtonPressed,
    this.isActive = false,
  });

  final String initials;
  final String name;
  final String detail;
  final VoidCallback onTap;
  final VoidCallback onButtonPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? const Color(0xFFF7FCF7) : Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFDDF6DD),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Color(0xFF4F9B47),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
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
                      detail,
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
              const SizedBox(width: 10),
              if (isActive)
                _SolidActionButton(
                  label: "Open Consultation",
                  onPressed: onButtonPressed,
                )
              else
                _OutlineActionButton(
                  label: "View Record",
                  borderColor: const Color(0xFF16751F),
                  textColor: const Color(0xFF16751F),
                  onPressed: onButtonPressed,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({required this.actions});

  final List<_DashboardAction> actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 620 ? 4 : 2;
        final spacing = columns == 4 ? 12.0 : 10.0;
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
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

class _CurrentQueueCard extends StatelessWidget {
  const _CurrentQueueCard();

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _QueueMiniRow(number: "#9", name: "Juan Dela Cruz"),
          const SizedBox(height: 8),
          const _QueueMiniRow(number: "#10", name: "Maria Santos"),
          const SizedBox(height: 8),
          const _QueueMiniRow(number: "#11", name: "Pedro Reyes"),
        ],
      ),
    );
  }
}

class _AppointmentRequestsCard extends StatelessWidget {
  const _AppointmentRequestsCard();

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const _SoftIcon(icon: Icons.event_available, size: 64),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "3",
                  style: TextStyle(
                    color: Color(0xFF16751F),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Pending Requests",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xFF263A2B), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueMiniRow extends StatelessWidget {
  const _QueueMiniRow({required this.number, required this.name});

  final String number;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF3EA),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Color(0xFF5F6F63),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF263A2B), fontSize: 14),
          ),
        ),
      ],
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
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

class _CompactButton extends StatelessWidget {
  const _CompactButton({
    required this.label,
    required this.onPressed,
    required this.filled,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: filled ? 156 : 136,
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: filled ? const Color(0xFF16751F) : Colors.white,
          foregroundColor: const Color(0xFF16751F),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: filled ? const Color(0xFF16751F) : const Color(0xFF6CB978),
            ),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              color: filled ? Colors.white : const Color(0xFF16751F),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
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
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.iconColor = const Color(0xFF16751F),
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;
}
