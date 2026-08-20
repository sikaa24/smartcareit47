import 'package:flutter/material.dart';

import '../state/app_session.dart';
import 'smartcare_bottom_nav.dart';

class SmartCareDashboardHeader extends StatelessWidget {
  const SmartCareDashboardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.hasNotifications = true,
    this.showNotificationIcon = true,
  });

  final String title;
  final String subtitle;
  final bool hasNotifications;
  final bool showNotificationIcon;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 380;
        final horizontalPadding = compact ? 10.0 : 18.0;
        final titleTopPadding = compact ? 19.0 : 22.0;
        final bottomPadding = compact ? 30.0 : 34.0;

        return Container(
          width: double.infinity,
          height: 175,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/headnav.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  6,
                  horizontalPadding,
                  6,
                ),
                child: SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "SmartCare",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                      ),
                      if (showNotificationIcon)
                        _DashboardNotificationButton(
                          hasNotifications: hasNotifications,
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0x8CFFFFFF)),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  titleTopPadding,
                  horizontalPadding,
                  bottomPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 1.08,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFE8F7E8),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 1.18,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardNotificationButton extends StatelessWidget {
  const _DashboardNotificationButton({required this.hasNotifications});

  final bool hasNotifications;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Notifications",
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 30, height: 30),
      onPressed: () {
        final currentRole = SmartCareSession.currentRole;
        final route =
            currentRole == UserRole.doctor || currentRole == UserRole.secretary
            ? '/notifications-doctor-nurse'
            : '/notifications';
        smartCareGoTo(context, route);
      },
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.notifications_none, color: Colors.white, size: 23),
          if (hasNotifications)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 12,
                height: 12,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF304B),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.4),
                ),
                child: const Text(
                  "2",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
