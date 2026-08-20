import 'package:flutter/material.dart';
import '../state/app_session.dart';
import '../widgets/smartcare_bottom_nav.dart'
    show SmartCareBottomNav, SmartCareBottomItem, smartCareGoTo;
import '../widgets/smartcare_dashboard_header.dart';
import 'serving.dart';

class SecretaryQueueScreen extends StatefulWidget {
  const SecretaryQueueScreen({super.key});

  @override
  State<SecretaryQueueScreen> createState() => _SecretaryQueueScreenState();
}

class _SecretaryQueueScreenState extends State<SecretaryQueueScreen> {
  bool _isCheckedIn = true;
  bool _showAllQueue = false;
  List<Map<String, String>> _walkInPatients = [];

  final List<Map<String, String>> _defaultPatients = [
    {
      'initials': 'JG',
      'name': 'Jesika Guiao',
      'time': '9:30 AM • Consultation',
      'waitTime': 'Est. wait: 10 mins',
    },
    {
      'initials': 'RO',
      'name': 'Rayne Ocampo',
      'time': '9:45 AM • Follow-up Checkup',
      'waitTime': 'Est. wait: 20 mins',
    },
    {
      'initials': 'MV',
      'name': 'Mary Rose Valencia',
      'time': '10:00 AM • BP Monitoring',
      'waitTime': 'Est. wait: 30 mins',
    },
    {
      'initials': 'LB',
      'name': 'Mark Felizardo',
      'time': '10:15 AM • Consultation',
      'waitTime': 'Est. wait: 40 mins',
    },
  ];

  final List<Map<String, String>> _allPatients = [
    {
      'initials': 'JG',
      'name': 'Jesika Guiao',
      'time': '9:30 AM • Consultation',
      'waitTime': 'Est. wait: 10 mins',
    },
    {
      'initials': 'RO',
      'name': 'Rayne Ocampo',
      'time': '9:45 AM • Follow-up Checkup',
      'waitTime': 'Est. wait: 20 mins',
    },
    {
      'initials': 'MV',
      'name': 'Mary Rose Valencia',
      'time': '10:00 AM • BP Monitoring',
      'waitTime': 'Est. wait: 30 mins',
    },
    {
      'initials': 'LB',
      'name': 'Mark Felizardo',
      'time': '10:15 AM • Consultation',
      'waitTime': 'Est. wait: 40 mins',
    },
    {
      'initials': 'CZ',
      'name': 'Carl Zita',
      'time': '10:30 AM • Consultation',
      'waitTime': 'Est. wait: 50 mins',
    },
    {
      'initials': 'JM',
      'name': 'Jeric Magtibay',
      'time': '10:45 AM • Follow-up',
      'waitTime': 'Est. wait: 60 mins',
    },
    {
      'initials': 'JR',
      'name': 'Jaz Rozas',
      'time': '11:00 AM • Consultation',
      'waitTime': 'Est. wait: 70 mins',
    },
  ];

  @override
  void initState() {
    super.initState();
    SmartCareSession.switchRole(UserRole.secretary);
  }

  void _toggleCheckIn() {
    setState(() {
      _isCheckedIn = !_isCheckedIn;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isCheckedIn ? "Checked in successfully." : "Checked out.",
        ),
      ),
    );
  }

  void _toggleShowAllQueue() {
    setState(() {
      _showAllQueue = !_showAllQueue;
    });
  }

  void _showAddWalkInDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Walk-in Patient'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Patient Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    hintText: 'Reason for Visit',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final String initials = _getInitials(nameController.text);
                  setState(() {
                    _walkInPatients.add({
                      'initials': initials,
                      'name': nameController.text,
                      'time':
                          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} • Walk-in',
                      'waitTime': 'Est. wait: 5 mins',
                    });
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${nameController.text} added as walk-in patient',
                      ),
                    ),
                  );
                  Navigator.of(context).pop();
                  nameController.clear();
                  reasonController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter patient name')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16751F),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  String _generatePatientNumber(int queuePosition) {
    final year = DateTime.now().year;
    final paddedNumber = (queuePosition + 1).toString().padLeft(3, '0');
    return 'P-$year-$paddedNumber';
  }

  String _getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';
    for (var name in names) {
      if (name.isNotEmpty) {
        initials += name[0].toUpperCase();
      }
    }
    return initials.length > 2 ? initials.substring(0, 2) : initials;
  }

  List<Widget> _buildQueueList() {
    List<Widget> children = [];
    List<Map<String, String>> displayedPatients = _showAllQueue
        ? _allPatients
        : _defaultPatients;

    // Combine all patients for the queue list
    List<Map<String, String>> allQueuePatients = [
      ..._walkInPatients,
      ...displayedPatients,
    ];

    // Add walk-in patients first
    for (int i = 0; i < _walkInPatients.length; i++) {
      final waitingList = allQueuePatients
          .where((p) => p != _walkInPatients[i])
          .toList();

      children.add(
        _QueuePatientRow(
          initials: _walkInPatients[i]['initials']!,
          name: _walkInPatients[i]['name']!,
          time: _walkInPatients[i]['time']!,
          waitTime: _walkInPatients[i]['waitTime']!,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ServingScreen(
                  patientInitials: _walkInPatients[i]['initials']!,
                  patientName: _walkInPatients[i]['name']!,
                  patientTime: _walkInPatients[i]['time']!,
                  patientWaitTime: _walkInPatients[i]['waitTime']!,
                  patientNumber: _generatePatientNumber(i),
                  waitingPatients: waitingList,
                ),
              ),
            );
          },
        ),
      );
      children.add(
        const Divider(height: 1, thickness: 1, color: Color(0xFFE3EFE1)),
      );
    }

    // Add default/all patients
    for (int i = 0; i < displayedPatients.length; i++) {
      final waitingList = allQueuePatients
          .where((p) => p != displayedPatients[i])
          .toList();

      children.add(
        _QueuePatientRow(
          initials: displayedPatients[i]['initials']!,
          name: displayedPatients[i]['name']!,
          time: displayedPatients[i]['time']!,
          waitTime: displayedPatients[i]['waitTime']!,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ServingScreen(
                  patientInitials: displayedPatients[i]['initials']!,
                  patientName: displayedPatients[i]['name']!,
                  patientTime: displayedPatients[i]['time']!,
                  patientWaitTime: displayedPatients[i]['waitTime']!,
                  patientNumber: _generatePatientNumber(
                    _walkInPatients.length + i,
                  ),
                  waitingPatients: waitingList,
                ),
              ),
            );
          },
        ),
      );
      if (i < displayedPatients.length - 1) {
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
        currentItem: SmartCareBottomItem.queue,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 380 ? 12.0 : 16.0;

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const SmartCareDashboardHeader(
                  title: "Queue Management",
                  subtitle: "Monitor queue and manage appointment flow",
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    18,
                    horizontalPadding,
                    24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Grid
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.6,
                        children: [
                          _StatCard(
                            number: "6",
                            label: "In Consultation",
                            sublabel: "Ongoing",
                            icon: Icons.person,
                          ),
                          _StatCard(
                            number: "18",
                            label: "Completed",
                            sublabel: "Today",
                            icon: Icons.check_circle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
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
                                Icon(
                                  Icons.auto_awesome,
                                  color: Color(0xFF5C28D6),
                                  size: 18,
                                ),
                                SizedBox(width: 7),
                                Text(
                                  "AI Queue Insight",
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
                                border: Border.all(
                                  color: const Color(0xFFE8DFFF),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDE3FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.auto_awesome,
                                      color: Color(0xFF5C28D6),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Peak Hours Today: 10:00 AM - 12:00 PM',
                                          style: TextStyle(
                                            color: Color(0xFF5C28D6),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'You may have up to 8 patients between these hours.',
                                          style: TextStyle(
                                            color: Color(0xFF6E8D73),
                                            fontSize: 11,
                                          ),
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
                      const SizedBox(height: 24),
                      // Queue List Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Queue List",
                            style: TextStyle(
                              color: Color(0xFF1B6F2A),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: _toggleShowAllQueue,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF16751F),
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 32),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                            child: Text(
                              _showAllQueue ? "View Less >" : "View All >",
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
                        child: Column(children: _buildQueueList()),
                      ),
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

class _QueuePatientRow extends StatelessWidget {
  const _QueuePatientRow({
    required this.initials,
    required this.name,
    required this.time,
    required this.waitTime,
    required this.onTap,
  });

  final String initials;
  final String name;
  final String time;
  final String waitTime;
  final VoidCallback onTap;

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
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Patient Info
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
                    time,
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
            // Wait Time and Action Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  waitTime,
                  style: const TextStyle(
                    color: Color(0xFF16751F),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Notifying $name...")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE0F4E0),
                    foregroundColor: const Color(0xFF16751F),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Notify',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QueueActionGrid extends StatelessWidget {
  const _QueueActionGrid({required this.actions});

  final List<_QueueAction> actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 620 ? 3 : 3;
        final spacing = 10.0;
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 10,
          children: actions.map((action) {
            return SizedBox(
              width: itemWidth,
              height: 82,
              child: _QueueActionTile(action: action),
            );
          }).toList(),
        );
      },
    );
  }
}

class _QueueActionTile extends StatelessWidget {
  const _QueueActionTile({required this.action});

  final _QueueAction action;

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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
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

class _QueueAction {
  const _QueueAction({
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.number,
    required this.label,
    required this.sublabel,
    required this.icon,
  });

  final String number;
  final String label;
  final String sublabel;
  final IconData icon;

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
                  number,
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
                  sublabel,
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
