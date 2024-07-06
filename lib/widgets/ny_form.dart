import 'dart:async';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import '/helpers/currency_input_matcher.dart';
import '/helpers/extensions.dart';
import '/helpers/helper.dart';
import '/nylo.dart';
import '/validation/ny_validator.dart';
import '/widgets/fields/form_date_time_picker.dart';
import '/widgets/fields/form_picker.dart';
import '/widgets/ny_list_view.dart';
import '/widgets/ny_state.dart';
import '/widgets/ny_text_field.dart';
import '/forms/ny_login_form.dart';
import 'fields/form_checkbox.dart';

/// TextAreaSize is an enum that helps in managing textarea sizes
enum TextAreaSize { sm, md, lg }

/// FormCast is a class that helps in managing form casts
class FormCast {
  String? type;
  dynamic metaData;

  FormCast({this.type = "capitalize-sentences"});

  /// Cast to text
  FormCast.text() {
    this.type = "text";
  }

  /// Cast to a currency
  FormCast.currency(String currency) {
    this.type = "currency:$currency";
  }

  /// Cast to a checkbox
  FormCast.checkbox({
    MouseCursor? mouseCursor,
    Color? activeColor,
    Color? fillColor,
    Color? checkColor,
    Color? hoverColor,
    Color? overlayColor,
    double? splashRadius,
    MaterialTapTargetSize? materialTapTargetSize,
    VisualDensity? visualDensity,
    FocusNode? focusNode,
    bool autofocus = false,
    ShapeBorder? shape,
    BorderSide? side,
    bool isError = false,
    bool? enabled,
    Color? tileColor,
    Widget? title,
    Widget? subtitle,
    bool isThreeLine = false,
    bool? dense,
    Widget? secondary,
    bool selected = false,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.platform,
    EdgeInsetsGeometry? contentPadding,
    bool tristate = false,
    ShapeBorder? checkboxShape,
    Color? selectedTileColor,
    ValueChanged<bool?>? onFocusChange,
    bool? enableFeedback,
    String? checkboxSemanticLabel,
  }) {
    this.type = "checkbox";
    this.metaData = {};
    this.metaData['mouseCursor'] = mouseCursor;
    this.metaData['activeColor'] = activeColor;
    this.metaData['fillColor'] = fillColor;
    this.metaData['checkColor'] = checkColor;
    this.metaData['hoverColor'] = hoverColor;
    this.metaData['overlayColor'] = overlayColor;
    this.metaData['splashRadius'] = splashRadius;
    this.metaData['materialTapTargetSize'] = materialTapTargetSize;
    this.metaData['visualDensity'] = visualDensity;
    this.metaData['focusNode'] = focusNode;
    this.metaData['autofocus'] = autofocus;
    this.metaData['shape'] = shape;
    this.metaData['side'] = side;
    this.metaData['isError'] = isError;
    this.metaData['enabled'] = enabled;
    this.metaData['tileColor'] = tileColor;
    this.metaData['title'] = title;
    this.metaData['subtitle'] = subtitle;
    this.metaData['isThreeLine'] = isThreeLine;
    this.metaData['dense'] = dense;
    this.metaData['secondary'] = secondary;
    this.metaData['selected'] = selected;
    this.metaData['controlAffinity'] = controlAffinity;
    this.metaData['contentPadding'] = contentPadding;
    this.metaData['tristate'] = tristate;
    this.metaData['checkboxShape'] = checkboxShape;
    this.metaData['selectedTileColor'] = selectedTileColor;
    this.metaData['onFocusChange'] = onFocusChange;
    this.metaData['enableFeedback'] = enableFeedback;
    this.metaData['checkboxSemanticLabel'] = checkboxSemanticLabel;
  }

  /// Cast to capitalize words
  FormCast.capitalizeWords() {
    this.type = "capitalize-words";
  }

  /// Cast to capitalize sentences
  FormCast.capitalizeSentences() {
    this.type = "capitalize-sentences";
  }

  /// Cast to a number
  FormCast.number({bool decimal = false}) {
    this.type = "number";
    if (decimal) {
      this.type = "number:decimal";
    }
  }

  /// Cast to phone number
  FormCast.phoneNumber() {
    this.type = "phone_number";
  }

  /// Cast to an email
  FormCast.email() {
    this.type = "email";
  }

  /// Cast to a url
  FormCast.url() {
    this.type = "url";
  }

  /// Cast to datetime
  FormCast.datetime({
    TextStyle? style,
    VoidCallback? onTap,
    FocusNode? focusNode,
    bool autofocus = false,
    bool? enableFeedback,
    EdgeInsetsGeometry? padding,
    bool hideDefaultSuffixIcon = false,
    DateTime? initialPickerDateTime,
    CupertinoDatePickerOptions? cupertinoDatePickerOptions,
    MaterialDatePickerOptions? materialDatePickerOptions,
    MaterialTimePickerOptions? materialTimePickerOptions,
    InputDecoration? decoration,
    DateFormat? dateFormat,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTimeFieldPickerMode mode = DateTimeFieldPickerMode.dateAndTime,
    DateTimeFieldPickerPlatform pickerPlatform =
        DateTimeFieldPickerPlatform.adaptive,
  }) {
    this.type = "datetime";
    this.metaData = {};
    this.metaData['style'] = style;
    this.metaData['onTap'] = onTap;
    this.metaData['focusNode'] = focusNode;
    this.metaData['autofocus'] = autofocus;
    this.metaData['enableFeedback'] = enableFeedback;
    this.metaData['padding'] = padding;
    this.metaData['hideDefaultSuffixIcon'] = hideDefaultSuffixIcon;
    this.metaData['initialPickerDateTime'] = initialPickerDateTime;
    this.metaData['cupertinoDatePickerOptions'] = cupertinoDatePickerOptions;
    this.metaData['materialDatePickerOptions'] = materialDatePickerOptions;
    this.metaData['materialTimePickerOptions'] = materialTimePickerOptions;
    this.metaData['decoration'] = decoration;
    this.metaData['dateFormat'] = dateFormat;
    this.metaData['firstDate'] = firstDate;
    this.metaData['lastDate'] = lastDate;
    this.metaData['mode'] = mode;
    this.metaData['pickerPlatform'] = pickerPlatform;
  }

  /// Cast to a picker
  FormCast.picker({required List<dynamic> options}) {
    this.type = "picker";
    this.metaData = {};
    this.metaData['options'] = options;
  }

  /// Cast to a textarea
  FormCast.textArea({TextAreaSize textAreaSize = TextAreaSize.sm}) {
    String size = "sm";
    if (textAreaSize == TextAreaSize.md) {
      size = "md";
    }
    if (textAreaSize == TextAreaSize.lg) {
      size = "lg";
    }

    this.type = "textarea:$size";
  }

  /// Cast to uppercase
  FormCast.uppercase() {
    this.type = "uppercase";
  }

  /// Cast to uppercase
  FormCast.lowercase() {
    this.type = "lowercase";
  }

  /// Cast to a password
  FormCast.password({bool viewable = false}) {
    this.type = "password";
    if (viewable) {
      this.type = "password:viewable";
    }
  }
}

/// Field is a class that helps in managing form fields
class Field {
  Field(this.key,
      {this.value,
      FormCast? cast,
      this.validate,
      this.autofocus = false,
      this.dummyData,
      this.style})
      : cast = cast ?? FormCast();

  /// The key of the field
  String key;

  /// The value of the field
  dynamic value;

  /// The cast for the field
  FormCast cast;

  /// The validator for the field
  FormValidator? validate;

  /// The autofocus for the field
  bool autofocus;

  /// The dummy data for the field
  String? dummyData;

  /// The style for the field
  String? style;

  /// Get the name of the field
  String get name => key;

  /// Convert the [Field] to a Map
  Map<String, dynamic> toJson() {
    return {
      "key": key,
      "value": value,
    };
  }
}

/// FormValidator is a class that helps in managing form validation
/// It is used in the [NyFormData] class
/// Example:
/// ```dart
/// class RegisterForm extends NyFormData {
///
///  @override
///   Map<String, dynamic> validate() => {
///     "Email": FormValidator("email", message: "Invalid email")
///   };
///```
class FormValidator {
  String? data;
  dynamic rules;
  String? message;

  FormValidator(this.rules, {this.message, this.data});

  /// Validate a password with a strength of 1 or 2
  /// [strength] 1: 1 uppercased letter, 1 digit, 8 characters
  /// [strength] 2: 1 uppercased letter, 1 digit, 1 special character, 8 characters
  /// [message] The message to display if the password is invalid
  FormValidator.password({int strength = 1, this.message}) {
    assert(strength > 0 && strength < 3,
        "Password strength must be between 1 and 2");
    this.rules = "password_v$strength";
  }

  /// Set the data for the form validator
  setData(dynamic data) {
    if (data is List) {
      this.data = data.join(", ").toString();
      return;
    }
    if (data is double) {
      this.data = data.toString();
      return;
    }
    if (data is int) {
      this.data = data.toString();
      return;
    }
    this.data = data == null ? "" : data;
  }

  /// Transform the [FormValidator] into a validation rule
  List toValidationRule() {
    List listData = [data, rules];
    if (message != null) {
      listData.add(message);
    }
    return listData;
  }
}

/// NyFormData is a class that helps in managing form data
class NyFormData {
  NyFormData(String name) {
    this.name = name;
    dynamic formFields = fields();

    Map<String, dynamic> allData = {};
    for (dynamic formField in formFields) {
      if (formField is List) {
        for (Field field in formField) {
          allData.addAll(fieldData(field));
          _cast[field.key] = field.cast;
          _validate[field.key] = field.validate;
          _dummyData[field.key] = field.dummyData;
          _style[field.key] = field.style;
        }
        _groupedItems.add([for (Field field in formField) field.key]);
        continue;
      }

      if (!(formField is Field)) {
        continue;
      }

      allData.addAll(fieldData(formField));
      _groupedItems.add([formField.key]);

      Map<String, dynamic> formCast = cast();
      Map<String, dynamic> formValidate = validate();
      Map<String, dynamic> formDummyData = dummyData();
      Map<String, dynamic> formStyle = style();

      _cast[formField.key] = formField.cast;

      formCast.entries
          .where((test) => test.key == formField.key)
          .forEach((cast) {
        _cast[formField.key] = cast.value;
      });

      // Check if the field has a validate
      if (formField.validate != null) {
        _validate[formField.key] = formField.validate;
      }
      formValidate.entries
          .where((test) => test.key == formField.key)
          .forEach((validate) {
        _validate[formField.key] = validate.value;
      });

      // Check if the field has a dummy data
      if (formField.dummyData != null) {
        _dummyData[formField.key] = formField.dummyData;
      }
      formDummyData.entries
          .where((test) => test.key == formField.key)
          .forEach((dummyData) {
        _dummyData[formField.key] = dummyData.value;
      });

      // Check if the field has a style
      if (formField.style != null) {
        _style[formField.key] = formField.style;
      }
      formStyle.entries
          .where((test) => test.key == formField.key)
          .forEach((style) {
        _style[formField.key] = style.value;
      });
    }

    this.setData(allData);
    if (getEnv('APP_ENV') != 'developing') {
      return;
    }
    Map<String, dynamic> allDummyData = this.getDummyData;
    allDummyData.entries.forEach((data) {
      if (data.value != null) {
        this.setField(data.key, data.value);
      }
    });
  }

  /// The name of the form
  String? name;

  /// Returns the state name for the form
  String get stateName => "form_" + name!;

  /// The data for the form
  Map<String, dynamic> _data = {};

  /// The grouped items for the form
  List<List> _groupedItems = [];

  /// The cast for the form
  Map<String, FormCast?> _cast = {};

  /// The validator for the form
  Map<String, FormValidator?> _validate = {};

  /// The dummy data for the form
  Map<String, String?> _dummyData = {};

  /// The style for the form
  Map<String, String?> _style = {};

  /// Get the grouped items for the form
  List<List> get groupedItems => _groupedItems;

  /// Get the cast data for the form
  Map<String, FormCast?> get getCast => _cast;

  /// Get the validate data for the form
  Map<String, FormValidator?> get getValidate => _validate;

  /// Get the dummy data for the form
  Map<String, String?> get getDummyData => _dummyData;

  /// Get the style data for the form
  Map<String, String?> get getStyle => _style;

  /// StreamController for the form
  final StreamController<dynamic>? updated = StreamController<dynamic>();

  /// Validate the form
  Map<String, dynamic> validate() => _validate;

  /// Returns the fields for the form
  dynamic fields() => {};

  /// Returns the cast for the form
  Map<String, dynamic> cast() => _cast;

  /// Returns the dummy data for the form
  Map<String, dynamic> dummyData() => _dummyData;

  /// Returns the style for the form
  Map<String, dynamic> style() => _style;

  /// Set the value for a field in the form
  /// If the field does not exist, it will throw an exception
  setField(String key, dynamic value) {
    if (!_data.containsKey(key)) {
      throw Exception("Field $key does not exist in the form");
    }
    _data[key] = value;
  }

  /// Set the data for the form
  setData(Map<String, dynamic> data) {
    _data = data;
  }

  /// Check if the form passes validation
  bool isValid() {
    Map<String, dynamic> rules = getValidate;

    Map<String, dynamic> ruleMap = {};
    Map<String, dynamic> dataMap = {};

    rules.entries.forEach((rule) {
      dynamic item = data(key: rule.key);
      if (rule.value is FormValidator) {
        rule.value.setData(item);
        dataMap[rule.key] = item is List ? item.join(", ") : item;
        ruleMap[rule.key] = rule.value.toValidationRule();
      } else {
        dataMap[rule.key] = data(key: rule.key);
        ruleMap[rule.key] = rule.value;
      }
    });

    return NyValidator.isSuccessful(rules: ruleMap, data: dataMap);
  }

  /// Get the data for a field
  Map<String, dynamic> fieldData(Field field) {
    Map<String, dynamic> json = field.toJson();

    return {json["key"]: json["value"]};
  }

  /// Returns the data for the form
  /// If a [key] is provided, it will return the data for that key
  dynamic data({String? key}) {
    if (key != null && _data.containsKey(key)) {
      return _data[key];
    }
    return _data;
  }

  /// Submit the form
  /// If the form is valid, it will call the [onSuccess] function
  submit(
      {required Function(dynamic value) onSuccess,
      Function(Exception exception)? onFailure,
      bool showToastError = true}) {
    Map<String, dynamic> rules = getValidate;
    if (rules.isEmpty) {
      onSuccess(data());
      return;
    }

    /// Update the state with the rules and the onSuccess function
    updateState(stateName, data: {
      "onSuccess": onSuccess,
      "onFailure": onFailure,
      "showToastError": showToastError
    });
  }

  /// Check if a field exists in the form
  bool hasField(String fieldKey) {
    return _data.containsKey(fieldKey);
  }
}

/// NyFormItem is a class that helps in managing form items
class NyFormItem extends StatelessWidget {
  NyFormItem(
      {super.key,
      required this.field,
      this.validationRules,
      this.validationMessage,
      this.dummyData,
      this.validateOnFocusChange = false,
      this.onChanged,
      this.fieldStyle,
      this.style,
      this.updated,
      this.autoFocusField});

  final Field field;
  final String? validationRules;
  final String? validationMessage;
  final String? dummyData;
  final String? fieldStyle;
  final String? autoFocusField;
  final TextEditingController controller = TextEditingController();
  final Function(dynamic value)? onChanged;
  final NyTextField Function(NyTextField nyTextField)? style;
  final bool validateOnFocusChange;

  /// Returns the textEditingController for the form item
  TextEditingController get textEditingController {
    if (field.value is List) {
      controller.text = field.value.join(", ");
      return controller;
    }
    controller.text = field.value ?? "";
    return controller;
  }

  final StreamController<dynamic>? updated;

  @override
  Widget build(BuildContext context) {
    Function(dynamic value)? onChanged = (dynamic value) {
      updated?.add(value);
      this.onChanged!(value);
    };

    if (!([
      "datetime",
      "text",
      "url",
      "email",
      "checkbox",
      "password",
      "password:viewable",
      "textarea",
      "textarea:sm",
      "textarea:md",
      "textarea:lg",
      "number",
      "number:decimal",
      "phone_number",
      ...[
        for (String currency in CurrencyInputMatcher.currencies)
          "currency:$currency"
      ],
      "capitalize-words",
      "capitalize-sentences",
      "uppercase",
      "lowercase",
    ].contains(field.cast.type))) {
      // check if field exists on Nylo instance
      Map<String, dynamic> nyloFormTypes = Nylo.instance.getFormCasts();
      if (nyloFormTypes.containsKey(field.cast.type)) {
        return nyloFormTypes[field.cast.type]!(field, onChanged);
      }
    }

    // check if the field is a datetime field
    if (field.cast.type == "datetime") {
      return NyFormDateTimePicker.fromField(
        field,
        onChanged,
      );
    }

    // check if the field is a picker field
    if (field.cast.type == "picker") {
      return NyFormPicker.fromField(
        field,
        onChanged,
      );
    }

    // check if the field is a checkbox field
    if (field.cast.type == "checkbox") {
      return NyFormCheckbox.fromField(
        field,
        onChanged,
      );
    }

    TextCapitalization textCapitalization = TextCapitalization.none;
    switch (field.cast.type) {
      case "capitalize-words":
        textCapitalization = TextCapitalization.words;
        break;
      case "capitalize-sentences":
        textCapitalization = TextCapitalization.sentences;
        break;
      case "uppercase":
        textCapitalization = TextCapitalization.characters;
        break;
      case "lowercase":
        textCapitalization = TextCapitalization.none;
        break;
      default:
        textCapitalization = TextCapitalization.none;
        break;
    }

    NyTextField? nyTextField;

    switch (fieldStyle) {
      case "compact":
        nyTextField = NyTextField.compact(
          controller: textEditingController,
          hintText: field.name,
          textCapitalization: textCapitalization,
          onChanged:
              ((field.cast.type ?? "").contains("currency")) ? null : onChanged,
          autoFocus: autoFocusField == field.name,
          validationRules: validationRules,
          validationErrorMessage: validationMessage,
          validateOnFocusChange: validateOnFocusChange,
          dummyData: dummyData,
        );
        break;
      default:
        {
          nyTextField = NyTextField(
            controller: textEditingController,
            hintText: field.name,
            textCapitalization: textCapitalization,
            onChanged: ((field.cast.type ?? "").contains("currency"))
                ? null
                : onChanged,
            autoFocus: autoFocusField == field.name,
            validationRules: validationRules,
            validateOnFocusChange: validateOnFocusChange,
            dummyData: dummyData,
          );
        }
    }

    // check if the field has a style
    if (style != null) {
      return style!(nyTextField);
    }

    // check if the field is an email field
    if (field.cast.type == "email") {
      nyTextField = nyTextField.copyWith(
          type: "email-address", keyboardType: TextInputType.emailAddress);
    }

    // check if the field is a password field
    if ((field.cast.type ?? "").contains("password")) {
      nyTextField = nyTextField.copyWith(
        type: "password",
        obscureText: true,
        keyboardType: (field.cast.type ?? "").contains("viewable")
            ? TextInputType.visiblePassword
            : TextInputType.text,
        passwordViewable: (field.cast.type ?? "").contains("viewable"),
      );
    }

    // check if the field is a textarea field
    if ((field.cast.type ?? "").contains("textarea")) {
      nyTextField = nyTextField.copyWith(
        minLines: match(
            field.cast.type,
            () => {
                  "textarea": 1,
                  "textarea:sm": 2,
                  "textarea:md": 3,
                  "textarea:lg": 5
                },
            defaultValue: 1),
        maxLines: match(
            field.cast.type,
            () => {
                  "textarea": 3,
                  "textarea:sm": 4,
                  "textarea:md": 5,
                  "textarea:lg": 7
                },
            defaultValue: 3),
        keyboardType: TextInputType.multiline,
      );
    }

    // Update the nyTextField onChanged function
    nyTextField = nyTextField.copyWith(
      onChanged: (String? value) {
        if (field.cast.type == "capitalize-words") {
          value = value?.split(" ").map((String word) {
            if (word.isEmpty) return word;
            return word[0].toUpperCase() + word.substring(1);
          }).join(" ");
        }

        if (field.cast.type == "capitalize-sentences") {
          value = value?.split(".").map((String word) {
            if (word.isEmpty) return word;
            return word[0].toUpperCase() + word.substring(1);
          }).join(".");
        }

        if (field.cast.type == "uppercase") {
          value = value?.toUpperCase();
        }

        if (field.cast.type == "lowercase") {
          value = value?.toLowerCase();
        }

        if (!((field.cast.type ?? "").contains("currency"))) {
          onChanged(value);
        }
      },
    );

    // check if the field is a currency field
    if (field.cast.type?.contains("currency") ?? false) {
      CurrencyMeta currencyMeta = CurrencyInputMatcher.getCurrencyMeta(
          field.cast.type!,
          value: field.value ?? "0",
          onChanged: onChanged);
      textEditingController.text = currencyMeta.initialValue;
      nyTextField = nyTextField.copyWith(
        onChanged: null,
        type: fieldStyle,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          currencyMeta.formatter,
        ],
      );
    }

    // check if the field is a phone number field
    if (field.cast.type == "phone_number") {
      nyTextField = nyTextField.copyWith(
        keyboardType: TextInputType.phone,
        inputFormatters: [PhoneInputFormatter()],
        onChanged: onChanged,
      );
    }

    // check if the field is a number field
    if (field.cast.type == "url") {
      nyTextField = nyTextField.copyWith(
          type: fieldStyle, keyboardType: TextInputType.url);
    }

    // check if the field is a number field
    if (field.cast.type == "number") {
      nyTextField = nyTextField.copyWith(
          type: fieldStyle, keyboardType: TextInputType.number);
    }

    // check if the field is a number field
    if (field.cast.type == "number:decimal") {
      nyTextField = nyTextField.copyWith(
          type: fieldStyle,
          keyboardType: TextInputType.numberWithOptions(decimal: true));
    }

    return nyTextField;
  }
}

/// NyForm is a class that helps in managing forms
class NyForm extends StatefulWidget {
  const NyForm(
      {super.key,
      required this.form,
      this.crossAxisSpacing = 10,
      this.mainAxisSpacing = 10,
      this.onChanged,
      this.validateOnFocusChange = false,
      this.locked = false});

  /// Create a login form
  NyForm.login(
      {required name,
      this.crossAxisSpacing = 10,
      this.mainAxisSpacing = 10,
      this.onChanged,
      this.validateOnFocusChange = false,
      this.locked = false,
      String? emailValidationRule,
      String? emailValidationMessage,
      String? passwordValidationRule,
      String? passwordValidationMessage,
      bool? passwordViewable,
      String? style,
      Map<String, dynamic> dummyData = const {}})
      : form = NyLoginForm(
            name: name,
            passwordValidationRule: passwordValidationRule,
            passwordValidationMessage: passwordValidationMessage,
            emailValidationRule: emailValidationRule,
            emailValidationMessage: emailValidationMessage,
            passwordViewable: passwordViewable ?? true,
            style: style ?? "compact",
            dummyData: dummyData);

  /// Submit the form
  static submit(String name,
      {required Function(dynamic value) onSuccess,
      Function(Exception exception)? onFailure,
      bool showToastError = true}) {
    /// Update the state
    updateState("form_" + name, data: {
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
  final Function(Map<String, dynamic> data)? onChanged;

  @override
  createState() => _NyFormState(form);
}

class _NyFormState extends NyState<NyForm> {
  List<NyFormItem> _children = [];

  _NyFormState(NyFormData form) {
    stateName = form.stateName;
  }

  @override
  void dispose() {
    super.dispose();
    widget.form.updated?.close();
  }

  @override
  initState() {
    super.initState();
    widget.form.updated?.stream.listen((data) {
      if (widget.onChanged != null) {
        setState(() {
          widget.onChanged!(widget.form.data());
        });
      }
    });

    Map<String, dynamic> fields = widget.form.data();
    _children = fields.entries.map((field) {
      dynamic value = field.value;

      String? fieldStyle = null;
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

      if (fieldCast == null) {
        fieldCast = FormCast();
      }

      if (value is double || value is int) {
        value = value.toString();
      }

      String? validationRules = null;
      String? validationMessage = null;
      Map<String, dynamic> formRules = widget.form.getValidate;
      if (formRules.containsKey(field.key)) {
        dynamic rule = formRules[field.key];
        if (rule is String) {
          validationRules = rule;
        }

        if (rule is FormValidator) {
          validationRules = rule.rules;
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

      String? dummyDataValue = null;
      Map<String, dynamic> dummyData = widget.form.getDummyData;
      if (dummyData.containsKey(field.key)) {
        dummyDataValue = dummyData[field.key];
        widget.form.setField(field.key, dummyDataValue);
      }

      Field nyField = Field(field.key, value: value, cast: fieldCast);

      NyFormItem formItem = NyFormItem(
          field: nyField,
          validationRules: validationRules,
          validationMessage: validationMessage,
          validateOnFocusChange: widget.validateOnFocusChange,
          dummyData: dummyDataValue,
          fieldStyle: fieldStyle,
          style: style,
          updated: widget.form.updated,
          onChanged: (dynamic fieldValue) {
            if (fieldValue is DateTime) {
              widget.form.setField(field.key, fieldValue);
              return;
            }
            widget.form.setField(field.key, fieldValue);
          });

      return formItem;
    }).toList();
  }

  @override
  stateUpdated(dynamic data) async {
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
    formData.entries.forEach((field) {
      if (rules.containsKey(field.key)) {
        if (rules[field.key] is FormValidator) {
          FormValidator formValidator = rules[field.key];
          if (field.value is List) {
            formValidator.setData((field.value as List).join(", ").toString());
          } else {
            formValidator.setData(field.value);
          }

          rules[field.key] = formValidator;
        } else {
          rules[field.key] = [field.value, rules[field.key]];
        }
      }
    });

    // Validate the form
    validate(
      rules: rules,
      onSuccess: () {
        onSuccess(widget.form.data());
      },
      onFailure: (Exception exception) {
        if (onFailure == null) return;
        onFailure(exception);
      },
      showAlert: showToastError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.locked,
      child: NyListView.grid(
        mainAxisSpacing: widget.crossAxisSpacing,
        crossAxisCount: 1,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        child: (context, item) => item,
        data: () async {
          List<Widget> items = [];
          List<List<dynamic>> groupedItems = widget.form.groupedItems;

          for (List<dynamic> listItems in groupedItems) {
            if (listItems.length == 1) {
              items.add(_children
                  .where((test) => test.field.name == listItems[0])
                  .first);
              continue;
            }

            Row row = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (String action in listItems)
                  Flexible(
                      child: _children
                          .where((test) => test.field.name == action)
                          .first),
              ],
            ).withGap(widget.mainAxisSpacing);

            items.add(row);
          }

          return items;
        },
        loading: SizedBox.shrink(),
      ),
    );
  }
}
