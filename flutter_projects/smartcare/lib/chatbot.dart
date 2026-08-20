import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text:
          'Hello, Carise! I’m your SmartCare AI assistant. How can I help you today?',
      isUser: false,
      time: '9:41 AM',
    ),
  ];

  // Rule-based reply engine: each rule is checked in order against the
  // lowercased user message, and the first keyword match wins.
  static const List<_ChatRule> _rules = [
    _ChatRule(
      keywords: ['hello', 'hi', 'hey', 'kumusta', 'magandang'],
      reply: 'Hello! I can help with appointments, clinic hours, payment, '
          'health tips, and visit preparation. What do you need?',
    ),
    _ChatRule(
      keywords: ['reschedule', 'move my appointment', 'change my appointment'],
      reply: 'To reschedule, open your upcoming appointment on the Home tab '
          'or Visit History and tap "Reschedule". Pick a new date and time '
          'and it will be updated right away.',
    ),
    _ChatRule(
      keywords: ['cancel'],
      reply: 'To cancel an appointment, open it from the Home tab and tap '
          '"Cancel". You will be asked to confirm before it is cancelled.',
    ),
    _ChatRule(
      keywords: ['check my appointment', 'my appointment', 'upcoming appointment', 'appointment status'],
      reply: 'You can see your upcoming appointment on the Home tab, and '
          'your full appointment history under the History tab.',
    ),
    _ChatRule(
      keywords: ['available date', 'available slot', 'open slot', 'find available'],
      reply: 'Open date slots are shown when you start booking an '
          'appointment in the Book tab — just pick a doctor and the '
          'calendar will show which dates still have room.',
    ),
    _ChatRule(
      keywords: ['book', 'schedule an appointment', 'set an appointment', 'appointment'],
      reply: 'You can book an appointment from the Book tab at the bottom '
          'of the screen — choose a doctor, pick a date and time, and '
          'confirm.',
    ),
    _ChatRule(
      keywords: ['hour', 'open', 'close', 'location', 'address', 'clinic'],
      reply: 'Sta. Rita Clinic is open Monday to Saturday, 8:00 AM to '
          '5:00 PM. You can find the full address and other branches under '
          'Menu > Contacts.',
    ),
    _ChatRule(
      keywords: ['payment', 'insurance', 'hmo', 'bill', 'price', 'fee', 'cost'],
      reply: 'We accept cash, major HMOs, and most health insurance plans. '
          'Please bring your HMO card or insurance details on the day of '
          'your visit for verification.',
    ),
    _ChatRule(
      keywords: ['health tip', 'advice', 'symptom', 'fever', 'pain', 'sick'],
      reply: 'I can share general wellness tips, but for symptoms or '
          'anything urgent, please consult your doctor directly or book a '
          'consultation — I am not a substitute for medical advice.',
    ),
    _ChatRule(
      keywords: ['prepare', 'bring', 'requirement', 'what to bring'],
      reply: 'For your visit, please bring a valid ID, your HMO/insurance '
          'card if applicable, any previous lab results, and arrive at '
          'least 10 minutes before your scheduled time.',
    ),
    _ChatRule(
      keywords: ['queue', 'wait', 'waiting', 'my turn', 'line'],
      reply: 'You can track your live queue number and estimated wait time '
          'under the Queue Status section, reachable from Home or Menu.',
    ),
    _ChatRule(
      keywords: ['doctor'],
      reply: 'You can see which doctors are available today, along with '
          'their schedules, from the Book tab when choosing a doctor.',
    ),
    _ChatRule(
      keywords: ['thank'],
      reply: "You're welcome! Let me know if there's anything else I can "
          'help you with.',
    ),
    _ChatRule(
      keywords: ['bye', 'goodbye', 'paalam'],
      reply: 'Take care! Come back anytime you need help with SmartCare.',
    ),
  ];

  static const String _fallbackReply =
      "I'm not sure I understood that. You can ask me about booking, "
      'rescheduling, clinic hours, payment, or tap one of the suggestions '
      'below.';

  String _generateReply(String userText) {
    final normalized = userText.toLowerCase();
    for (final rule in _rules) {
      if (rule.keywords.any(normalized.contains)) {
        return rule.reply;
      }
    }
    return _fallbackReply;
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _sendUserMessage(text);
    _messageController.clear();
  }

  void _sendUserMessage(String text) {
    final userMessage = _ChatMessage(
      text: text,
      isUser: true,
      isRead: false,
      time: _formattedTime(),
    );

    setState(() {
      _messages.add(userMessage);
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      final aiMessage = _ChatMessage(
        text: _generateReply(text),
        isUser: false,
        time: _formattedTime(),
      );
      setState(() {
        _messages.add(aiMessage);
        _markLastUserMessageRead();
      });
      _scrollToBottom();
    });
  }

  void _markLastUserMessageRead() {
    for (var index = _messages.length - 1; index >= 0; index--) {
      final message = _messages[index];
      if (message.isUser && !message.isRead) {
        message.isRead = true;
        break;
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formattedTime() {
    final time = TimeOfDay.now();
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EEFF),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF7F2FF), Color(0xFFF4EEFF)],
            ),
          ),
          child: Column(
            children: [
              Material(
                color: Colors.white,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    16,
                    MediaQuery.of(context).padding.top + 12,
                    16,
                    14,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE9E1FF), width: 1),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: Color(0xFF5C28D6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFFECE5FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.smart_toy,
                          color: Color(0xFF5C28D6),
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SmartCare AI',
                              style: TextStyle(
                                color: Color(0xFF2E2A6F),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1AAA5A),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Online',
                                  style: TextStyle(
                                    color: Color(0xFF1AAA5A),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        for (var i = 0; i < _messages.length; i++) ...[
                          _ChatBubble(
                            text: _messages[i].text,
                            isUser: _messages[i].isUser,
                            isRead: _messages[i].isRead,
                            time: _messages[i].time,
                          ),
                          if (i != _messages.length - 1)
                            const SizedBox(height: 4),
                        ],
                        const SizedBox(height: 24),
                        const Text(
                          'You can also ask me about:',
                          style: TextStyle(
                            color: Color(0xFF6A6988),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final chipWidth = (constraints.maxWidth - 14) / 2;
                            return Wrap(
                              runSpacing: 14,
                              spacing: 14,
                              children: [
                                SizedBox(
                                  width: chipWidth,
                                  child: _ChatActionChip(
                                    label: 'Book an appointment',
                                    onTap: () =>
                                        _sendUserMessage('Book an appointment'),
                                  ),
                                ),
                                SizedBox(
                                  width: chipWidth,
                                  child: _ChatActionChip(
                                    label: 'Check my appointments',
                                    onTap: () => _sendUserMessage(
                                      'Check my appointments',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: chipWidth,
                                  child: _ChatActionChip(
                                    label: 'Find available dates',
                                    onTap: () => _sendUserMessage(
                                      'Find available dates',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: chipWidth,
                                  child: _ChatActionChip(
                                    label: 'Reschedule appointment',
                                    onTap: () => _sendUserMessage(
                                      'Reschedule appointment',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: chipWidth,
                                  child: _ChatActionChip(
                                    label: 'Clinic locations & hours',
                                    onTap: () => _sendUserMessage(
                                      'Clinic locations & hours',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: chipWidth,
                                  child: _ChatActionChip(
                                    label: 'Payment & insurance',
                                    onTap: () =>
                                        _sendUserMessage('Payment & insurance'),
                                  ),
                                ),
                                SizedBox(
                                  width: chipWidth,
                                  child: _ChatActionChip(
                                    label: 'Health tips & advice',
                                    onTap: () => _sendUserMessage(
                                      'Health tips & advice',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: chipWidth,
                                  child: _ChatActionChip(
                                    label: 'Preparation for my visit',
                                    onTap: () => _sendUserMessage(
                                      'Preparation for my visit',
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE9E1FF)),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 18),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              onSubmitted: (_) => _sendMessage(),
                              decoration: const InputDecoration(
                                hintText: 'Type your message...',
                                hintStyle: TextStyle(
                                  color: Color(0xFF9F9CBB),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                color: Color(0xFF312F57),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        /*
                  
                        */
                          InkWell(
                            onTap: _sendMessage,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5C28D6),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'AI responses may not always be accurate. Please confirm important details with our staff.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF5A4FA8),
                        fontSize: 13,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatRule {
  final List<String> keywords;
  final String reply;

  const _ChatRule({required this.keywords, required this.reply});
}

class _ChatMessage {
  final String text;
  final bool isUser;
  bool isRead;
  final String time;

  _ChatMessage({
    required this.text,
    required this.isUser,
    this.isRead = false,
    required this.time,
  });
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.text,
    required this.isUser,
    required this.time,
    this.isRead = false,
    super.key,
  });

  final String text;
  final bool isUser;
  final bool isRead;
  final String time;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isUser ? const Color(0xFF5C28D6) : Colors.white;
    final textColor = isUser ? Colors.white : const Color(0xFF312F57);
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    // Slightly increase corner radius for a smoother look (still not pill-shaped)
    final radius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
          );

    // Responsive max width: short messages remain compact; long messages can use more space
    final screenWidth = MediaQuery.of(context).size.width;
    final metadataStyle = const TextStyle(
      color: Color(0xFF7A7A8C),
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );
    double maxWidth;
    if (text.length > 120) {
      maxWidth = screenWidth * 0.70; // long messages
    } else if (text.length > 60) {
      maxWidth = screenWidth * 0.65;
    } else if (text.length > 20) {
      maxWidth = screenWidth * 0.55;
    } else {
      maxWidth = screenWidth * 0.45; // short messages stay very compact
    }

    // For user messages, show time and bubble, with the read status below the bubble.
    if (isUser) {
      return Align(
        alignment: alignment,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(time, softWrap: false, style: metadataStyle),
                const SizedBox(width: 6),
                Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: radius,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      height: 1.7,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                isRead ? 'Read' : 'Sent',
                softWrap: false,
                style: metadataStyle,
              ),
            ),
          ],
        ),
      );
    }

    // For AI messages keep metadata on the right, and include an invisible
    // read-line placeholder so vertical spacing between bubbles matches user bubbles.
    return Align(
      alignment: alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: radius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    height: 1.7,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(time, softWrap: false, style: metadataStyle),
            ],
          ),
          const SizedBox(height: 6),
          // Invisible placeholder matching the user read/sent label height so
          // the gap between consecutive bubbles is consistent for all messages.
          Opacity(
            opacity: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text('Sent', style: metadataStyle),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatActionChip extends StatelessWidget {
  const _ChatActionChip({required this.label, this.onTap, super.key});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(92, 40, 214, 0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF5C28D6),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
