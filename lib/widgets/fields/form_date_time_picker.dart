import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nylo_support/widgets/ny_form.dart';
import '/helpers/helper.dart';

/// A [NyFormDateTimePicker] widget for Form Fields
class NyFormDateTimePicker extends StatefulWidget {
  /// Creates a [NyFormDateTimePicker] widget
  NyFormDateTimePicker(
      {required String name,
      String? value,
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
      Function(dynamic value)? onChanged})
      : field = Field(name, value: value)
          ..cast = FormCast.datetime(
            style: style,
            onTap: onTap,
            focusNode: focusNode,
            autofocus: autofocus,
            enableFeedback: enableFeedback,
            padding: padding,
            hideDefaultSuffixIcon: hideDefaultSuffixIcon,
            initialPickerDateTime: initialPickerDateTime,
            cupertinoDatePickerOptions: cupertinoDatePickerOptions,
            materialDatePickerOptions: materialDatePickerOptions,
            materialTimePickerOptions: materialTimePickerOptions,
            decoration: decoration,
            dateFormat: dateFormat,
            firstDate: firstDate,
            lastDate: lastDate,
            mode: mode,
            pickerPlatform: pickerPlatform,
          ),
        onChanged = onChanged;

  /// Creates a [NyFormDateTimePicker] widget from a [Field]
  NyFormDateTimePicker.fromField(
      Field field, Function(dynamic value)? onChanged,
      {super.key})
      : field = field,
        onChanged = onChanged;

  /// The field to be rendered
  final Field field;

  /// The callback function to be called when the value changes
  final Function(dynamic value)? onChanged;

  @override
  createState() => _NyFormDateTimePickerState();
}

class _NyFormDateTimePickerState extends State<NyFormDateTimePicker> {
  dynamic currentValue;

  @override
  void initState() {
    super.initState();
    dynamic fieldValue = widget.field.value;

    if (fieldValue is String && fieldValue.isNotEmpty) {
      try {
        currentValue = DateTime.parse(fieldValue);
      } on Exception catch (e) {
        dump(e);
      }
    }

    if (fieldValue is DateTime) {
      currentValue = fieldValue;
    }

    if (currentValue == null) {
      currentValue = getMetaData('firstDate') ?? DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DateTimeFormField(
      decoration: getMetaData('decoration') ??
          InputDecoration(
            fillColor: Colors.grey.shade50,
            border: InputBorder.none,
            filled: true,
            labelText: widget.field.name,
            isDense: true,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Colors.transparent)),
          ),
      dateFormat: getMetaData('dateFormat') ?? DateFormat('yyyy-MM-dd'),
      mode: getMetaData('mode') ?? DateTimeFieldPickerMode.date,
      firstDate: getMetaData('firstDate') ?? DateTime(1951),
      lastDate: getMetaData('lastDate') ?? DateTime(2100),
      initialValue: currentValue,
      initialPickerDateTime:
          getMetaData('initialPickerDateTime') ?? currentValue,
      onTap: getMetaData('onTap') ?? null,
      enableFeedback: getMetaData('enableFeedback') ?? true,
      autofocus: getMetaData('autofocus') ?? false,
      focusNode: getMetaData('focusNode'),
      pickerPlatform:
          getMetaData('pickerPlatform') ?? DateTimeFieldPickerPlatform.adaptive,
      materialDatePickerOptions: getMetaData('materialDatePickerOptions') ??
          const MaterialDatePickerOptions(),
      materialTimePickerOptions: getMetaData('materialTimePickerOptions') ??
          const MaterialTimePickerOptions(),
      cupertinoDatePickerOptions: getMetaData('cupertinoDatePickerOptions') ??
          const CupertinoDatePickerOptions(),
      hideDefaultSuffixIcon: getMetaData('hideDefaultSuffixIcon') ?? false,
      padding: getMetaData('padding') ?? EdgeInsets.zero,
      style:
          getMetaData('style') ?? TextStyle(fontSize: 16, color: Colors.black),
      onChanged: widget.onChanged,
    );
  }

  /// Get the metadata from the field
  getMetaData(String key) {
    return widget.field.cast.metaData[key];
  }
}
