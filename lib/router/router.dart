import 'dart:io';

import 'package:flutter/material.dart';
import '/helpers/backpack.dart';
import '/helpers/helper.dart';
import '/router/errors/route_not_found.dart';
import '/router/models/arguments_wrapper.dart';
import '/router/models/ny_page_transition_settings.dart';
import '/router/models/ny_query_parameters.dart';
import '/router/models/nyrouter_route_guard.dart';
import '/router/models/nyrouter_options.dart';
import '/router/models/nyrouter_route.dart';
import '/router/ui/page_not_found.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'models/ny_argument.dart';

/// Type definition for the route view.
typedef RouteView = (String, Widget Function(BuildContext context));

/// The NyNavigator class is a singleton class that manages the routing of the
/// application. It is a thin layer on top of [Navigator] to help you encapsulate
/// and manage routing at one place.
class NyNavigator {
  NyRouter router = NyRouter();
  NyNavigator._privateConstructor();

  static final NyNavigator instance = NyNavigator._privateConstructor();

  /// Prefix routes
  Map<String, String> prefixRoutes = {};
}

typedef NyRouteView = Widget Function(
  BuildContext context,
);

/// Builds the routes in the router.dart file
NyRouter nyRoutes(Function(NyRouter router) build) {
  NyRouter nyRouter = NyRouter();
  build(nyRouter);

  return nyRouter;
}

enum NavigationType {
  push,
  pushReplace,
  pushAndRemoveUntil,
  popAndPushNamed,
  pushAndForgetAll
}

/// NyRouterRoute manages routing, registering routes with transitions, navigating to
/// routes, closing routes. It is a thin layer on top of [Navigator] to help
/// you encapsulate and manage routing at one place.
class NyRouter {
  NyRouter({
    this.options = const NyRouterOptions(),
  }) {
    if (options.navigatorKey != null) {
      _navigatorKey = options.navigatorKey;
    } else {
      _navigatorKey = GlobalKey<NavigatorState>();
    }
  }

  /// Configuration options for [NyRouterRoute].
  ///
  /// Check out [NyRouterRouteOptions] for available options.
  final NyRouterOptions options;

  /// Store all the mappings of route names and corresponding [NyRouterRouteRoute]
  /// Used to generate routes
  Map<String, NyRouterRoute> _routeNameMappings = {};

  /// A navigator key lets NyRouterRoute grab the [NavigatorState] from a [MaterialApp]
  /// or a [CupertinoApp]. All navigation operations (push, pop, etc) are carried
  /// out using this [NavigatorState].
  ///
  /// This is the same [NavigatorState] that is returned by [Navigator.of(context)]
  /// (when there is only a single [Navigator] in Widget tree, i.e. from [MaterialApp]
  /// or [CupertinoApp]).
  GlobalKey<NavigatorState>? _navigatorKey;

  /// Stores the history of routes visited.
  List<Route<dynamic>> _routeHistory = [];

  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  /// Get the registered routes names as a list.
  List<String> getRegisteredRouteNames() => _routeNameMappings.keys.toList();

  /// Get the registered routes as a list.
  Map<String, NyRouterRoute> getRegisteredRoutes() => _routeNameMappings;

  /// Set the registered routes.
  void setRegisteredRoutes(Map<String, NyRouterRoute> routes) {
    _routeNameMappings.addAll(routes);
  }

  /// Set the registered routes.
  void setNyRoutes(NyRouter router) {
    _routeNameMappings.addAll(router.getRegisteredRoutes());
  }

  /// Retrieves the arguments passed in when calling the [navigate] function.
  ///
  /// Returned arguments are casted with the type provided, the type will always
  /// be a subtype of [NyArgument].
  ///
  /// Make sure to provide the appropriate type, that is, provide the same type
  /// as the one passed while calling [navigate], else a cast error will be
  /// thrown.
  static T? args<T extends NyArgument?>(BuildContext context) {
    return (ModalRoute.of(context)!.settings.arguments as ArgumentsWrapper)
        .baseArguments as T?;
  }

  /// Updates a named [route].
  updateRoute(NyRouterRoute route) {
    _routeNameMappings[route.name] = route;
  }

  /// Group routes
  /// [settings] is a function that returns a map of settings.
  /// [router] is a function that returns a router.
  /// Example:
  /// ```dart
  /// group(() {
  ///  return {
  ///  'prefix': '/auth',
  ///  'route_guards': [AuthGuard()]
  ///  };
  ///  }, (router) {
  ///   router.route(AccountPage.path, (_) => AccountPage());
  ///   router.route(AccountSettingsPage.path, (_) => AccountSettingsPage());
  ///  });
  group(Map<String, dynamic> Function() settings,
      Function(NyRouter router) router) {
    NyRouter nyRouter = NyRouter();
    router(nyRouter);

    List<NyRouteGuard> routeGuards = [];
    String? prefix;
    PageTransitionType? transition;
    PageTransitionSettings? pageTransitionSettings;

    Map<String, dynamic> routeConfig = settings();
    if (routeConfig.containsKey('route_guards') &&
        routeConfig['route_guards'] is List<NyRouteGuard>) {
      routeGuards = routeConfig['route_guards'] as List<NyRouteGuard>;
    }

    if (routeConfig.containsKey('prefix') && routeConfig['prefix'] is String) {
      prefix = routeConfig['prefix'] as String;
    }

    if (routeConfig.containsKey('transition') &&
        routeConfig['transition'] is PageTransitionType) {
      transition = routeConfig['transition'] as PageTransitionType;
    }

    if (routeConfig.containsKey('transition_settings') &&
        routeConfig['transition_settings'] is PageTransitionSettings) {
      pageTransitionSettings =
          routeConfig['transition_settings'] as PageTransitionSettings;
    }

    nyRouter.getRegisteredRoutes().forEach((key, NyRouterRoute route) {
      if (routeGuards.isNotEmpty) {
        route.addRouteGuards(routeGuards);
      }
      if (prefix != null) {
        NyNavigator.instance.prefixRoutes[key] = prefix;
      }
      if (transition != null) {
        route.transition(transition);
      }
      if (pageTransitionSettings != null) {
        route.pageTransitionSettings = pageTransitionSettings;
      }
    });

    setNyRoutes(nyRouter);

    assert(
        _routeNameMappings.entries
                .where((element) => element.value.getInitialRoute() == true)
                .length <=
            1,
        'Your project has more than one initial route defined, please check your router file.');
  }

  /// Add a new route with a [RouteView].
  NyRouterRoute add(RouteView routeView,
      {PageTransitionType? transition,
      PageTransitionSettings? pageTransitionSettings,
      List<NyRouteGuard>? routeGuards,
      bool initialRoute = false,
      bool authPage = false}) {
    NyRouterRoute nyRouterRoute = NyRouterRoute(
        name: routeView.$1,
        view: (context) => routeView.$2(context),
        pageTransitionType: transition,
        pageTransitionSettings: pageTransitionSettings,
        routeGuards: routeGuards,
        initialRoute: initialRoute,
        authPage: authPage);
    _addRoute(nyRouterRoute);

    assert(
        _routeNameMappings.entries
                .where((element) => element.value.getInitialRoute() == true)
                .length <=
            1,
        'Your project has more than one initial route defined, please check your router file.');

    return nyRouterRoute;
  }

  /// Add a new route with a widget.
  NyRouterRoute route(String name, NyRouteView view,
      {PageTransitionType? transition,
      PageTransitionSettings? pageTransitionSettings,
      List<NyRouteGuard>? routeGuards,
      bool initialRoute = false,
      bool authPage = false}) {
    NyRouterRoute nyRouterRoute = NyRouterRoute(
        name: name,
        view: view,
        pageTransitionType: transition,
        pageTransitionSettings: pageTransitionSettings,
        routeGuards: routeGuards,
        initialRoute: initialRoute,
        authPage: authPage);
    _addRoute(nyRouterRoute);

    assert(
        _routeNameMappings.entries
                .where((element) => element.value.getInitialRoute() == true)
                .length <=
            1,
        'Your project has more than one initial route defined, please check your router file.');

    return nyRouterRoute;
  }

  /// Add a new route to [NyRouterRoute].
  ///
  /// Route is stored in [_routeNameMappings].
  ///
  /// If a route is provided with a name that was previously added, it will
  /// override the old one.
  void _addRoute(NyRouterRoute route) {
    if (_routeNameMappings.containsKey(route.name)) {
      NyLogger.info(
          "'${route.name}' has already been registered before. Overriding it!");
    }
    _routeNameMappings[route.name] = route;
    NyNavigator.instance.router = this;
  }

  /// Retrieves the auth route name from your router.
  String? getAuthRouteName() {
    List<MapEntry<String, NyRouterRoute>> authRoutes = NyNavigator
        .instance.router._routeNameMappings.entries
        .where((element) => element.value.getAuthRoute() == true)
        .toList();

    if (authRoutes.isNotEmpty && Backpack.instance.auth() != null) {
      return authRoutes.first.value.name;
    }
    return null;
  }

  /// Retrieves the initial route name from your router.
  String getInitialRouteName() {
    List<MapEntry<String, NyRouterRoute>> initialRoutes = NyNavigator
        .instance.router._routeNameMappings.entries
        .where((element) => element.value.getInitialRoute() == true)
        .toList();

    if (initialRoutes.isNotEmpty) {
      return initialRoutes.first.value.name;
    }
    return "/";
  }

  /// Find the initial route.
  static String getInitialRoute() {
    List<MapEntry<String, NyRouterRoute>> authRoutes = NyNavigator
        .instance.router._routeNameMappings.entries
        .where((element) => element.value.getAuthRoute() == true)
        .toList();

    if (authRoutes.isNotEmpty && Backpack.instance.auth() != null) {
      return authRoutes.first.value.name;
    }

    List<MapEntry<String, NyRouterRoute>> initialRoutes = NyNavigator
        .instance.router._routeNameMappings.entries
        .where((element) => element.value.getInitialRoute() == true)
        .toList();

    if (initialRoutes.isNotEmpty) {
      return initialRoutes.first.value.name;
    }
    return "/";
  }

  /// Add a list of routes at once.
  void addRoutes(List<NyRouterRoute> routes) {
    if (routes.isNotEmpty) {
      for (var route in routes) {
        _addRoute(route);
      }
    }
    NyNavigator.instance.router = this;
  }

  /// Function used to navigate pages.
  ///
  /// [name] is the route name that was registered using [addRoute].
  ///
  /// [args] are optional arguments that can be passed to the next page.
  /// To retrieve these arguments use [args] method on [NyRouterRoute].
  ///
  /// [navigationType] can be specified to choose from various navigation
  /// strategies such as [NavigationType.push], [NavigationType.pushReplace],
  /// [NavigationType.pushAndRemoveUntil].
  ///
  /// [removeUntilPredicate] should be provided if using
  /// [NavigationType.pushAndRemoveUntil] strategy.
  Future<T> navigate<T>(String name,
      {NyArgument? args,
      NavigationType navigationType = NavigationType.push,
      dynamic result,
      bool Function(Route<dynamic> route)? removeUntilPredicate,
      PageTransitionType? pageTransitionType,
      PageTransitionSettings? pageTransitionSettings}) async {
    assert(navigationType != NavigationType.pushAndRemoveUntil ||
        removeUntilPredicate != null);

    Uri? uriSettingName;
    try {
      uriSettingName = Uri.parse(name);
    } on FormatException catch (e) {
      NyLogger.error(e.toString());
    }

    String routeName = name;
    if (uriSettingName != null) {
      routeName = uriSettingName.path;
    }

    NyQueryParameters? nyQueryParameters;
    if (uriSettingName != null && uriSettingName.queryParameters.isNotEmpty) {
      nyQueryParameters = NyQueryParameters(uriSettingName.queryParameters);
    }

    _checkAndThrowRouteNotFound(routeName, args, navigationType);

    return await _navigate(routeName, args, navigationType, result,
            removeUntilPredicate, pageTransitionType, pageTransitionSettings,
            queryParameters: nyQueryParameters)
        .then((value) => value as T);
  }

  /// Actual navigation is delegated by [navigate] method to this method.
  ///
  /// [name] is the route name that was registered using [addRoute].
  ///
  /// [args] are optional arguments that can be passed to the next page.
  /// To retrieve these arguments use [arguments] method on [NyRouterRoute].
  ///
  /// [navigationType] can be specified to choose from various navigation
  /// strategies such as [NavigationType.push], [NavigationType.pushReplace],
  /// [NavigationType.pushAndRemoveUntil].
  ///
  /// [removeUntilPredicate] should be provided is using
  /// [NavigationType.pushAndRemoveUntil] strategy.
  Future<dynamic> _navigate(
      String name,
      NyArgument? args,
      NavigationType navigationType,
      dynamic result,
      bool Function(Route<dynamic> route)? removeUntilPredicate,
      PageTransitionType? pageTransitionType,
      PageTransitionSettings? pageTransitionSettings,
      {NyQueryParameters? queryParameters}) async {
    final argsWrapper = ArgumentsWrapper(
      baseArguments: args,
      pageTransitionType: pageTransitionType,
      queryParameters: queryParameters,
      pageTransitionSettings: pageTransitionSettings,
    );

    /// Evaluate if the route can be opened using route guard.
    final NyRouterRoute? route = _routeNameMappings[name];

    if (route != null && (route.getRouteGuards()).isNotEmpty) {
      for (RouteGuard routeGuard in route.getRouteGuards()) {
        final result = await routeGuard.canOpen(
          navigatorKey!.currentContext,
          argsWrapper.baseArguments,
        );

        if (result == false) {
          return await routeGuard.redirectTo(
              navigatorKey!.currentContext, argsWrapper.baseArguments);
        }
      }
    }

    String? pushName;
    Map<String, String> routePrefixes = NyNavigator.instance.prefixRoutes;

    if (routePrefixes.containsKey(name)) {
      String? prefix = routePrefixes[name];
      if (prefix != null) {
        if (argsWrapper.baseArguments?.data == null) {
          argsWrapper.baseArguments = NyArgument({});
        }
        argsWrapper.prefix = prefix;
        pushName = (routePrefixes[name]! + name);
      }
    }

    switch (navigationType) {
      case NavigationType.push:
        return await navigatorKey!
            .currentState!
            .pushNamed(pushName ?? name, arguments: argsWrapper);
      case NavigationType.pushReplace:
        return await navigatorKey!.currentState!.pushReplacementNamed(
            pushName ?? name,
            result: result,
            arguments: argsWrapper);
      case NavigationType.pushAndRemoveUntil:
        return await navigatorKey!.currentState!.pushNamedAndRemoveUntil(
            pushName ?? name, removeUntilPredicate!,
            arguments: argsWrapper);
      case NavigationType.popAndPushNamed:
        return await navigatorKey!.currentState!.popAndPushNamed(
            pushName ?? name,
            result: result,
            arguments: argsWrapper);
      case NavigationType.pushAndForgetAll:
        return await navigatorKey!.currentState!.pushNamedAndRemoveUntil(
              pushName ?? name,
              (_) => false,
              arguments: argsWrapper,
            );
    }
  }

  /// Get the previous route.
  Route<dynamic>? getPreviousRoute() {
    if (_routeHistory.length < 2) return null;
    return _routeHistory[_routeHistory.length - 2];
  }

  /// Get the current route.
  Route<dynamic>? getCurrentRoute() {
    if (_routeHistory.isEmpty) return null;
    return _routeHistory[_routeHistory.length - 1];
  }

  /// Add the route to the history.
  addRouteHistory(Route<dynamic> route) {
    _routeHistory.add(route);
  }

  /// Remove the route from the history.
  removeRouteHistory(Route<dynamic> route) {
    _routeHistory.remove(route);
  }

  /// Remove the last route from the history.
  removeLastRouteHistory() {
    _routeHistory.removeLast();
  }

  /// Get the route history.
  List<Route<dynamic>> getRouteHistory() {
    return _routeHistory;
  }

  /// If the route is not registered throw an error
  /// Make sure to use the correct name while calling navigate.
  void _checkAndThrowRouteNotFound(
    String name,
    NyArgument? args,
    NavigationType navigationType,
  ) {
    if (!_routeNameMappings.containsKey(name)) {
      if (options.handleNameNotFoundUI) {
        NyLogger.error("Page not found\n"
            "[Route Name] $name\n"
            "[ARGS] ${args.toString()}");
        navigatorKey!.currentState!.push(
          MaterialPageRoute(builder: (BuildContext context) {
            return PageNotFound();
          }),
        );
      }
      throw RouteNotFoundError(name: name);
    }
  }

  /// Generates the [RouteFactory] which builds a [Route] on request.
  ///
  /// These routes are built using the [NyRouterRoute]s [addRoute] method.
  RouteFactory generator(
      {Widget Function(BuildContext context, Widget widget)? builder}) {
    return (RouteSettings settings) {
      if (settings.name == null) return null;

      Uri? uriSettingName;
      try {
        uriSettingName = Uri.parse(settings.name!);
      } on FormatException catch (e) {
        NyLogger.error(e.toString());
      }

      String routeName = settings.name!;
      if (uriSettingName != null) {
        routeName = uriSettingName.path;
      }

      ArgumentsWrapper? argumentsWrapper;
      if (settings.arguments is ArgumentsWrapper) {
        argumentsWrapper = settings.arguments as ArgumentsWrapper?;
      } else {
        argumentsWrapper = ArgumentsWrapper();
        argumentsWrapper.baseArguments = NyArgument(settings.arguments);
      }

      if (argumentsWrapper?.baseArguments?.data != null &&
          argumentsWrapper?.prefix != null) {
        String prefix = argumentsWrapper!.prefix!;
        routeName = routeName.replaceFirst(prefix, "");
      }

      argumentsWrapper ??= ArgumentsWrapper();

      if (uriSettingName != null && uriSettingName.queryParameters.isNotEmpty) {
        argumentsWrapper.queryParameters =
            NyQueryParameters(uriSettingName.queryParameters);
      }

      final NyArgument? baseArgs = argumentsWrapper.baseArguments;
      final NyQueryParameters? queryParameters =
          argumentsWrapper.queryParameters;

      argumentsWrapper.pageTransitionSettings ??= const PageTransitionSettings();

      final NyRouterRoute? route = _routeNameMappings[routeName];

      if (route == null) return null;

      route.pageTransitionSettings ??= const PageTransitionSettings();

      return PageTransition(
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          if (builder != null) {
            Widget widget = route.builder(
              context,
              baseArgs ?? route.defaultArgs,
              queryParameters ?? route.queryParameters,
            );
            return builder(context, widget);
          }
          return route.builder(context, baseArgs ?? route.defaultArgs,
              queryParameters ?? route.queryParameters);
        }),
        type: argumentsWrapper.pageTransitionType ??
            (route.pageTransitionType ?? PageTransitionType.rightToLeft),
        settings: settings,
        duration: _getPageTransitionDuration(route, argumentsWrapper),
        alignment: _getPageTransitionAlignment(route, argumentsWrapper),
        reverseDuration:
            _getPageTransitionReversedDuration(route, argumentsWrapper),
        matchingBuilder:
            _getPageTransitionMatchingBuilder(route, argumentsWrapper),
        childCurrent: _getPageTransitionChildCurrent(route, argumentsWrapper),
        curve: _getPageTransitionCurve(route, argumentsWrapper),
        ctx: _getPageTransitionContext(route, argumentsWrapper),
        inheritTheme: _getPageTransitionInheritTheme(route, argumentsWrapper),
        fullscreenDialog:
            _getPageTransitionFullscreenDialog(route, argumentsWrapper),
        opaque: _getPageTransitionOpaque(route, argumentsWrapper),
        isIos: _getPageTransitionIsIos(route, argumentsWrapper),
      );
    };
  }

  /// Used to retrieve the correct Duration value for the [PageTransition] constructor.
  Duration _getPageTransitionDuration(
      NyRouterRoute route, ArgumentsWrapper argumentsWrapper) {
    Duration duration = options.pageTransitionSettings.duration!;

    if (route.pageTransitionSettings?.duration != null) {
      duration = route.pageTransitionSettings!.duration!;
    }
    if (argumentsWrapper.pageTransitionSettings?.duration != null) {
      duration = argumentsWrapper.pageTransitionSettings!.duration!;
    }
    return duration;
  }

  /// Used to retrieve the correct ReversedDuration value for the [PageTransition] constructor.
  Duration _getPageTransitionReversedDuration(
      NyRouterRoute route, ArgumentsWrapper argumentsWrapper) {
    Duration duration = options.pageTransitionSettings.reverseDuration!;

    if (route.pageTransitionSettings?.reverseDuration != null) {
      duration = route.pageTransitionSettings!.reverseDuration!;
    }
    if (argumentsWrapper.pageTransitionSettings?.reverseDuration != null) {
      duration = argumentsWrapper.pageTransitionSettings!.reverseDuration!;
    }
    return duration;
  }

  /// Used to retrieve the correct ChildCurrent value for the [PageTransition] constructor.
  Widget? _getPageTransitionChildCurrent(
      NyRouterRoute route, ArgumentsWrapper argumentsWrapper) {
    Widget? widget = options.pageTransitionSettings.childCurrent;

    if (route.pageTransitionSettings?.childCurrent != null) {
      widget = route.pageTransitionSettings!.childCurrent;
    }
    if (argumentsWrapper.pageTransitionSettings?.childCurrent != null) {
      widget = argumentsWrapper.pageTransitionSettings!.childCurrent;
    }
    return widget;
  }

  /// Used to retrieve the correct Context value for the [PageTransition] constructor.
  BuildContext? _getPageTransitionContext(
      NyRouterRoute route, ArgumentsWrapper argumentsWrapper) {
    BuildContext? buildContext = options.pageTransitionSettings.context;

    if (route.pageTransitionSettings?.context != null) {
      buildContext = route.pageTransitionSettings!.context;
    }
    if (argumentsWrapper.pageTransitionSettings?.context != null) {
      buildContext = argumentsWrapper.pageTransitionSettings!.context;
    }
    return buildContext;
  }

  /// Used to retrieve the correct InheritTheme value for the [PageTransition] constructor.
  bool _getPageTransitionInheritTheme(
      NyRouterRoute route, ArgumentsWrapper argumentsWrapper) {
    bool boolVal = options.pageTransitionSettings.inheritTheme!;

    if (route.pageTransitionSettings?.inheritTheme != null) {
      boolVal = route.pageTransitionSettings!.inheritTheme!;
    }
    if (argumentsWrapper.pageTransitionSettings?.inheritTheme != null) {
      boolVal = argumentsWrapper.pageTransitionSettings!.inheritTheme!;
    }
    return boolVal;
  }

  /// Used to retrieve the correct Curve value for the [PageTransition] constructor.
  Curve _getPageTransitionCurve(
      NyRouterRoute route, ArgumentsWrapper argumentsWrapper) {
    Curve curve = options.pageTransitionSettings.curve!;

    if (route.pageTransitionSettings?.curve != null) {
      curve = route.pageTransitionSettings!.curve!;
    }
    if (argumentsWrapper.pageTransitionSettings?.curve != null) {
      curve = argumentsWrapper.pageTransitionSettings!.curve!;
    }
    return curve;
  }

  /// Used to retrieve the correct Alignment value for the [PageTransition] constructor.
  Alignment? _getPageTransitionAlignment(
      NyRouterRoute route, ArgumentsWrapper argumentsWrapper) {
    Alignment? alignment = options.pageTransitionSettings.alignment;

    if (route.pageTransitionSettings?.alignment != null) {
      alignment = route.pageTransitionSettings!.alignment;
    }
    if (argumentsWrapper.pageTransitionSettings?.alignment != null) {
      alignment = argumentsWrapper.pageTransitionSettings!.alignment;
    }
    return alignment;
  }

  /// Used to retrieve the correct FullscreenDialog value for the [PageTransition] constructor.
  bool _getPageTransitionFullscreenDialog(
      NyRouterRoute route, ArgumentsWrapper argumentsWrapper) {
    bool fullscreenDialog =
        options.pageTransitionSettings.fullscreenDialog!;

    if (route.pageTransitionSettings?.fullscreenDialog != null) {
      fullscreenDialog = route.pageTransitionSettings!.fullscreenDialog!;
    }
    if (argumentsWrapper.pageTransitionSettings?.fullscreenDialog != null) {
      fullscreenDialog =
          argumentsWrapper.pageTransitionSettings!.fullscreenDialog!;
    }
    return fullscreenDialog;
  }

  /// Used to retrieve the correct Opaque value for the [PageTransition] constructor.
  bool _getPageTransitionOpaque(
      NyRouterRoute route, ArgumentsWrapper argumentsWrapper) {
    bool opaque = options.pageTransitionSettings.opaque!;

    if (route.pageTransitionSettings?.opaque != null) {
      opaque = route.pageTransitionSettings!.opaque!;
    }
    if (argumentsWrapper.pageTransitionSettings?.opaque != null) {
      opaque = argumentsWrapper.pageTransitionSettings!.opaque!;
    }
    return opaque;
  }

  /// Used to retrieve the correct IsIos value for the [PageTransition] constructor.
  bool _getPageTransitionIsIos(
      NyRouterRoute route, ArgumentsWrapper argumentsWrapper) {
    bool isIos = false;

    if (!kIsWeb && Platform.isIOS) {
      isIos = true;
    }

    if (options.pageTransitionSettings.isIos != null) {
      isIos = options.pageTransitionSettings.isIos!;
    }

    if (route.pageTransitionSettings?.isIos != null) {
      isIos = route.pageTransitionSettings!.isIos!;
    }
    if (argumentsWrapper.pageTransitionSettings?.isIos != null) {
      isIos = argumentsWrapper.pageTransitionSettings!.isIos!;
    }

    return isIos;
  }

  /// Used to retrieve the correct MatchingBuilder value for the [PageTransition] constructor.
  PageTransitionsBuilder _getPageTransitionMatchingBuilder(
      NyRouterRoute route, ArgumentsWrapper argumentsWrapper) {
    PageTransitionsBuilder matchingBuilder =
        options.pageTransitionSettings.matchingBuilder!;

    if (route.pageTransitionSettings?.matchingBuilder != null) {
      matchingBuilder = route.pageTransitionSettings!.matchingBuilder!;
    }
    if (argumentsWrapper.pageTransitionSettings?.matchingBuilder != null) {
      matchingBuilder =
          argumentsWrapper.pageTransitionSettings!.matchingBuilder!;
    }
    return matchingBuilder;
  }

  /// Unknown route generator.
  static RouteFactory unknownRouteGenerator() {
    return (settings) {
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          return const PageNotFound();
        },
      );
    };
  }
}

/// Navigate to a new route.
///
/// It requires a String [routeName] e.g. "/my-route"
///
/// Optional variables in [data] that you can pass in [dynamic] objects to
/// the next widget you navigate to.
///
/// [navigationType] can be assigned with the following:
/// NavigationType.push, NavigationType.pushReplace,
/// NavigationType.pushAndRemoveUntil or NavigationType.popAndPushNamed
///
/// [pageTransitionType] allows you to assign a transition type for when
/// navigating to the new route. E.g. [PageTransitionType.fade] or
/// [PageTransitionType.bottomToTop].
/// See https://pub.dev/packages/page_transition to learn more.
routeTo(String routeName,
    {dynamic data,
    Map<String, dynamic>? queryParameters,
    NavigationType navigationType = NavigationType.push,
    dynamic result,
    bool Function(Route<dynamic> route)? removeUntilPredicate,
    PageTransitionSettings? pageTransitionSettings,
    PageTransitionType? pageTransition,
    Function(dynamic value)? onPop}) async {
  NyArgument nyArgument = NyArgument(data);
  if (queryParameters != null) {
    routeName =
        Uri(path: routeName, queryParameters: queryParameters).toString();
  }
  await NyNavigator.instance.router
      .navigate(routeName,
          args: nyArgument,
          navigationType: navigationType,
          result: result,
          removeUntilPredicate: removeUntilPredicate,
          pageTransitionType: pageTransition,
          pageTransitionSettings: pageTransitionSettings)
      .then((v) => onPop != null ? onPop(v) : (v) {});
}

/// Navigate to the auth route.
routeToAuth(
    {dynamic data,
    NavigationType navigationType = NavigationType.pushAndForgetAll,
    dynamic result,
    bool Function(Route<dynamic> route)? removeUntilPredicate,
    PageTransitionSettings? pageTransitionSettings,
    PageTransitionType? pageTransition,
    Function(dynamic value)? onPop}) async {
  NyArgument nyArgument = NyArgument(data);
  String? route = NyNavigator.instance.router.getAuthRouteName();
  if (route == null) {
    NyLogger.debug("No auth route set");
    return;
  }
  await NyNavigator.instance.router
      .navigate(route,
          args: nyArgument,
          navigationType: navigationType,
          result: result,
          removeUntilPredicate: removeUntilPredicate,
          pageTransitionType: pageTransition,
          pageTransitionSettings: pageTransitionSettings)
      .then((v) => onPop != null ? onPop(v) : (v) {});
}

/// Navigate to the initial route.
routeToInitial(
    {dynamic data,
    NavigationType navigationType = NavigationType.pushAndForgetAll,
    dynamic result,
    bool Function(Route<dynamic> route)? removeUntilPredicate,
    PageTransitionSettings? pageTransitionSettings,
    PageTransitionType? pageTransition,
    Function(dynamic value)? onPop}) async {
  NyArgument nyArgument = NyArgument(data);
  String route = NyNavigator.instance.router.getInitialRouteName();

  await NyNavigator.instance.router
      .navigate(route,
          args: nyArgument,
          navigationType: navigationType,
          result: result,
          removeUntilPredicate: removeUntilPredicate,
          pageTransitionType: pageTransition,
          pageTransitionSettings: pageTransitionSettings)
      .then((v) => onPop != null ? onPop(v) : (v) {});
}
