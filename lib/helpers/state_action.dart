import '/alerts/toast_enums.dart';
import 'helper.dart';

/// [StateAction] class
class StateAction {
  /// Refresh the page
  static refreshPage(String state, {Function()? setState}) {
    _updateState(state, "refresh-page", {"setState": setState});
  }

  /// Set the state of the page
  static setState(String state, Function() setState) {
    _updateState(state, "set-state", {"setState": setState});
  }

  /// Pop the page
  static pop(String state, {dynamic result}) {
    _updateState(state, "pop", {"setState": result});
  }

  /// Displays a Toast message containing "Sorry" for the title, you
  /// only need to provide a [description].
  static showToastSorry(String state,
      {String? title,
      required String description,
      ToastNotificationStyleType? style}) {
    _updateState(state, "toast-sorry", {
      "title": title ?? "Sorry",
      "description": description,
      "style": style ?? ToastNotificationStyleType.danger
    });
  }

  /// Displays a Toast message containing "Warning" for the title, you
  /// only need to provide a [description].
  static showToastWarning(String state,
      {String? title,
      required String description,
      ToastNotificationStyleType? style}) {
    _updateState(state, "toast-warning", {
      "title": title ?? "Warning",
      "description": description,
      "style": style ?? ToastNotificationStyleType.warning
    });
  }

  /// Displays a Toast message containing "Info" for the title, you
  /// only need to provide a [description].
  static showToastInfo(String state,
      {String? title,
      required String description,
      ToastNotificationStyleType? style}) {
    _updateState(state, "toast-info", {
      "title": title ?? "Info",
      "description": description,
      "style": style ?? ToastNotificationStyleType.info
    });
  }

  /// Displays a Toast message containing "Error" for the title, you
  /// only need to provide a [description].
  static showToastDanger(String state,
      {String? title,
      required String description,
      ToastNotificationStyleType? style}) {
    _updateState(state, "toast-danger", {
      "title": title ?? "Error",
      "description": description,
      "style": style ?? ToastNotificationStyleType.danger
    });
  }

  /// Displays a Toast message containing "Oops" for the title, you
  /// only need to provide a [description].
  static showToastOops(String state,
      {String? title,
      required String description,
      ToastNotificationStyleType? style}) {
    _updateState(state, "toast-oops", {
      "title": title ?? "Oops",
      "description": description,
      "style": style ?? ToastNotificationStyleType.danger
    });
  }

  /// Displays a Toast message containing "Success" for the title, you
  /// only need to provide a [description].
  static showToastSuccess(String state,
      {String? title,
      required String description,
      ToastNotificationStyleType? style}) {
    _updateState(state, "toast-success", {
      "title": title ?? "Success",
      "description": description,
      "style": style ?? ToastNotificationStyleType.success
    });
  }

  /// Display a custom Toast message.
  static showToastCustom(String state,
      {String? title,
      required String description,
      ToastNotificationStyleType? style}) {
    _updateState(state, "toast-custom", {
      "title": title ?? "",
      "description": description,
      "style": style ?? ToastNotificationStyleType.custom
    });
  }

  /// Validate data from your widget.
  static validate(String state,
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
    _updateState(state, "validate", {
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
  static changeLanguage(String state,
      {required String language, bool restartState = true}) {
    _updateState(state, "change-language", {
      "language": language,
      "restartState": restartState,
    });
  }

  /// Perform a confirm action
  static confirmAction(String state,
      {required Function() action,
      required String title,
      String dismissText = "Cancel"}) async {
    _updateState(state, "confirm-action",
        {"action": action, "title": title, "dismissText": dismissText});
  }

  /// Updates the page [state]
  /// Provide an [action] and [data] to call a method in the [NyState].
  static void _updateState(String state, String action, dynamic data) {
    updateState(state, data: {"action": action, "data": data});
  }
}
