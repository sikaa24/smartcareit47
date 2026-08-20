import 'package:flutter/material.dart';
import 'state/app_session.dart';
import 'widgets/smartcare_bottom_nav.dart';
import 'widgets/smartcare_dashboard_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  bool _personalInfoExpanded = true;
  bool _medicalInfoExpanded = true;
  bool _settingsExpanded = false;
  late Map<String, String> _editedPersonalInfo;
  late Map<String, String> _editedMedicalInfo;

  @override
  void initState() {
    super.initState();
    _editedPersonalInfo = {};
    _editedMedicalInfo = {};
  }

  void _initializeEditMode() {
    _editedPersonalInfo = Map.from(
      SmartCareSession.personalInfo.cast<String, String>(),
    );
    _editedMedicalInfo = Map.from(
      SmartCareSession.medicalInfo.cast<String, String>(),
    );
  }

  void _saveChanges() {
    SmartCareSession.personalInfo.addAll(_editedPersonalInfo);
    SmartCareSession.medicalInfo.addAll(_editedMedicalInfo);
    _editedPersonalInfo.clear();
    _editedMedicalInfo.clear();
  }

  void _cancelChanges() {
    _editedPersonalInfo.clear();
    _editedMedicalInfo.clear();
  }

  String _getDisplayValue(String key, bool isPersonal) {
    if (isPersonal) {
      return _editedPersonalInfo[key] ??
          SmartCareSession.personalInfo[key] ??
          '';
    } else {
      return _editedMedicalInfo[key] ?? SmartCareSession.medicalInfo[key] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = SmartCareSession.currentRole;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F2E4),
      bottomNavigationBar: const SmartCareBottomNav(
        currentItem: SmartCareBottomItem.profile,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 380 ? 12.0 : 16.0;

            return ListView(
              children: [
                SmartCareDashboardHeader(
                  title: role == UserRole.patient
                      ? "Patient Profile"
                      : "Staff Profile",
                  subtitle: role == UserRole.patient
                      ? "View and manage your personal healthcare information."
                      : "View and manage your SmartCare staff information.",
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    14,
                    horizontalPadding,
                    22,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Header with Avatar and Info
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFB7D7B8),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Avatar
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD4E8D4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      role.displayName
                                          .split(' ')
                                          .map((e) => e[0])
                                          .join(),
                                      style: const TextStyle(
                                        color: Color(0xFF0F6B2F),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Name and ID
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        role.displayName.toUpperCase(),
                                        style: const TextStyle(
                                          color: Color(0xFF0F6B2F),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        role.profileDetail,
                                        style: const TextStyle(
                                          color: Color(0xFF0F6B2F),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Personal Information Section
                          _ExpandableSection(
                            title: 'Personal Information',
                            isExpanded: _personalInfoExpanded,
                            onExpanded: (value) {
                              setState(() => _personalInfoExpanded = value);
                            },
                            children: [
                              _ProfileInfoField(
                                icon: Icons.person,
                                label: 'Full Name',
                                value: _getDisplayValue('Full Name', true),
                                isEditing: _isEditing,
                                onChanged: (value) => setState(
                                  () =>
                                      _editedPersonalInfo['Full Name'] = value,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _ProfileInfoField(
                                icon: Icons.calendar_today,
                                label: 'Date of Birth',
                                value: _getDisplayValue('Date of Birth', true),
                                isEditing: _isEditing,
                                onChanged: (value) => setState(
                                  () => _editedPersonalInfo['Date of Birth'] =
                                      value,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _ProfileInfoField(
                                icon: Icons.wc,
                                label: 'Gender',
                                value: _getDisplayValue('Gender', true),
                                isEditing: _isEditing,
                                onChanged: (value) => setState(
                                  () => _editedPersonalInfo['Gender'] = value,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _ProfileInfoField(
                                icon: Icons.email,
                                label: 'Email',
                                value: _getDisplayValue('Email', true),
                                isEditing: _isEditing,
                                onChanged: (value) => setState(
                                  () => _editedPersonalInfo['Email'] = value,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _ProfileInfoField(
                                icon: Icons.phone,
                                label: 'Phone Number',
                                value: _getDisplayValue('Phone', true),
                                isEditing: _isEditing,
                                onChanged: (value) => setState(
                                  () => _editedPersonalInfo['Phone'] = value,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _ProfileInfoField(
                                icon: Icons.location_on,
                                label: 'Address',
                                value: _getDisplayValue('Address', true),
                                isEditing: _isEditing,
                                onChanged: (value) => setState(
                                  () => _editedPersonalInfo['Address'] = value,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _ProfileInfoField(
                                icon: Icons.favorite,
                                label: 'Civil Status',
                                value: _getDisplayValue('Civil Status', true),
                                isEditing: _isEditing,
                                onChanged: (value) => setState(
                                  () => _editedPersonalInfo['Civil Status'] =
                                      value,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _ProfileInfoField(
                                icon: Icons.work,
                                label: 'Occupation',
                                value: _getDisplayValue('Occupation', true),
                                isEditing: _isEditing,
                                onChanged: (value) => setState(
                                  () =>
                                      _editedPersonalInfo['Occupation'] = value,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _ProfileInfoField(
                                icon: Icons.person,
                                label: 'Emergency Contact',
                                value: _getDisplayValue(
                                  'Emergency Contact',
                                  true,
                                ),
                                isEditing: _isEditing,
                                onChanged: (value) => setState(
                                  () =>
                                      _editedPersonalInfo['Emergency Contact'] =
                                          value,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Medical Information Section
                          _ExpandableSection(
                            title: 'Medical Information',
                            isExpanded: _medicalInfoExpanded,
                            onExpanded: (value) {
                              setState(() => _medicalInfoExpanded = value);
                            },
                            children: [
                              _ProfileInfoField(
                                icon: Icons.medical_information,
                                label: 'Medical Condition',
                                value: _getDisplayValue(
                                  'Medical Condition',
                                  false,
                                ),
                                isEditing: _isEditing,
                                onChanged: (value) => setState(
                                  () =>
                                      _editedMedicalInfo['Medical Condition'] =
                                          value,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _ProfileInfoField(
                                icon: Icons.warning_rounded,
                                label: 'Allergies',
                                value: _getDisplayValue('Allergies', false),
                                isEditing: _isEditing,
                                onChanged: (value) => setState(
                                  () => _editedMedicalInfo['Allergies'] = value,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _ProfileInfoField(
                                icon: Icons.bloodtype,
                                label: 'Blood Type',
                                value: _getDisplayValue('Blood Type', false),
                                isEditing: _isEditing,
                                onChanged: (value) => setState(
                                  () =>
                                      _editedMedicalInfo['Blood Type'] = value,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _ProfileInfoField(
                                icon: Icons.medication,
                                label: 'Current Medication',
                                value: _getDisplayValue(
                                  'Current Medication',
                                  false,
                                ),
                                isEditing: _isEditing,
                                onChanged: (value) => setState(
                                  () =>
                                      _editedMedicalInfo['Current Medication'] =
                                          value,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _ProfileInfoField(
                                icon: Icons.description,
                                label: 'Insurance Details',
                                value: _getDisplayValue(
                                  'Insurance Details',
                                  false,
                                ),
                                isEditing: _isEditing,
                                onChanged: (value) => setState(
                                  () =>
                                      _editedMedicalInfo['Insurance Details'] =
                                          value,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Settings Section
                          _ExpandableSection(
                            title: 'Settings',
                            isExpanded: _settingsExpanded,
                            onExpanded: (value) {
                              setState(() => _settingsExpanded = value);
                            },
                            children: [
                              _SettingsTile(
                                icon: Icons.lock_rounded,
                                title: 'Privacy and Security',
                              ),
                              const SizedBox(height: 8),
                              _SettingsTile(
                                icon: Icons.notifications,
                                title: 'Notification Settings',
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Edit/Save Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (_isEditing) {
                                  _saveChanges();
                                }
                                setState(() {
                                  _isEditing = !_isEditing;
                                  if (_isEditing) {
                                    _personalInfoExpanded = true;
                                    _medicalInfoExpanded = true;
                                    _initializeEditMode();
                                  }
                                });
                              },
                              icon: Icon(
                                _isEditing
                                    ? Icons.save_rounded
                                    : Icons.edit_rounded,
                                size: 20,
                              ),
                              label: Text(
                                _isEditing ? 'Save Changes' : 'Edit Profile',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF006B2D),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                          if (_isEditing) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _cancelChanges();
                                  setState(() => _isEditing = false);
                                },
                                icon: const Icon(Icons.close_rounded),
                                label: const Text('Cancel'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF006B2D),
                                  side: const BorderSide(
                                    color: Color(0xFF006B2D),
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
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

class _ExpandableSection extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final ValueChanged<bool> onExpanded;
  final List<Widget> children;

  const _ExpandableSection({
    required this.title,
    required this.isExpanded,
    required this.onExpanded,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB7D7B8)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => onExpanded(!isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.person, color: const Color(0xFF006B2D), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF006B2D),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF006B2D),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFB7D7B8)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: children),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileInfoField extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isEditing;
  final ValueChanged<String>? onChanged;

  const _ProfileInfoField({
    required this.icon,
    required this.label,
    required this.value,
    required this.isEditing,
    this.onChanged,
  });

  @override
  State<_ProfileInfoField> createState() => _ProfileInfoFieldState();
}

class _ProfileInfoFieldState extends State<_ProfileInfoField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_ProfileInfoField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !widget.isEditing) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.isEditing
              ? const Color(0xFF006B2D)
              : const Color(0xFFE0E0E0),
          width: widget.isEditing ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(widget.icon, color: const Color(0xFF006B2D), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: widget.isEditing
                ? TextField(
                    controller: _controller,
                    onChanged: widget.onChanged,
                    style: const TextStyle(
                      color: Color(0xFF006B2D),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.label,
                      labelStyle: const TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: const TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.value.isEmpty ? 'Not provided' : widget.value,
                        style: const TextStyle(
                          color: Color(0xFF006B2D),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SettingsTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF006B2D), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF006B2D),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF006B2D),
            size: 14,
          ),
        ],
      ),
    );
  }
}
