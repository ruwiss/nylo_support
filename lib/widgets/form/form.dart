import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/helpers/extensions.dart';
import '/helpers/loading_style.dart';
import 'package:recase/recase.dart';
import '/forms/ny_login_form.dart';
import '/helpers/helper.dart';
import '/nylo.dart';
import '/widgets/ny_form.dart';
import '/widgets/ny_list_view.dart';
import '/widgets/ny_state.dart';
import '/widgets/ny_text_field.dart';
import 'form_item.dart';

/// NyForm is a class that helps in managing forms
/// To create a form, you need to extend the [NyFormData] class
/// Example:
/// ```dart
/// class RegisterForm extends NyFormData {
///  @override
///  fields() => [
///     Field.text("Name", validate: FormValidator().notEmpty()),
///     Field.email("Email", validate: FormValidator.email()),
///  ];
/// }
///
/// RegisterForm form = RegisterForm();
///
/// NyForm(
///  form: form,
/// );
/// ```
///
/// To submit the form, you can call the [submit] method
/// Example:
/// ```dart
/// form.submit(onSuccess: (data) {});
/// // or
/// NyForm.submit("RegisterForm", onSuccess: (data) {});
/// ```
///
/// To get the data from the form, you can call the [data] method
/// Example:
/// ```dart
/// form.data();
/// ```
/// Learn more: https://nylo.dev/docs/6.x/forms
class NyForm extends StatefulWidget {
  NyForm(
      {super.key,
      required NyFormData form,
      this.crossAxisSpacing = 10,
      this.mainAxisSpacing = 10,
      Map<String, dynamic>? initialData,
      this.onChanged,
      this.validateOnFocusChange = false,
      this.header,
      this.footer,
      this.loading,
      this.locked = false})
      : form = form..setData(initialData ?? {}, refreshState: false),
        type = "form",
        children = null;

  /// Create a form with children
  /// Example:
  /// ```dart
  /// NyForm(
  /// form: form,
  /// children: [
  ///  Button.primary("Submit", onPressed: () {}),
  /// ],
  /// );
  /// ```
  NyForm.list(
      {super.key,
      required NyFormData form,
      required this.children,
      this.crossAxisSpacing = 10,
      this.mainAxisSpacing = 10,
      Map<String, dynamic>? initialData,
      this.onChanged,
      this.validateOnFocusChange = false,
      this.header,
      this.footer,
      this.loading,
      this.locked = false})
      : form = form..setData(initialData ?? {}, refreshState: false),
        type = "list";

  /// The type of form
  final String type;

  /// The child widgets
  final List<Widget>? children;

  /// The header widget
  final Widget? header;

  /// The footer widget
  final Widget? footer;

  /// The loading widget, defaults to skeleton
  final Widget? loading;

  /// Get the state name
  static state(String stateName) {
    return "form_$stateName";
  }

  /// Refresh the state of the form
  static stateRefresh(String stateName) {
    updateState(state(stateName), data: {
      "action": "refresh",
    });
  }

  /// Set field in the form
  static stateSetValue(String stateName, String key, dynamic value) {
    updateState(state(stateName),
        data: {"action": "setValue", "key": key, "value": value});
  }

  /// Set field in the form
  static stateSetOptions(String stateName, String key, dynamic value) {
    updateState(state(stateName),
        data: {"action": "setOptions", "key": key, "value": value});
  }

  /// Refresh the state of the form
  static stateClearData(String stateName) {
    updateState(state(stateName), data: {
      "action": "clear",
    });
  }

  /// Refresh the state of the form
  static stateRefreshForm(String stateName) {
    updateState(state(stateName), data: {
      "action": "refresh-form",
    });
  }

  /// Submit the form
  static submit(String name,
      {required Function(dynamic value) onSuccess,
      Function(Exception exception)? onFailure,
      bool showToastError = true}) {
    /// Update the state
    updateState(state(name), data: {
      "onSuccess": onSuccess,
      "onFailure": onFailure,
      "showToastError": showToastError
    });
  }

  final bool locked;
  final NyFormData form;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final bool validateOnFocusChange;
  final Function(String field, Map<String, dynamic> data)? onChanged;

  @override
  // ignore: no_logic_in_create_state
  createState() => _NyFormState(form);
}

class _NyFormState extends NyState<NyForm> {
  List<NyFormItem> _children = [];
  dynamic initialFormData;

  _NyFormState(NyFormData form) {
    stateName = "form_${form.stateName}";
  }

  @override
  void dispose() {
    super.dispose();
    widget.form.updated?.close();
  }

  bool runOnce = true;

  @override
  get init => () {
        widget.form.updated?.stream.listen((data) {
          String fieldSnakeCase = ReCase(data.$1).snakeCase;
          dynamic formData = widget.form.data(lowerCaseKeys: true);
          widget.form.onChange(fieldSnakeCase, formData);
          if (widget.onChanged != null) {
            setState(() {
              widget.onChanged!(fieldSnakeCase, formData);
            });
          }
        });

        _construct();
      };

  List<String> showableFields = [];

  /// Construct the form
  _construct() {
    NyFormStyle? nyFormStyle = Nylo.instance.getFormStyle();

    Map<String, dynamic> fields = widget.form.data();

    _children = fields.entries.map((field) {
      dynamic value = field.value;

      bool autofocus = widget.form.getAutoFocusedField == field.key;

      String? fieldStyle;
      FormCast? fieldCast;

      // check what to cast the field to
      Map<String, dynamic> casts = widget.form.getCast;

      if (casts.containsKey(field.key)) {
        fieldCast = casts[field.key];
      }

      // check if there is a style for the field
      NyTextField Function(NyTextField nyTextField)? style;
      Map<String, dynamic> styles = widget.form.getStyle;
      if (styles.containsKey(field.key)) {
        dynamic styleItem = styles[field.key];
        if (styleItem is NyTextField Function(NyTextField nyTextField)) {
          style = styleItem;
        }

        if (styleItem is String) {
          fieldStyle = styleItem;
        }
      }

      if (fieldCast == null) {
        if (value is DateTime ||
            field.value.runtimeType.toString() == "DateTime") {
          fieldCast = FormCast.datetime();
        }

        if (value is String || field.value.runtimeType.toString() == "String") {
          fieldCast = FormCast();
        }

        if (value is int || field.value.runtimeType.toString() == "int") {
          fieldCast = FormCast.number();
        }

        if (value is double || field.value.runtimeType.toString() == "double") {
          fieldCast = FormCast.number(decimal: true);
        }
      }

      fieldCast ??= FormCast();

      if (value is double || value is int) {
        value = value.toString();
      }

      String? validationRules;
      String? validationMessage;
      bool Function(dynamic value)? customValidationRule;
      Map<String, dynamic> formRules = widget.form.getValidate;
      if (formRules.containsKey(field.key)) {
        dynamic rule = formRules[field.key];
        if (rule is String) {
          validationRules = rule;
        }

        if (rule is FormValidator) {
          customValidationRule = rule.customRule;
          if (rule.customRule == null) {
            validationRules = rule.rules;
          }
          if (rule.message != null) {
            validationMessage = rule.message;
          }
        }

        if ((rule is List) && rule.isNotEmpty) {
          validationRules = rule[0];
          if (rule.length == 2) {
            validationMessage = rule[1];
          }
        }
      }

      String? dummyDataValue;
      Map<String, dynamic> dummyData = widget.form.getDummyData;
      if (dummyData.containsKey(field.key)) {
        dummyDataValue = dummyData[field.key];
        if (dummyDataValue != null) {
          widget.form
              .setFieldValue(field.key, dummyDataValue, refreshState: false);
        }
      }

      Widget? headerValue;
      Map<String, dynamic> headerData = widget.form.getHeaderData;
      if (headerData.containsKey(field.key)) {
        headerValue = headerData[field.key];
      }

      Widget? footerValue;
      Map<String, dynamic> footerData = widget.form.getFooterData;
      if (footerData.containsKey(field.key)) {
        footerValue = footerData[field.key];
      }

      Map<String, NyTextField Function(NyTextField)>? metaDataValue;
      Map<String, dynamic> metaData = widget.form.getMetaData;
      if (metaData.containsKey(field.key)) {
        metaDataValue = metaData[field.key];
      }

      bool isHidden = false;
      Map<String, dynamic> isHiddenData = widget.form.getHiddenData;
      if (isHiddenData.containsKey(field.key)) {
        isHidden = isHiddenData[field.key];
      }

      Field nyField = Field(
        field.key,
        value: value,
        cast: fieldCast,
        autofocus: autofocus,
        header: headerValue,
        footer: footerValue,
        metaData: metaDataValue,
        hidden: isHidden,
      );

      NyFormItem formItem = NyFormItem(
          field: nyField,
          validationRules: validationRules,
          validationMessage: validationMessage,
          validateOnFocusChange: widget.validateOnFocusChange,
          dummyData: dummyDataValue,
          customValidationRule: customValidationRule,
          fieldStyle: fieldStyle,
          formStyle: nyFormStyle,
          style: style,
          updated: widget.form.updated,
          onChanged: (dynamic fieldValue) {
            if (fieldValue is DateTime) {
              widget.form
                  .setFieldValue(field.key, fieldValue, refreshState: false);
              return;
            }
            widget.form
                .setFieldValue(field.key, fieldValue, refreshState: false);
          });

      return formItem;
    }).toList();
  }

  @override
  stateUpdated(dynamic data) async {
    if (data is Map && data.containsKey('action')) {
      if (data['action'] == 'refresh') {
        _construct();
        NyListView.stateReset("${stateName!}_ny_grid");
        return;
      }
      if (data['action'] == 'clear') {
        widget.form.clear(refreshState: false);
        _construct();
        NyListView.stateReset("${stateName!}_ny_grid");
        return;
      }
      if (data['action'] == 'setValue') {
        _children = _children.update((child) => child.field.name == data['key'],
            (child) {
          child.field.value = data['value'];
          return child;
        });
        _construct();
        setState(() {});
        NyListView.stateReset("${stateName!}_ny_grid");
        return;
      }

      if (data['action'] == 'setOptions') {
        _children = _children.update((child) => child.field.name == data['key'],
            (child) {
          if (child.field.cast.type == "picker") {
            child.field.cast.metaData!['options'] = data['value'];
          }
          return child;
        });
        _construct();
        setState(() {});
        NyListView.stateReset("${stateName!}_ny_grid");
        return;
      }
      if (["hideField", "showField"].contains(data['action'])) {
        String field = data['field'];

        _children =
            _children.update((child) => child.field.name == field, (child) {
          if (data['action'] == 'hideField') {
            child.field.hide();
            showableFields.remove(field);
          } else if (data['action'] == 'showField') {
            showableFields.add(field);
            child.field.show();
          }
          return child;
        });
        setState(() {});
        NyListView.stateReset("${stateName!}_ny_grid");
        return;
      }

      if (data['action'] == 'refresh-form') {
        _construct();
        initialFormData = null;
        setState(() {});
        NyListView.stateReset("${stateName!}_ny_grid");
        return;
      }
      return;
    }
    data as Map<String, dynamic>;

    // Get the rules, onSuccess and onFailure functions
    Map<String, dynamic> rules =
        data.containsKey("rules") ? data["rules"] : widget.form.getValidate;
    Function(dynamic value) onSuccess = data["onSuccess"];
    Function(Exception error)? onFailure;
    bool showToastError = data["showToastError"];
    if (data.containsKey("onFailure")) {
      onFailure = data["onFailure"];
    }

    // Update the rules with the current form data
    Map<String, dynamic> formData = widget.form.data();
    for (var field in formData.entries) {
      if (rules.containsKey(field.key)) {
        if (rules[field.key] is FormValidator) {
          FormValidator formValidator = rules[field.key];

          if (field.value is List) {
            formValidator.setData((field.value as List).join(", ").toString());
          } else {
            formValidator.setData(field.value);
          }

          rules[field.key] = formValidator;
        }
      }
    }

    // Validate the form
    validate(
      rules: rules,
      onSuccess: () {
        Map<String, dynamic> currentData =
            widget.form.data(lowerCaseKeys: true);
        onSuccess(currentData);
      },
      onFailure: (Exception exception) {
        if (onFailure == null) return;
        onFailure(exception);
      },
      showAlert: showToastError,
    );
  }

  @override
  Widget view(BuildContext context) {
    dynamic data;

    if (widget.form.getLoadData is Future Function()) {
      data = () async {
        if (initialFormData == null) {
          dynamic data = await widget.form.getLoadData!();
          initialFormData = data;
          widget.form.formReady();
          widget.form.setData(data, refreshState: false);
        }
        _construct();

        List<Widget> items = [];
        List<List<dynamic>> groupedItems = widget.form.groupedItems;
        List<NyFormItem> childrenNotHidden = _children.where((test) {
          if (test.field.hidden == false) {
            return true;
          }
          if (showableFields.contains(test.field.name)) {
            return true;
          }
          return false;
        }).toList();

        for (List<dynamic> listItems in groupedItems) {
          if (listItems.length == 1) {
            List<NyFormItem> allItems = childrenNotHidden
                .where((test) => test.field.name == listItems[0])
                .toList();
            if (allItems.isNotEmpty) {
              items.add(allItems.first);
            }
            continue;
          }

          List<Widget> childrenRowWidgets = [
            for (String action in listItems)
              (childrenNotHidden
                      .where((test) => test.field.name == action)
                      .isNotEmpty)
                  ? Flexible(
                      child: childrenNotHidden
                              .where((test) => test.field.name == action)
                              .isNotEmpty
                          ? childrenNotHidden
                              .where((test) => test.field.name == action)
                              .first
                          : const SizedBox.shrink())
                  : const SizedBox.shrink()
          ];

          Row row = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: childrenRowWidgets,
          ).withGap(childrenRowWidgets
                  .where((element) => element.runtimeType == SizedBox)
                  .isNotEmpty
              ? 0
              : widget.mainAxisSpacing);

          items.add(row);
        }

        return items;
      };
    } else {
      if (widget.form.getLoadData is Function()) {
        if (initialFormData == null) {
          initialFormData = widget.form.getLoadData!();
          widget.form.setData(widget.form.getLoadData!(), refreshState: false);
        }
        _construct();
      }
      data = () {
        List<Widget> items = [];
        List<List<dynamic>> groupedItems = widget.form.groupedItems;
        List<NyFormItem> childrenNotHidden =
            _children.where((test) => test.field.hidden == false).toList();
        for (List<dynamic> listItems in groupedItems) {
          if (listItems.length == 1) {
            List<NyFormItem> allItems = childrenNotHidden
                .where((test) => test.field.name == listItems[0])
                .toList();
            if (allItems.isNotEmpty) {
              items.add(allItems.first);
            }
            continue;
          }

          List<Widget> childrenRowWidgets = [
            for (String action in listItems)
              (childrenNotHidden
                      .where((test) => test.field.name == action)
                      .isNotEmpty)
                  ? Flexible(
                      child: childrenNotHidden
                              .where((test) => test.field.name == action)
                              .isNotEmpty
                          ? childrenNotHidden
                              .where((test) => test.field.name == action)
                              .first
                          : const SizedBox.shrink())
                  : const SizedBox.shrink()
          ];

          Row row = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: childrenRowWidgets,
          ).withGap(childrenRowWidgets
                  .where((element) => element.runtimeType == SizedBox)
                  .isNotEmpty
              ? 0
              : widget.mainAxisSpacing);

          items.add(row);
        }

        return items;
      };
      widget.form.formReady();
    }

    Widget widgetForm = IgnorePointer(
      ignoring: widget.locked,
      child: NyListView.grid(
        stateName: "${stateName!}_ny_grid",
        mainAxisSpacing: widget.crossAxisSpacing,
        crossAxisCount: 1,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        child: (context, item) => item,
        data: data,
        loadingStyle: LoadingStyle.normal(child: loadingWidget()),
      ),
    );

    if (widget.type == "list") {
      return Column(
        children: [
          if (widget.header != null) widget.header!,
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [widgetForm, ...widget.children!],
            ),
          ),
          if (widget.footer != null) widget.footer!,
        ],
      );
    }

    if (widget.header != null || widget.footer != null) {
      return Column(
        children: [
          if (widget.header != null) widget.header!,
          widgetForm,
          if (widget.footer != null) widget.footer!,
        ],
      );
    }

    return widgetForm;
  }

  /// Loading widget
  Widget loadingWidget() {
    if (widget.loading != null) {
      return widget.loading!;
    }
    List<Widget> items = [];
    List<List<dynamic>> groupedItems = widget.form.groupedItems;

    for (List<dynamic> listItems in groupedItems) {
      if (listItems.length == 1) {
        List<NyFormItem> allItems = _children
            .where((test) =>
                test.field.name == listItems[0] && test.field.hidden == false)
            .toList();
        if (allItems.isNotEmpty) {
          items.add(allItems.first);
        }
        continue;
      }

      Row row = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (String action in listItems)
            if (_children
                .where((test) =>
                    test.field.name == action && test.field.hidden == false)
                .isNotEmpty)
              Flexible(
                  child: _children
                      .where((test) =>
                          test.field.name == action &&
                          test.field.hidden == false)
                      .first),
        ],
      ).withGap(widget.mainAxisSpacing);

      items.add(row);
    }

    return Column(
      children: items,
    ).withGap(widget.crossAxisSpacing).toSkeleton();
  }
}

/// Forms class
class Forms {
  /// Create a login form
  /// This Form contains the following fields:
  /// - Email (email)
  /// - Password (password)
  static NyLoginForm login(
      {String? name,
      String? emailValidationRule = "email",
      String? emailValidationMessage,
      String? passwordValidationRule = "password_v1",
      String? passwordValidationMessage,
      bool? passwordViewable,
      String? style,
      Map<String, dynamic> dummyData = const {},
      Map<String, dynamic> initialData = const {}}) {
    return NyLoginForm(
      name: name,
      passwordValidationRule: passwordValidationRule,
      passwordValidationMessage: passwordValidationMessage,
      emailValidationRule: emailValidationRule,
      emailValidationMessage: emailValidationMessage,
      passwordViewable: passwordViewable ?? true,
      style: style ?? "compact",
    );
  }
}
