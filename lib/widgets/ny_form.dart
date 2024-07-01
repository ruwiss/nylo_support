import 'dart:async';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:nylo_support/helpers/currency_input_matcher.dart';
import 'package:nylo_support/helpers/extensions.dart';
import 'package:nylo_support/helpers/helper.dart';
import 'package:nylo_support/localization/app_localization.dart';
import 'package:nylo_support/nylo.dart';
import 'package:nylo_support/validation/ny_validator.dart';
import 'package:nylo_support/widgets/fields/form_picker.dart';
import 'package:nylo_support/widgets/ny_list_view.dart';
import 'package:nylo_support/widgets/ny_state.dart';
import 'package:nylo_support/widgets/ny_text_field.dart';
import '/forms/ny_login_form.dart';

/// TextAreaSize is an enum that helps in managing textarea sizes
enum TextAreaSize { sm, md, lg }

/// FormCast is a class that helps in managing form casts
class FormCast {
  String? type;

  FormCast({this.type = "capitalize-sentences"});

  /// Cast to a currency
  FormCast.currency(String currency) {
    this.type = "currency:$currency";
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
  FormCast.number() {
    this.type = "number";
  }

  /// Cast to phone number
  FormCast.phoneNumber() {
    this.type = "phone_number";
  }

  /// Cast to an email
  FormCast.email() {
    this.type = "email";
  }

  /// Cast to datetime
  FormCast.datetime() {
    this.type = "datetime";
  }

  /// Cast to a picker
  FormCast.picker() {
    this.type = "picker";
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
  Field(this.key, {this.value, String? selected, this.options = const []})
      : _selected = selected;

  /// The key of the field
  String key;

  /// The value of the field
  dynamic value;

  /// The selected value
  String? _selected;

  /// Options for the field
  List<dynamic> options;

  /// Get the name of the field
  String get name => key;

  /// Get the selected value
  String? get selected => _selected;

  /// Convert the [Field] to a Map
  Map<String, dynamic> toJson() {
    return {
      "key": key,
      "value": value,
      "selected": _selected,
      "options": options
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
        }
        _groupedItems.add([for (Field field in formField) field.key]);
        continue;
      }

      allData.addAll(fieldData(formField));
      _groupedItems.add([formField.key]);
    }

    this.setData(allData);
    if (getEnv('APP_ENV') != 'developing') {
      return;
    }
    Map<String, dynamic> dummyData = this.dummyData();
    dummyData.entries.forEach((data) {
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

  /// The options for the form
  Map<String, List<dynamic>> _options = {};

  /// The selected value for the form
  Map<String, String?> _selected = {};

  /// Get the grouped items for the form
  List<List> get groupedItems => _groupedItems;

  /// Get the grouped items for the form
  Map<String, List<dynamic>> get options => _options;

  /// StreamController for the form
  final StreamController<dynamic>? updated = StreamController<dynamic>();

  /// Validate the form
  Map<String, dynamic> validate() => {};

  /// Returns the fields for the form
  dynamic fields() => {};

  /// Returns the cast for the form
  Map<String, dynamic> cast() => {};

  /// Returns the dummy data for the form
  Map<String, dynamic> dummyData() => {};

  /// Returns the style for the form
  Map<String, dynamic> style() => {};

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

  /// Set the selected value for the form
  setSelected(Map<String, String> selected) {
    _selected = selected;
  }

  /// Check if the form passes validation
  bool isValid() {
    Map<String, dynamic> rules = validate();

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
    dynamic selectedValue =
        json.containsKey("selected") ? json["selected"] : null;
    dynamic value = json["value"];
    if (value is List) {
      _options[json["key"]] = value;
      value = null;
    }
    _selected[json["key"]] =
        json.containsKey("selected") ? json["selected"] : null;
    return {json["key"]: selectedValue ??= value};
  }

  /// Returns the data for the form
  /// If a [key] is provided, it will return the data for that key
  dynamic data({String? key}) {
    if (key != null && _data.containsKey(key)) {
      return _data[key];
    }
    return _data;
  }

  /// Returns the selected value for the form
  dynamic getSelected({String? key}) {
    if (key == null) {
      return _selected.values;
    }
    if (_selected.containsKey(key)) {
      return _selected[key];
    }
    return null;
  }

  /// Returns the options for the form
  dynamic getOptions({String? key}) {
    if (key == null) {
      return _options.values;
    }
    if (_options.containsKey(key)) {
      return _options[key];
    }
    return [];
  }

  /// Submit the form
  /// If the form is valid, it will call the [onSuccess] function
  submit(
      {required Function(dynamic value) onSuccess,
      Function(Exception exception)? onFailure,
      bool showToastError = true}) {
    Map<String, dynamic> rules = validate();
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
      this.fieldType,
      this.style,
      this.updated,
      this.autoFocusField});

  final Field field;
  final String? validationRules;
  final String? validationMessage;
  final String? dummyData;
  final String? fieldStyle;
  final String? fieldType;
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

    if (fieldType != null &&
        !([
          "datetime",
          "text",
          "email",
          "password",
          "password:viewable",
          "textarea",
          "textarea:sm",
          "textarea:md",
          "textarea:lg",
          "number",
          "phone_number",
          ...[
            for (String currency in CurrencyInputMatcher.currencies)
              "currency:$currency"
          ],
          "capitalize-words",
          "capitalize-sentences",
          "uppercase",
          "lowercase",
        ].contains(fieldType))) {
      // check if field exists on Nylo instance
      Map<String, dynamic> nyloFormTypes = Nylo.instance.getFormCasts();
      if (nyloFormTypes.containsKey(fieldType)) {
        return nyloFormTypes[fieldType]!(field, onChanged);
      }
    }

    // check if the field is a datetime field
    if (fieldType == "datetime") {
      return DateTimeFormField(
        decoration: InputDecoration(
          labelText: 'Enter Date'.tr(),
        ),
        dateFormat: DateFormat.yMd(),
        mode: DateTimeFieldPickerMode.date,
        firstDate: DateTime(1950, 8, 31),
        lastDate: DateTime.now().add(Duration(days: 365)),
        initialPickerDateTime: DateTime.now(),
        onChanged: onChanged,
      );
    }

    // check if the field is a picker field
    if (fieldType == "picker") {
      return NyFormPicker.fromField(
        field,
        onChanged,
      );
    }

    TextCapitalization textCapitalization = TextCapitalization.none;
    switch (fieldType) {
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
              ((fieldType ?? "").contains("currency")) ? null : onChanged,
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
            onChanged:
                ((fieldType ?? "").contains("currency")) ? null : onChanged,
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
    if (fieldType == "email") {
      nyTextField = nyTextField.copyWith(type: "email-address");
    }

    // check if the field is a password field
    if ((fieldType ?? "").contains("password")) {
      nyTextField = nyTextField.copyWith(
        type: "password",
        passwordViewable: (fieldType ?? "").contains("viewable"),
      );
    }

    // check if the field is a textarea field
    if ((fieldType ?? "").contains("textarea")) {
      nyTextField = nyTextField.copyWith(
        minLines: match(
            fieldType,
            () => {
                  "textarea": 1,
                  "textarea:sm": 2,
                  "textarea:md": 3,
                  "textarea:lg": 5
                },
            defaultValue: 1),
        maxLines: match(
            fieldType,
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
        if (fieldType == "capitalize-words") {
          value = value?.split(" ").map((String word) {
            if (word.isEmpty) return word;
            return word[0].toUpperCase() + word.substring(1);
          }).join(" ");
        }

        if (fieldType == "capitalize-sentences") {
          value = value?.split(".").map((String word) {
            if (word.isEmpty) return word;
            return word[0].toUpperCase() + word.substring(1);
          }).join(".");
        }

        if (fieldType == "uppercase") {
          value = value?.toUpperCase();
        }

        if (fieldType == "lowercase") {
          value = value?.toLowerCase();
        }

        if (!((fieldType ?? "").contains("currency"))) {
          onChanged(value);
        }
      },
    );

    // check if the field is a currency field
    if (fieldType?.contains("currency") ?? false) {
      CurrencyMeta currencyMeta = CurrencyInputMatcher.getCurrencyMeta(
          fieldType!,
          value: field.value ?? "0",
          onChanged: onChanged);
      textEditingController.text = currencyMeta.initialValue;
      nyTextField = nyTextField.copyWith(
        onChanged: null,
        inputFormatters: [
          currencyMeta.formatter,
        ],
      );
    }

    // check if the field is a phone number field
    if (fieldType == "phone_number") {
      nyTextField = nyTextField.copyWith(
        keyboardType: TextInputType.phone,
        inputFormatters: [PhoneInputFormatter()],
        onChanged: onChanged,
      );
    }

    // check if the field is a number field
    if (fieldType == "number") {
      nyTextField = nyTextField.copyWith(type: "number");
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
      String? fieldType = null;

      // check what to cast the field to
      Map<String, dynamic> casts = widget.form.cast();

      if (casts.containsKey(field.key)) {
        dynamic cast = casts[field.key];
        if (cast is FormCast) {
          fieldType = cast.type;
        } else {
          fieldType = cast;
        }
      }

      // check if there is a style for the field
      NyTextField Function(NyTextField nyTextField)? style;
      Map<String, dynamic> styles = widget.form.style();
      if (styles.containsKey(field.key)) {
        dynamic styleItem = styles[field.key];
        if (styleItem is NyTextField Function(NyTextField nyTextField)) {
          style = styleItem;
        }

        if (styleItem is String) {
          fieldStyle = styleItem;
        }
      }

      if (fieldType == null) {
        if (value is DateTime ||
            field.value.runtimeType.toString() == "DateTime") {
          fieldType = "datetime";
        }

        if (value is String || field.value.runtimeType.toString() == "String") {
          fieldType = "text";
        }

        if (value is int || field.value.runtimeType.toString() == "int") {
          fieldType = "number";
        }

        if (value is double || field.value.runtimeType.toString() == "double") {
          fieldType = "number";
        }
      }

      if (fieldType == null) {
        fieldType = "text";
      }

      if (value is double || value is int) {
        value = value.toString();
      }

      String? validationRules = null;
      String? validationMessage = null;
      Map<String, dynamic> formRules = widget.form.validate();
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
      Map<String, dynamic> dummyData = widget.form.dummyData();
      if (dummyData.containsKey(field.key)) {
        dummyDataValue = dummyData[field.key];
        widget.form.setField(field.key, dummyDataValue);
      }

      Field nyField = Field(field.key,
          value: value,
          selected: widget.form.getSelected(key: field.key),
          options: widget.form.getOptions(key: field.key));

      NyFormItem formItem = NyFormItem(
          field: nyField,
          validationRules: validationRules,
          validationMessage: validationMessage,
          validateOnFocusChange: widget.validateOnFocusChange,
          dummyData: dummyDataValue,
          fieldType: fieldType,
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
        data.containsKey("rules") ? data["rules"] : widget.form.validate();
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
