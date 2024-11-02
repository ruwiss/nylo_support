import 'package:flutter/material.dart';
import '/router/router.dart';
import '/router/page_transition/src/enum.dart';
import '/router/models/ny_argument.dart';
import 'ny_page_transition_settings.dart';
import 'ny_query_parameters.dart';

/// Class interface
abstract class RouteGuard {
  RouteGuard({this.pageRequest});

  PageRequest? pageRequest;

  /// Called before a route is opened.
  onRequest(
    PageRequest pageRequest,
  ) =>
      null;
}

/// Base class for Nylo's [RouteGuard].
///
/// Usage:
/// 1. Create a new class that extends [RouteGuard].
/// class AuthRouteGuard extends NyRouteGuard {
///   AuthRouteGuard();
///
///   @override
///   Future<PageRequest?> onRequest(PageRequest pageRequest) async {
///
///     // Check if user is authenticated
///     if (await Auth.loggedIn()) {
///       return redirect(HomePage.path);
///     }
///
///     return pageRequest;
///   }
/// }
///
/// 2. Add the new [RouteGuard] to your route.
/// appRouter() => nyRoutes((router) {
///
///   router.route(ProfilePage.path, (context) => ProfilePage(), routeGuards: [
///     AuthRouteGuard() // new guard
///   ]);
///
///  });
class NyRouteGuard extends RouteGuard {
  NyRouteGuard();

  /// The [NyArgument] passed from the last route.
  get data => pageRequest?.data;

  /// The [BuildContext] for the current route.
  BuildContext? get context => pageRequest?.context;

  /// The [NyQueryParameters] for the current route.
  Map<String, String>? get queryParameters => pageRequest?.queryParameters;

  /// Add data to the current route.
  addData(dynamic Function(dynamic data) currentData) {
    pageRequest?.addData(currentData);
  }

  @override
  onRequest(
    PageRequest pageRequest,
  );

  /// Redirect to a new route.
  redirect(dynamic path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      NavigationType navigationType = NavigationType.pushReplace,
      dynamic result,
      bool Function(Route<dynamic> route)? removeUntilPredicate,
      PageTransitionSettings? pageTransitionSettings,
      PageTransitionType? pageTransitionType,
      Function(dynamic value)? onPop}) {
    dynamic currentData = this.data;
    if (data != null) {
      currentData = data;
    }
    routeTo(path,
        data: currentData,
        queryParameters: queryParameters,
        navigationType: navigationType,
        result: result,
        removeUntilPredicate: removeUntilPredicate,
        pageTransitionSettings: pageTransitionSettings,
        pageTransitionType: pageTransitionType,
        onPop: onPop);
    return PageRequest.redirect();
  }
}

/// Class interface for [PageRequest].
class PageRequest {
  BuildContext? context;
  NyArgument? nyArgument;
  Map<String, String>? queryParameters;
  bool isRedirect = false;

  get data => nyArgument?.data;

  PageRequest({this.context, this.nyArgument, this.queryParameters});

  /// Redirect to a new route.
  PageRequest.redirect() {
    isRedirect = true;
  }

  /// Add data to the current route.
  addData(dynamic Function(dynamic data) currentData) {
    nyArgument?.setData((currentData(data)));
  }
}
