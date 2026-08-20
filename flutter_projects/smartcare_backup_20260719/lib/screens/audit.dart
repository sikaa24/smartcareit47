import 'package:flutter/material.dart';
import '../widgets/smartcare_bottom_nav.dart';
import '../widgets/smartcare_dashboard_header.dart';

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<_AuditLog> _logs = [
    _AuditLog(
      dateTime: '2026-06-24 13:56:09',
      username: 'anyepogi123',
      description: 'Logged in successfully.',
      role: 'doctor',
    ),
    _AuditLog(
      dateTime: '2026-06-23 14:41:46',
      username: 'anyepogi123',
      description: 'Logged in successfully.',
      role: 'doctor',
    ),
    _AuditLog(
      dateTime: '2026-06-11 12:43:09',
      username: 'anyepogi123',
      description: 'Logged in successfully.',
      role: 'secretary',
    ),
    _AuditLog(
      dateTime: '2026-06-09 15:11:06',
      username: 'anyepogi123',
      description: 'Logged in successfully.',
      role: 'secretary',
    ),
    _AuditLog(
      dateTime: '2025-12-11 18:43:47',
      username: 'sika',
      description: 'Logged in successfully.',
      role: 'patient',
    ),
    _AuditLog(
      dateTime: '2025-12-09 01:02:40',
      username: 'sika',
      description: 'Successfully updated medical information',
      role: 'patient',
    ),
    _AuditLog(
      dateTime: '2025-12-09 01:02:21',
      username: 'sika',
      description: 'Successfully updated health records',
      role: 'patient',
    ),
    _AuditLog(
      dateTime: '2025-12-09 01:02:21',
      username: 'sika',
      description: 'Updated health records',
      role: 'patient',
    ),
    _AuditLog(
      dateTime: '2025-12-09 00:59:36',
      username: 'sika',
      description: 'Updated personal information',
      role: 'patient',
    ),
    _AuditLog(
      dateTime: '2025-12-09 00:56:35',
      username: 'sika',
      description: 'Logged in successfully.',
      role: 'patient',
    ),
    _AuditLog(
      dateTime: '2025-12-07 06:45:23',
      username: 'anyepogi123',
      description:
          'Admin Approved application of Mark Daniel Felizardo (felizardo886@gmail.com)',
      role: 'doctor',
    ),
  ];

  List<_AuditLog> _filteredLogs = [];

  @override
  void initState() {
    super.initState();
    _filteredLogs = _logs;
    _searchController.addListener(_filterLogs);
  }

  void _filterLogs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredLogs = _logs;
      } else {
        _filteredLogs = _logs
            .where(
              (log) =>
                  log.username.toLowerCase().contains(query) ||
                  log.description.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBF5),
      bottomNavigationBar: const SmartCareBottomNav(
        currentItem: SmartCareBottomItem.profile,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SmartCareDashboardHeader(
                title: "Audit Logs",
                subtitle: "View system activity and audit trail.",
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 26),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Search Bar
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search logs...',
                            hintStyle: const TextStyle(
                              color: Color(0xFFBBBBBB),
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xFF6E8D73),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF006837),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFAFAFA),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Audit Logs Table
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE3EFE1),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x0A000000),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: IntrinsicWidth(
                              child: Column(
                                children: [
                                  DataTable(
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                          (states) => const Color(0xFFF6FBF5),
                                        ),
                                    headingRowHeight: 56,
                                    dataRowHeight: 70,
                                    columnSpacing: 20,
                                    headingTextStyle: const TextStyle(
                                      color: Color(0xFF1A3320),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    columns: const [
                                      DataColumn(label: Text('Date & Time')),
                                      DataColumn(label: Text('Username')),
                                      DataColumn(label: Text('Description')),
                                      DataColumn(label: Text('Role')),
                                    ],
                                    rows: _filteredLogs
                                        .map(
                                          (log) => DataRow(
                                            cells: [
                                              DataCell(
                                                Text(
                                                  log.dateTime,
                                                  style: const TextStyle(
                                                    color: Color(0xFF1A3320),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  log.username,
                                                  style: const TextStyle(
                                                    color: Color(0xFF1A3320),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                        maxWidth: 250,
                                                      ),
                                                  child: Text(
                                                    log.description,
                                                    style: const TextStyle(
                                                      color: Color(0xFF1A3320),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  log.role,
                                                  style: const TextStyle(
                                                    color: Color(0xFF1A3320),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Center(
                                      child: Container(
                                        width: 40,
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD0D7D0),
                                          borderRadius: BorderRadius.circular(
                                            2,
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
                        if (_filteredLogs.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 48,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No logs found',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}

class _AuditLog {
  final String dateTime;
  final String username;
  final String description;
  final String role;

  _AuditLog({
    required this.dateTime,
    required this.username,
    required this.description,
    required this.role,
  });
}
