import 'package:flutter/material.dart';

import '../state/app_session.dart';
import '../widgets/smartcare_bottom_nav.dart';
import '../widgets/smartcare_dashboard_header.dart';

class VisitHistoryScreen extends StatelessWidget {
  const VisitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = SmartCareSession.currentRole;
    final isStaff = role.canSwitchStaffRole;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F2E4),
      bottomNavigationBar: const SmartCareBottomNav(
        currentItem: SmartCareBottomItem.visits,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _DashboardDetailHeader(
                title: isStaff ? 'Patient Visit History' : 'Visit History',
                subtitle: isStaff
                    ? 'See which patients visited the clinic and where they were served.'
                    : 'Review your clinic visits and completed checkups.',
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: isStaff
                    ? const _StaffVisitHistory()
                    : const _PatientVisitHistory(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const List<String> _clinicBranches = [
  'Sta.Rita - Main Clinic',
  'Rosario, Guagua',
  'Lubao',
];

const List<_VisitRecord> _staffVisitRecords = [
  _VisitRecord(
    initials: 'MS',
    title: 'Maria Santos',
    subtitle: 'Blood pressure check and follow-up',
    clinic: 'Sta.Rita - Main Clinic',
    date: 'June 10, 2026 - 9:00 AM',
    status: 'Completed',
  ),
  _VisitRecord(
    initials: 'MF',
    title: 'Mark Felizardo',
    subtitle: 'General consultation',
    clinic: 'Rosario, Guagua',
    date: 'June 10, 2026 - 9:15 AM',
    status: 'Completed',
  ),
  _VisitRecord(
    initials: 'JM',
    title: 'John Miguelito',
    subtitle: 'Follow-up checkup',
    clinic: 'Lubao',
    date: 'June 10, 2026 - 9:30 AM',
    status: 'Completed',
  ),
  _VisitRecord(
    initials: 'AG',
    title: 'Akisej Gnulay',
    subtitle: 'BP check and follow-up',
    clinic: 'Sta.Rita - Main Clinic',
    date: 'June 9, 2026 - 10:00 AM',
    status: 'Completed',
  ),
];

const List<_VisitRecord> _patientVisitRecords = [
  _VisitRecord(
    initials: 'SR',
    title: 'Sta. Rita Clinic',
    subtitle: 'General Checkup',
    clinic: '',
    date: 'June 5, 2025 - 09:30 AM',
    status: 'Completed',
  ),
  _VisitRecord(
    initials: 'LC',
    title: 'Lubao Clinic',
    subtitle: 'Follow-up Checkup',
    clinic: '',
    date: 'May 22, 2025 - 02:15 PM',
    status: 'Completed',
  ),
  _VisitRecord(
    initials: 'GC',
    title: 'Guagua Clinic',
    subtitle: 'Consultation',
    clinic: '',
    date: 'April 28, 2025 - 10:45 AM',
    status: 'Completed',
  ),
  _VisitRecord(
    initials: 'SR',
    title: 'Sta. Rita Clinic',
    subtitle: 'Laboratory Test',
    clinic: '',
    date: 'March 18, 2025 - 11:20 AM',
    status: 'Completed',
  ),
  _VisitRecord(
    initials: 'LC',
    title: 'Lubao Clinic',
    subtitle: 'Blood Pressure Monitoring',
    clinic: '',
    date: 'February 10, 2025 - 03:00 PM',
    status: 'Completed',
  ),
];

class _StaffVisitHistory extends StatelessWidget {
  const _StaffVisitHistory();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SummaryCard(
          icon: Icons.groups,
          value: _staffVisitRecords.length.toString(),
          label: 'Patient visits across 3 clinic branches',
        ),
        const SizedBox(height: 14),
        const _SectionLabel('Clinics'),
        const SizedBox(height: 8),
        const _ClinicBranchList(),
        const SizedBox(height: 18),
        const _SectionLabel('Patients Who Visited'),
        const SizedBox(height: 10),
        ..._staffVisitRecords.map(
          (visit) => _VisitTile(
            leadingText: visit.initials,
            title: visit.title,
            subtitle: visit.subtitle,
            clinic: visit.clinic,
            date: visit.date,
            status: visit.status,
          ),
        ),
      ],
    );
  }
}

class _PatientVisitHistory extends StatelessWidget {
  const _PatientVisitHistory();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Your Visits'),
        const SizedBox(height: 10),
        ..._patientVisitRecords.map(
          (visit) => _VisitTile(
            title: visit.title,
            subtitle: visit.subtitle,
            date: visit.date,
            status: visit.status,
            useClinicIcon: true,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFB7D7B8)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.health_and_safety,
                color: const Color(0xFF0F6B2F),
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Keep your health on track!',
                      style: TextStyle(
                        color: Color(0xFF0F6B2F),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Regular checkups help you stay healthy and prevent future health issues.',
                      style: TextStyle(color: Color(0xFF4F7B55), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VisitTile extends StatelessWidget {
  const _VisitTile({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    this.clinic = '',
    this.leadingText,
    this.useClinicIcon = false,
  });

  final String title;
  final String subtitle;
  final String clinic;
  final String date;
  final String status;
  final String? leadingText;
  final bool useClinicIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB7D7B8)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: useClinicIcon
                  ? const Icon(Icons.location_city, color: Color(0xFF0F6B2F))
                  : (leadingText == null
                        ? const Icon(
                            Icons.event_available,
                            color: Color(0xFF0F6B2F),
                          )
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              leadingText!,
                              style: const TextStyle(
                                color: Color(0xFF0F6B2F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0F6B2F),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF4F7B55),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Center(
            child: _StatusPill(text: status, color: const Color(0xFF2E7D32)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF0F6B2F),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ClinicBranchList extends StatelessWidget {
  const _ClinicBranchList();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _clinicBranches
          .map((clinic) => _ClinicBranchChip(label: clinic))
          .toList(),
    );
  }
}

class _ClinicBranchChip extends StatelessWidget {
  const _ClinicBranchChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFB7D7B8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.place, color: Color(0xFF0F6B2F), size: 16),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0F6B2F),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitRecord {
  const _VisitRecord({
    required this.initials,
    required this.title,
    required this.subtitle,
    required this.clinic,
    required this.date,
    required this.status,
  });

  final String initials;
  final String title;
  final String subtitle;
  final String clinic;
  final String date;
  final String status;
}

class _DashboardDetailHeader extends StatelessWidget {
  const _DashboardDetailHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SmartCareDashboardHeader(title: title, subtitle: subtitle);
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 34),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}
