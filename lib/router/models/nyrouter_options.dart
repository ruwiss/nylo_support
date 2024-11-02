import 'package:flutter/material.dart';
import '/router/models/ny_page_transition_settings.dart';

/// Options to configure a Nylo Router instance.
class NyRouterOptions {
  final bool handleNameNotFoundUI;
  final PageTransitionSettings pageTransitionSettings;

  /// Should display logs in console. Nylo Router prints some useful logs
  /// which can be helpful during development.
  ///
  /// By default logs are disabled i.e. value is set to [false].
  final bool isLoggingEnabled;

  /// A navigator key lets NyRouter grab the [NavigatorState] from a [MaterialApp]
  /// or a [CupertinoApp]. All navigation operations (push, pop, etc) are carried
  /// out using this [NavigatorState].
  ///
  /// This is the same [NavigatorState] that is returned by [Navigator.of(context)]
  /// (when there is only a single [Navigator] in Widget tree, i.e. from [MaterialApp]
  /// or [CupertinoApp]).
  final GlobalKey<NavigatorState>? navigatorKey;

  const NyRouterOptions({
    this.handleNameNotFoundUI = false,
    this.isLoggingEnabled = false,
    this.pageTransitionSettings = const PageTransitionSettings.base(),
    this.navigatorKey,
  });
}
