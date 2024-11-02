import 'package:flutter/cupertino.dart';

/// NavigationTab is a class that holds the title, page, icon, activeIcon, backgroundColor, tooltip, and meta data of a bottom navigation tab.
class NavigationTab {
  final String title;
  final Widget page;
  final Widget? icon;
  final Widget? activeIcon;
  final Color? backgroundColor;
  final String? tooltip;
  final String? kind;
  final Map<String, dynamic> meta;

  /// NavigationTab is a class that holds the title, page, icon, activeIcon, backgroundColor, tooltip, and meta data of a bottom navigation tab.
  NavigationTab(
      {required this.title,
      required this.page,
      this.icon,
      this.activeIcon,
      this.tooltip,
      this.backgroundColor,
      this.meta = const {}})
      : kind = 'default';

  /// NavigationTab.badge is a class that holds the title, page, icon, activeIcon, backgroundColor, tooltip, and meta data of a bottom navigation tab with a badge.
  NavigationTab.badge(
      {required this.title,
      required this.page,
      this.icon,
      this.activeIcon,
      int? initialCount,
      bool? rememberCount = true,
      this.tooltip,
      this.backgroundColor,
      Map<String, dynamic>? meta})
      : meta = {},
        kind = "badge" {
    this.meta.addAll({
      "initialCount": initialCount,
      "rememberCount": rememberCount,
    });
  }
}
