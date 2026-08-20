import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/loading_button.dart';
import '../widgets/smartcare_bottom_nav.dart';
import '../widgets/smartcare_dashboard_header.dart';
import 'check.dart';
import 'confirm.dart';

const List<String> _monthNames = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

const List<String> _shortWeekdayNames = [
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun",
];

const List<String> _longWeekdayNames = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
];

const int _visibleMonthCount = 5;

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key, this.initialDate});

  final DateTime? initialDate;

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  final List<String> slots = const [
    "8:00am - 8:30am",
    "8:30am - 9:00am",
    "9:00am - 9:30am",
    "9:30am - 10:00am",
    "10:00am - 10:30am",
    "10:30am - 11:00am",
    "11:00am - 11:30am",
    "1:00pm - 1:30pm",
    "1:30pm - 2:00pm",
    "2:00pm - 2:30pm",
    "2:30pm - 3:00pm",
    "3:00pm - 3:30pm",
  ];

  late final DateTime _today;
  late final List<_MonthOption> _months;
  late DateTime selectedDate;
  String? selectedSlot = "9:00am - 9:30am";
  bool _isBooking = false;

  final Set<String> unavailableSlots = {"10:00am - 10:30am"};

  @override
  void initState() {
    super.initState();
    _today = _dateOnly(widget.initialDate ?? DateTime.now());
    _months = _buildMonthOptions(_today);
    selectedDate = _today;
  }

  List<_DayOption> get _selectedMonthDays {
    return _buildDayOptions(
      _MonthOption(selectedDate.year, selectedDate.month),
      _today,
    );
  }

  Future<void> _confirmBooking() async {
    if (_isBooking) {
      return;
    }

    final bookedSlot = selectedSlot;
    if (bookedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a date and time slot.")),
      );
      return;
    }

    setState(() {
      _isBooking = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (!mounted) {
      return;
    }

    setState(() {
      _isBooking = false;
    });

    final appointmentDateTime = _formatScheduleDate(selectedDate);
    final fullDateTime = "$appointmentDateTime at $bookedSlot";

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AppointmentConfirmScreen(
          service: "General Consultation",
          dateTime: fullDateTime,
          patientName: "Patient",
          appointmentId:
              "APT${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
        ),
      ),
    );
  }

  String _suggestAlternativeSlot(String requestedSlot) {
    final requestedIndex = slots.indexOf(requestedSlot);
    final laterSlots = requestedIndex == -1
        ? slots
        : slots.skip(requestedIndex + 1);

    return laterSlots.firstWhere(
      (slot) => !unavailableSlots.contains(slot),
      orElse: () => slots.firstWhere(
        (slot) => !unavailableSlots.contains(slot),
        orElse: () => slots.first,
      ),
    );
  }

  void _showConfirmAppointmentDialog(String bookedSlot) {
    final appointmentLabel = _appointmentLabel(bookedSlot);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Appointment"),
          content: Text(
            "AI scheduling found an available schedule for $appointmentLabel. Confirm this appointment?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Change"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _saveAppointment(bookedSlot);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _showAlternativeScheduleDialog(
    String requestedSlot,
    String suggestedSlot,
  ) {
    final appointmentDate = _formatScheduleDate(selectedDate);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Alternative Schedule"),
          content: Text(
            "$requestedSlot on $appointmentDate is not available. AI scheduling suggests $suggestedSlot instead.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Change"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  selectedSlot = suggestedSlot;
                });
                _saveAppointment(suggestedSlot);
              },
              child: const Text("Use Suggested"),
            ),
          ],
        );
      },
    );
  }

  void _saveAppointment(String bookedSlot) {
    final appointmentLabel = _appointmentLabel(bookedSlot);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Appointment Saved"),
          content: Text(
            "Your appointment for $appointmentLabel has been saved. You will be notified about updates.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                smartCareGoTo(context, '/queue');
              },
              child: const Text("View Status"),
            ),
          ],
        );
      },
    );
  }

  void _showChangeMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Appointment type change tapped.")),
    );
  }

  String _appointmentLabel(String slot) {
    return "${_formatScheduleDate(selectedDate)} at $slot";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F2E4),
      bottomNavigationBar: const SmartCareBottomNav(
        currentItem: SmartCareBottomItem.schedule,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = constraints.maxWidth < 380
                    ? 12.0
                    : 16.0;
                final padding = horizontalPadding;
                final dense = constraints.maxHeight < 470;
                final sectionGap = dense ? 6.0 : 8.0;
                final dateGap = dense ? 6.0 : 8.0;
                final blockGap = dense ? 12.0 : 14.0;
                final cardGap = dense ? 8.0 : 8.0;
                final buttonGap = dense ? 12.0 : 14.0;
                final days = _selectedMonthDays;

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SmartCareDashboardHeader(
                      title: "Book Appointment",
                      subtitle:
                          "Easily schedule appointments by selecting a date and time slot.",
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(padding, 14, padding, 22),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _SectionLabel("Select Date"),
                              SizedBox(height: sectionGap),
                              _MonthSelector(
                                months: _months,
                                selectedDate: selectedDate,
                                onSelected: (month) {
                                  setState(() {
                                    selectedDate = _firstSelectableDateForMonth(
                                      month,
                                      _today,
                                    );
                                  });
                                },
                              ),
                              SizedBox(height: dateGap),
                              _DaySelector(
                                days: days,
                                selectedDate: selectedDate,
                                onSelected: (day) {
                                  setState(() {
                                    selectedDate = day.date;
                                  });
                                },
                              ),
                              SizedBox(height: blockGap),
                              SizedBox(height: blockGap),
                              const _SectionLabel("Select Time Slot"),
                              SizedBox(height: sectionGap),
                              _TimeSlotGrid(
                                slots: slots,
                                selectedSlot: selectedSlot,
                                onSelected: (slot) {
                                  setState(() {
                                    selectedSlot = slot;
                                  });
                                },
                              ),
                              SizedBox(height: blockGap),
                              SizedBox(
                                width: double.infinity,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 48,
                                  ),
                                  child: LoadingButton(
                                    isLoading: _isBooking,
                                    onPressed: _confirmBooking,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF006B2D),
                                      disabledBackgroundColor: const Color(
                                        0xCC006B2D,
                                      ),
                                      disabledForegroundColor: Colors.white,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      "Confirm Appointment",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: blockGap),
                              SizedBox(height: blockGap),
                              const _SectionLabel("Check Appointment"),
                              SizedBox(height: sectionGap),
                              // Check Appointment Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE3EFE1),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF000000,
                                      ).withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Header
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.search,
                                          color: Color(0xFF006B2D),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "Check Appointment",
                                          style: TextStyle(
                                            color: Color(0xFF006B2D),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "View or manage your appointment details",
                                      style: TextStyle(
                                        color: Color(0xFF6E8D73),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    // Check Appointment Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CheckAppointmentScreen(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF006B2D,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          "Check Appointment",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                );
              },
            ),
          ),
          if (_isBooking)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Confirming your appointment...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
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
        color: Color(0xFF006B2D),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.months,
    required this.selectedDate,
    required this.onSelected,
  });

  final List<_MonthOption> months;
  final DateTime selectedDate;
  final ValueChanged<_MonthOption> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final gap = compact ? 12.0 : 16.0;
        final visibleItems = compact ? 4 : months.length;
        final itemWidth =
            (constraints.maxWidth - (gap * (visibleItems - 1))) / visibleItems;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var index = 0; index < months.length; index++) ...[
                SizedBox(
                  width: itemWidth.clamp(compact ? 80.0 : 110.0, 160.0),
                  height: 52,
                  child: _MonthChip(
                    month: months[index],
                    isSelected: months[index].isSameMonth(selectedDate),
                    onTap: () => onSelected(months[index]),
                  ),
                ),
                if (index != months.length - 1) SizedBox(width: gap),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _MonthChip extends StatelessWidget {
  const _MonthChip({
    required this.month,
    required this.isSelected,
    required this.onTap,
  });

  final _MonthOption month;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.white.withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF006B2D)
                    : const Color(0xFF62B36E),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              month.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF27943B),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DaySelector extends StatelessWidget {
  const _DaySelector({
    required this.days,
    required this.selectedDate,
    required this.onSelected,
  });

  final List<_DayOption> days;
  final DateTime selectedDate;
  final ValueChanged<_DayOption> onSelected;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final gap = compact ? 10.0 : 14.0;
        final visibleItems = math.min(days.length, 7);
        final itemWidth =
            (constraints.maxWidth - (gap * (visibleItems - 1))) / visibleItems;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var index = 0; index < days.length; index++) ...[
                SizedBox(
                  width: itemWidth.clamp(compact ? 44.0 : 68.0, 100.0),
                  height: compact ? 68 : 80,
                  child: _DayCard(
                    day: days[index],
                    isSelected: _isSameDate(selectedDate, days[index].date),
                    onTap: () => onSelected(days[index]),
                  ),
                ),
                if (index != days.length - 1) SizedBox(width: gap),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  final _DayOption day;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: day.semanticLabel,
      button: true,
      selected: isSelected,
      child: Material(
        color: isSelected ? const Color(0xFF006B2D) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                if (!isSelected)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      day.weekday,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF27943B),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day.day,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeSlotGrid extends StatelessWidget {
  const _TimeSlotGrid({
    required this.slots,
    required this.selectedSlot,
    required this.onSelected,
  });

  final List<String> slots;
  final String? selectedSlot;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 360
            ? 3
            : constraints.maxWidth >= 250
            ? 2
            : 1;
        final spacing = columns == 3 ? 10.0 : 12.0;
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 12,
          children: slots.map((slot) {
            return SizedBox(
              width: itemWidth,
              height: 48,
              child: _TimeSlotButton(
                label: slot,
                isSelected: selectedSlot == slot,
                onTap: () => onSelected(slot),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _TimeSlotButton extends StatelessWidget {
  const _TimeSlotButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: isSelected ? const Color(0xFF006B2D) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF006B2D)
                    : const Color(0xFF62B36E),
                width: isSelected ? 0 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF006B2D),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  const CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.check,
                      color: Color(0xFF006B2D),
                      size: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppointmentDetailsCard extends StatelessWidget {
  const _AppointmentDetailsCard({required this.onChange});

  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: _softCardDecoration(),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFD9EED8),
            child: Icon(
              Icons.article_rounded,
              color: Color(0xFF006B2D),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Consultation",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF006B2D),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "General check-up and consultation",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF404040),
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onChange,
            child: const Text(
              "Change",
              style: TextStyle(
                color: Color(0xFF27943B),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _softCardDecoration({
  Color borderColor = const Color(0xFFC7D8C5),
  Color backgroundColor = Colors.white,
}) {
  return BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: borderColor),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF0F6B2F).withValues(alpha: 0.02),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

class _MonthOption {
  const _MonthOption(this.year, this.month);

  final int year;
  final int month;

  String get label => "${_monthNames[month - 1]}";

  bool isSameMonth(DateTime date) {
    return year == date.year && month == date.month;
  }
}

class _DayOption {
  const _DayOption(this.date);

  final DateTime date;

  String get weekday => _shortWeekdayNames[date.weekday - 1];

  String get day => date.day.toString();

  String get semanticLabel {
    return "${_longWeekdayNames[date.weekday - 1]}, "
        "${_monthNames[date.month - 1]} ${date.day}, ${date.year}";
  }
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

List<_MonthOption> _buildMonthOptions(DateTime startDate) {
  return List.generate(_visibleMonthCount, (index) {
    final monthDate = DateTime(startDate.year, startDate.month + index);
    return _MonthOption(monthDate.year, monthDate.month);
  });
}

List<_DayOption> _buildDayOptions(_MonthOption month, DateTime minDate) {
  final firstDate = _firstSelectableDateForMonth(month, minDate);
  final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
  final availableDayCount = daysInMonth - firstDate.day + 1;

  if (availableDayCount <= 0) {
    return const <_DayOption>[];
  }

  return List.generate(availableDayCount, (index) {
    return _DayOption(DateTime(month.year, month.month, firstDate.day + index));
  });
}

DateTime _firstSelectableDateForMonth(_MonthOption month, DateTime minDate) {
  if (month.isSameMonth(minDate)) {
    return minDate;
  }

  return DateTime(month.year, month.month);
}

bool _isSameDate(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

String _formatScheduleDate(DateTime date) {
  return "${_monthNames[date.month - 1]} ${date.day}, ${date.year}";
}
