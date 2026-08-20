import 'package:flutter/material.dart';

import '../widgets/smartcare_bottom_nav.dart';
import '../widgets/smartcare_dashboard_header.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F2E4),
      bottomNavigationBar: const SmartCareBottomNav(
        currentItem: SmartCareBottomItem.menu,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const _ResultsHeader(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: const [
                  _ResultsSummaryCard(),
                  SizedBox(height: 14),
                  _ResultTile(
                    title: 'Complete Blood Count',
                    doctor: 'Dr. Bonifacio',
                    date: 'June 10, 2026',
                    status: 'Pending',
                    icon: Icons.biotech,
                    color: Color(0xFFF9A825),
                  ),
                  _ResultTile(
                    title: 'Chest X-ray',
                    doctor: 'Dra. Valencia',
                    date: 'June 8, 2026',
                    status: 'Pending',
                    icon: Icons.monitor_heart,
                    color: Color(0xFFF9A825),
                  ),
                  _ResultTile(
                    title: 'Urinalysis',
                    doctor: 'Dr. Arcilla',
                    date: 'June 6, 2026',
                    status: 'Pending',
                    icon: Icons.science,
                    color: Color(0xFFF9A825),
                  ),
                  _ResultTile(
                    title: 'Blood Chemistry',
                    doctor: 'Dr. R. Santos',
                    date: 'May 30, 2026',
                    status: 'Available',
                    icon: Icons.task_alt,
                    color: Color(0xFF2E7D32),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader();

  @override
  Widget build(BuildContext context) {
    return const SmartCareDashboardHeader(
      title: 'Lab Results',
      subtitle: 'Track pending and available laboratory or diagnostic results.',
    );
  }
}

class _ResultsSummaryCard extends StatelessWidget {
  const _ResultsSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.science, color: Colors.white, size: 34),
          SizedBox(width: 12),
          Text(
            '3',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Pending results',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.title,
    required this.doctor,
    required this.date,
    required this.status,
    required this.icon,
    required this.color,
  });

  final String title;
  final String doctor;
  final String date;
  final String status;
  final IconData icon;
  final Color color;

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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
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
                  ),
                ),
                Text(doctor, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _ResultPill(text: status, color: color),
        ],
      ),
    );
  }
}

class _ResultPill extends StatelessWidget {
  const _ResultPill({required this.text, required this.color});

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
