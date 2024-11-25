import 'package:nylo_support/helpers/extensions.dart';
import 'package:nylo_support/router/router.dart';

import '/alerts/toast_enums.dart';
import 'helper.dart';

/// [StateAction] class
class StateAction {
  /// Helper to find the state name
  static _findStateName(dynamic state) {
    if (state is String) {
      return state;
    }
    if (state is RouteView) {
      return state.nyPageName();
    }
    return "";
  }

  /// Refresh the page
  static refreshPage(dynamic state, {Function()? setState}) {
    _updateState(_findStateName(state), "refresh-page", {"setState": setState});
  }

  /// Set the state of the page
  static setState(dynamic state, Function() setState) {
    _updateState(_findStateName(state), "set-state", {"setState": setState});
  }

  /// Pop the page
  static pop(dynamic state, {dynamic result}) {
    _updateState(_findStateName(state), "pop", {"setState": result});
  }

  /// Displays a Toast message containing "Sorry" for the title, you
  /// only need to provide a [description].
  static showToastSorry(dynamic state,
      {String? title,
      required String description,
      ToastNotificationStyleType? style}) {
    _updateState(_findStateName(state), "toast-sorry", {
      "title": title ?? "Sorry",
      "description": description,
      "style": style ?? ToastNotificationStyleType.danger
    });
  }

  /// Displays a Toast message containing "Warning" for the title, you
  /// only need to provide a [description].
  static showToastWarning(dynamic state,
      {String? title,
      required String description,
      ToastNotificationStyleType? style}) {
    _updateState(_findStateName(state), "toast-warning", {
      "title": title ?? "Warning",
      "description": description,
      "style": style ?? ToastNotificationStyleType.warning
    });
  }

  /// Displays a Toast message containing "Info" for the title, you
  /// only need to provide a [description].
  static showToastInfo(dynamic state,
      {String? title,
      required String description,
      ToastNotificationStyleType? style}) {
    _updateState(_findStateName(state), "toast-info", {
      "title": title ?? "Info",
      "description": description,
      "style": style ?? ToastNotificationStyleType.info
    });
  }

  /// Displays a Toast message containing "Error" for the title, you
  /// only need to provide a [description].
  static showToastDanger(dynamic state,
      {String? title,
      required String description,
      ToastNotificationStyleType? style}) {
    _updateState(_findStateName(state), "toast-danger", {
      "title": title ?? "Error",
      "description": description,
      "style": style ?? ToastNotificationStyleType.danger
    });
  }

  /// Displays a Toast message containing "Oops" for the title, you
  /// only need to provide a [description].
  static showToastOops(dynamic state,
      {String? title,
      required String description,
      ToastNotificationStyleType? style}) {
    _updateState(_findStateName(state), "toast-oops", {
      "title": title ?? "Oops",
      "description": description,
      "style": style ?? ToastNotificationStyleType.danger
    });
  }

  /// Displays a Toast message containing "Success" for the title, you
  /// only need to provide a [description].
  static showToastSuccess(dynamic state,
      {String? title,
      required String description,
      ToastNotificationStyleType? style}) {
    _updateState(_findStateName(state), "toast-success", {
      "title": title ?? "Success",
      "description": description,
      "style": style ?? ToastNotificationStyleType.success
    });
  }

  /// Display a custom Toast message.
  static showToastCustom(dynamic state,
      {String? title,
      required String description,
      ToastNotificationStyleType? style}) {
    _updateState(_findStateName(state), "toast-custom", {
      "title": title ?? "",
      "description": description,
      "style": style ?? ToastNotificationStyleType.custom
    });
  }

  /// Validate data from your widget.
  static validate(dynamic state,
      {required Map<String, dynamic> rules,
      Map<String, dynamic>? data,
      Map<String, dynamic>? messages,
      bool showAlert = true,
      Duration? alertDuration,
      ToastNotificationStyleType alertStyle =
          ToastNotificationStyleType.warning,
      required Function()? onSuccess,
      Function(Exception exception)? onFailure,
      String? lockRelease}) {
    _updateState(_findStateName(state), "validate", {
      "rules": rules,
      "data": data,
      "messages": messages,
      "showAlert": showAlert,
      "alertDuration": alertDuration,
      "alertStyle": alertStyle,
      "onSuccess": onSuccess,
      "onFailure": onFailure,
      "lockRelease": lockRelease,
    });
  }

  /// Update the language in the application
  static changeLanguage(dynamic state,
      {required String language, bool restartState = true}) {
    _updateState(_findStateName(state), "change-language", {
      "language": language,
      "restartState": restartState,
    });
  }

  /// Perform a confirm action
  static confirmAction(dynamic state,
      {required Function() action,
      required String title,
      String dismissText = "Cancel"}) async {
    _updateState(_findStateName(state), "confirm-action",
        {"action": action, "title": title, "dismissText": dismissText});
  }

  /// Updates the page [state]
  /// Provide an [action] and [data] to call a method in the [NyState].
  static void _updateState(dynamic state, String action, dynamic data) {
    updateState(state, data: {"action": action, "data": data});
  }
}
