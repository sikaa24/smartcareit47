import 'package:flutter/material.dart';
import '../state/app_session.dart';
import '../widgets/smartcare_bottom_nav.dart';
import '../widgets/smartcare_dashboard_header.dart';

class SecretaryPanelScreen extends StatefulWidget {
  const SecretaryPanelScreen({super.key});

  @override
  State<SecretaryPanelScreen> createState() => _SecretaryPanelScreenState();
}

class _SecretaryPanelScreenState extends State<SecretaryPanelScreen> {
  final List<_AppointmentRequest> _requests = [
    const _AppointmentRequest(
      id: "maria-santos",
      initials: "MS",
      name: "Maria Santos",
      time: "9:00 AM",
      status: _RequestStatus.pending,
    ),
    const _AppointmentRequest(
      id: "mark-felizardo",
      initials: "MF",
      name: "Mark Felizardo",
      time: "9:15 AM",
      status: _RequestStatus.approved,
    ),
    const _AppointmentRequest(
      id: "john-miguelito",
      initials: "JM",
      name: "John Miguelito",
      time: "9:30 AM",
      status: _RequestStatus.approved,
    ),
    const _AppointmentRequest(
      id: "sean-strickland",
      initials: "SS",
      name: "Sean Strickland",
      time: "10:00 AM",
      status: _RequestStatus.cancelled,
    ),
  ];

  final List<_DoctorAvailability> _doctors = [
    const _DoctorAvailability(
      initials: "KI",
      name: "Dr. Kalabaw ng Isabela",
      status: "In Clinic",
      isAvailable: true,
    ),
    const _DoctorAvailability(
      initials: "JM",
      name: "Dr. Jeric Magtibay",
      status: "Out/Unavailable",
      isAvailable: false,
    ),
  ];

  final List<_PatientRecord> _records = [
    const _PatientRecord(
      id: "maria-santos",
      initials: "MS",
      name: "Maria Santos",
      lastVisit: "May 12, 2026",
      status: "Needs update",
    ),
    const _PatientRecord(
      id: "mark-felizardo",
      initials: "MF",
      name: "Mark Felizardo",
      lastVisit: "May 14, 2026",
      status: "Updated",
    ),
  ];

  String _selectedRequestId = "john-miguelito";
  String _selectedRecordId = "maria-santos";
  int _walkInNumber = 1;
  int _notificationsSent = 0;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    if (!SmartCareSession.currentRole.canSwitchStaffRole) {
      SmartCareSession.switchRole(UserRole.secretary);
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Date selected: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
          ),
        ),
      );
    }
  }

  void _selectRequest(_AppointmentRequest request) {
    setState(() {
      _selectedRequestId = request.id;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${request.name}'s request selected.")),
    );
  }

  void _viewQueue(_AppointmentRequest request) {
    setState(() {
      _selectedRequestId = request.id;
    });

    smartCareGoTo(context, '/queue');
  }

  void _approveRequest(_AppointmentRequest request) {
    _replaceRequest(request.copyWith(status: _RequestStatus.approved));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${request.name}'s appointment approved.")),
    );
  }

  void _rescheduleRequest(_AppointmentRequest request) {
    final updatedRequest = request.copyWith(
      time: _nextAppointmentTime(request.time),
      status: _RequestStatus.rescheduled,
    );

    _replaceRequest(updatedRequest);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${request.name}'s appointment rescheduled to ${updatedRequest.time}.",
        ),
      ),
    );
  }

  void _cancelRequest(_AppointmentRequest request) {
    _replaceRequest(request.copyWith(status: _RequestStatus.cancelled));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${request.name}'s appointment cancelled.")),
    );
  }

  void _replaceRequest(_AppointmentRequest updatedRequest) {
    setState(() {
      final index = _requests.indexWhere(
        (item) => item.id == updatedRequest.id,
      );
      if (index == -1) {
        return;
      }
      _requests[index] = updatedRequest;
      _selectedRequestId = updatedRequest.id;
    });
  }

  void _inputWalkInPatient() {
    final walkInNumber = _walkInNumber;
    final request = _AppointmentRequest(
      id: "walk-in-$walkInNumber",
      initials: "WI",
      name: "Walk-in Patient $walkInNumber",
      time: "Walk-in",
      status: _RequestStatus.pending,
    );

    setState(() {
      _walkInNumber += 1;
      _requests.insert(0, request);
      _selectedRequestId = request.id;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Walk-in patient saved to database.")),
    );
  }

  void _showStatus(_AppointmentRequest request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${request.name} is ${request.status.label}.")),
    );
  }

  void _viewPatientRecord(_PatientRecord record) {
    setState(() {
      _selectedRecordId = record.id;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Viewing ${record.name}'s patient record.")),
    );
  }

  void _updatePatientRecord(_PatientRecord record) {
    setState(() {
      final index = _records.indexWhere((item) => item.id == record.id);
      if (index == -1) {
        return;
      }

      _records[index] = record.copyWith(
        lastVisit: "Updated today",
        status: "Saved",
      );
      _selectedRecordId = record.id;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${record.name}'s record saved to database.")),
    );
  }

  void _sendAppointmentNotifications() {
    final readyRequests = _requests
        .where(
          (request) =>
              request.status == _RequestStatus.approved ||
              request.status == _RequestStatus.rescheduled,
        )
        .length;

    setState(() {
      _notificationsSent = readyRequests;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          readyRequests == 0
              ? "No approved appointments ready for notification."
              : "$readyRequests appointment notifications sent.",
        ),
      ),
    );
  }

  void _viewDoctorAvailability(_DoctorAvailability doctor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${doctor.name}: ${doctor.status}.")),
    );
  }

  void _checkGeofenceAlerts(_DoctorAvailability doctor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          doctor.isAvailable
              ? "${doctor.name} is inside the clinic geofence."
              : "${doctor.name} is outside the clinic geofence.",
        ),
      ),
    );
  }

  void _toggleDoctorAvailability(int index) {
    final doctor = _doctors[index];
    final isAvailable = !doctor.isAvailable;

    setState(() {
      _doctors[index] = doctor.copyWith(
        status: isAvailable ? "In Clinic" : "Out/Unavailable",
        isAvailable: isAvailable,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${doctor.name} marked ${isAvailable ? "in clinic" : "unavailable"}.",
        ),
      ),
    );
  }

  String _nextAppointmentTime(String currentTime) {
    const fallbackTime = "11:00 AM";
    final hourMatch = RegExp(
      r'^(\d+):(\d+)\s*(AM|PM)$',
    ).firstMatch(currentTime);

    if (hourMatch == null) {
      return fallbackTime;
    }

    final hour = int.parse(hourMatch.group(1)!);
    final minute = hourMatch.group(2)!;
    final period = hourMatch.group(3)!;
    final nextHour = hour == 12 ? 1 : hour + 1;

    return "$nextHour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8E6),
      bottomNavigationBar: const SmartCareBottomNav(
        currentItem: SmartCareBottomItem.geofence,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const _SecretaryHeader(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F8E6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final horizontalPadding = constraints.maxWidth < 380
                        ? 8.0
                        : 16.0;

                    return ListView(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        16,
                        horizontalPadding,
                        26,
                      ),
                      children: [
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 680),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                                      color:
                                                          Colors.green.shade700,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                                                    style: const TextStyle(
                                                      color: Color(0xFF1A3320),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                const _SectionTitle("Appointment Requests"),
                                const SizedBox(height: 12),
                                ..._requests.map(
                                  (request) => _AppointmentRequestCard(
                                    request: request,
                                    isSelected:
                                        request.id == _selectedRequestId,
                                    onTap: () => _selectRequest(request),
                                    onApprove: () => _approveRequest(request),
                                    onReschedule: () =>
                                        _rescheduleRequest(request),
                                    onCancel: () => _cancelRequest(request),
                                    onViewQueue: () => _viewQueue(request),
                                    onStatusTap: () => _showStatus(request),
                                  ),
                                ),
                                _PanelActionButton(
                                  label: "Input Walk-in Patient",
                                  color: const Color(0xFF0F6B2F),
                                  textColor: Colors.white,
                                  onPressed: _inputWalkInPatient,
                                ),
                                const Divider(
                                  height: 28,
                                  color: Color(0xFF4F8A55),
                                ),
                                const _SectionTitle("Patient Records"),
                                const SizedBox(height: 12),
                                ..._records.map(
                                  (record) => _PatientRecordCard(
                                    record: record,
                                    isSelected: record.id == _selectedRecordId,
                                    onView: () => _viewPatientRecord(record),
                                    onUpdate: () =>
                                        _updatePatientRecord(record),
                                  ),
                                ),
                                const Divider(
                                  height: 28,
                                  color: Color(0xFF4F8A55),
                                ),
                                const _SectionTitle(
                                  "Appointment Notifications",
                                ),
                                const SizedBox(height: 12),
                                _NotificationActionCard(
                                  sentCount: _notificationsSent,
                                  onSend: _sendAppointmentNotifications,
                                ),
                                const Divider(
                                  height: 28,
                                  color: Color(0xFF4F8A55),
                                ),
                                const _SectionTitle("Doctor Availability"),
                                const SizedBox(height: 12),
                                ..._doctors.asMap().entries.map(
                                  (entry) => _DoctorAvailabilityCard(
                                    doctor: entry.value,
                                    onTap: () =>
                                        _toggleDoctorAvailability(entry.key),
                                    onViewAvailability: () =>
                                        _viewDoctorAvailability(entry.value),
                                    onCheckGeofence: () =>
                                        _checkGeofenceAlerts(entry.value),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecretaryHeader extends StatelessWidget {
  const _SecretaryHeader();

  @override
  Widget build(BuildContext context) {
    return const SmartCareDashboardHeader(
      title: "Clinic Management",
      subtitle:
          "Efficiently manage patient information, appointments, and daily healthcare operations.",
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

class _AppointmentRequestCard extends StatelessWidget {
  const _AppointmentRequestCard({
    required this.request,
    required this.isSelected,
    required this.onTap,
    required this.onApprove,
    required this.onReschedule,
    required this.onCancel,
    required this.onViewQueue,
    required this.onStatusTap,
  });

  final _AppointmentRequest request;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onApprove;
  final VoidCallback onReschedule;
  final VoidCallback onCancel;
  final VoidCallback onViewQueue;
  final VoidCallback onStatusTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF0798FF)
                    : const Color(0xFF4F8A55),
                width: isSelected ? 3 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InitialsAvatar(initials: request.initials),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF16751F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  request.time,
                                  style: const TextStyle(
                                    color: Color(0xFF16751F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          _StatusPill(
                            status: request.status,
                            onTap: onStatusTap,
                          ),
                        ],
                      ),
                      if (request.status != _RequestStatus.cancelled) ...[
                        const SizedBox(height: 18),
                        _ResponsiveButtonWrap(
                          actions: [
                            if (request.status == _RequestStatus.pending)
                              _PanelButtonAction(
                                label: "Approve",
                                color: const Color(0xFF0F6B2F),
                                textColor: Colors.white,
                                onPressed: onApprove,
                              )
                            else
                              _PanelButtonAction(
                                label: "View Queue",
                                color: const Color(0xFF0F6B2F),
                                textColor: Colors.white,
                                onPressed: onViewQueue,
                              ),
                            _PanelButtonAction(
                              label: "Reschedule",
                              color: const Color(0xFFA4D98D),
                              textColor: const Color(0xFF16751F),
                              onPressed: onReschedule,
                            ),
                            _PanelButtonAction(
                              label: "Cancel",
                              color: const Color(0xFFE6F8E6),
                              textColor: const Color(0xFF16751F),
                              onPressed: onCancel,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PatientRecordCard extends StatelessWidget {
  const _PatientRecordCard({
    required this.record,
    required this.isSelected,
    required this.onView,
    required this.onUpdate,
  });

  final _PatientRecord record;
  final bool isSelected;
  final VoidCallback onView;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onView,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF0798FF)
                    : const Color(0xFF4F8A55),
                width: isSelected ? 3 : 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _InitialsAvatar(initials: record.initials),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF16751F),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            record.lastVisit,
                            style: const TextStyle(
                              color: Color(0xFF16751F),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    _RecordStatusPill(status: record.status),
                  ],
                ),
                const SizedBox(height: 14),
                _ResponsiveButtonWrap(
                  actions: [
                    _PanelButtonAction(
                      label: "View Record",
                      color: const Color(0xFF0F6B2F),
                      textColor: Colors.white,
                      onPressed: onView,
                    ),
                    _PanelButtonAction(
                      label: "Update Record",
                      color: const Color(0xFFA4D98D),
                      textColor: const Color(0xFF16751F),
                      onPressed: onUpdate,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationActionCard extends StatelessWidget {
  const _NotificationActionCard({
    required this.sentCount,
    required this.onSend,
  });

  final int sentCount;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF4F8A55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sentCount == 0
                ? "No appointment notifications sent yet."
                : "$sentCount appointment notifications sent.",
            style: const TextStyle(
              color: Color(0xFF16751F),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _PanelActionButton(
            label: "Send Appointment Notifications",
            color: const Color(0xFF0F6B2F),
            textColor: Colors.white,
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}

class _DoctorAvailabilityCard extends StatelessWidget {
  const _DoctorAvailabilityCard({
    required this.doctor,
    required this.onTap,
    required this.onViewAvailability,
    required this.onCheckGeofence,
  });

  final _DoctorAvailability doctor;
  final VoidCallback onTap;
  final VoidCallback onViewAvailability;
  final VoidCallback onCheckGeofence;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF4F8A55)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _InitialsAvatar(initials: doctor.initials),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF16751F),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doctor.status,
                            style: const TextStyle(
                              color: Color(0xFF16751F),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: doctor.isAvailable
                          ? const Color(0xFF16751F)
                          : Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _ResponsiveButtonWrap(
                  actions: [
                    _PanelButtonAction(
                      label: "View Availability",
                      color: const Color(0xFF0F6B2F),
                      textColor: Colors.white,
                      onPressed: onViewAvailability,
                    ),
                    _PanelButtonAction(
                      label: "Check Geofence",
                      color: const Color(0xFFA4D98D),
                      textColor: const Color(0xFF16751F),
                      onPressed: onCheckGeofence,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: const Color(0xFFD3F0D1),
      child: Text(
        initials,
        style: const TextStyle(
          color: Color(0xFF4F9B47),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.onTap});

  final _RequestStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isPending = status == _RequestStatus.pending;
    final backgroundColor = switch (status) {
      _RequestStatus.pending => Colors.white,
      _RequestStatus.approved => const Color(0xFF16751F),
      _RequestStatus.rescheduled => const Color(0xFFA4D98D),
      _RequestStatus.cancelled => const Color(0xFFE6F8E6),
    };
    final textColor = switch (status) {
      _RequestStatus.pending => const Color(0xFF16751F),
      _RequestStatus.approved => Colors.white,
      _RequestStatus.rescheduled => const Color(0xFF16751F),
      _RequestStatus.cancelled => const Color(0xFF16751F),
    };

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 88,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: isPending
              ? Border.all(color: const Color(0xFF16751F))
              : Border.all(color: backgroundColor),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            status.label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _RecordStatusPill extends StatelessWidget {
  const _RecordStatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isSaved = status == "Saved" || status == "Updated";

    return Container(
      width: 96,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSaved ? const Color(0xFF16751F) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF16751F)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          status,
          style: TextStyle(
            color: isSaved ? Colors.white : const Color(0xFF16751F),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ResponsiveButtonWrap extends StatelessWidget {
  const _ResponsiveButtonWrap({required this.actions});

  final List<_PanelButtonAction> actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 360 ? actions.length : 2;
        final spacing = columns > 1 ? 10.0 : 0.0;
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 10,
          children: actions.map((action) {
            return SizedBox(
              width: itemWidth,
              child: _SmallActionButton(
                label: action.label,
                color: action.color,
                textColor: action.textColor,
                onPressed: action.onPressed,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _PanelActionButton extends StatelessWidget {
  const _PanelActionButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 38),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class _PanelButtonAction {
  const _PanelButtonAction({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
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

class _AppointmentRequest {
  const _AppointmentRequest({
    required this.id,
    required this.initials,
    required this.name,
    required this.time,
    required this.status,
  });

  final String id;
  final String initials;
  final String name;
  final String time;
  final _RequestStatus status;

  _AppointmentRequest copyWith({String? time, _RequestStatus? status}) {
    return _AppointmentRequest(
      id: id,
      initials: initials,
      name: name,
      time: time ?? this.time,
      status: status ?? this.status,
    );
  }
}

class _DoctorAvailability {
  const _DoctorAvailability({
    required this.initials,
    required this.name,
    required this.status,
    required this.isAvailable,
  });

  final String initials;
  final String name;
  final String status;
  final bool isAvailable;

  _DoctorAvailability copyWith({String? status, bool? isAvailable}) {
    return _DoctorAvailability(
      initials: initials,
      name: name,
      status: status ?? this.status,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

class _PatientRecord {
  const _PatientRecord({
    required this.id,
    required this.initials,
    required this.name,
    required this.lastVisit,
    required this.status,
  });

  final String id;
  final String initials;
  final String name;
  final String lastVisit;
  final String status;

  _PatientRecord copyWith({String? lastVisit, String? status}) {
    return _PatientRecord(
      id: id,
      initials: initials,
      name: name,
      lastVisit: lastVisit ?? this.lastVisit,
      status: status ?? this.status,
    );
  }
}

enum _RequestStatus {
  pending("Pending"),
  approved("Approved"),
  rescheduled("Rescheduled"),
  cancelled("Cancelled");

  const _RequestStatus(this.label);

  final String label;
}
