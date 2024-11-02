import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/widgets/fields/field_base_state.dart';
import '/widgets/ny_form.dart';
import 'package:recase/recase.dart';
import '/helpers/helper.dart';

/// A [NyFormDateTimePicker] widget for Form Fields
class NyFormDateTimePicker extends StatefulWidget {
  /// Creates a [NyFormDateTimePicker] widget
  NyFormDateTimePicker(
      {super.key,
      required String name,
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
      this.onChanged})
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
          );

  /// Creates a [NyFormDateTimePicker] widget from a [Field]
  const NyFormDateTimePicker.fromField(this.field, this.onChanged, {super.key});

  /// The field to be rendered
  final Field field;

  /// The callback function to be called when the value changes
  final Function(dynamic value)? onChanged;

  @override
  // ignore: no_logic_in_create_state
  createState() => _NyFormDateTimePickerState(field);
}

class _NyFormDateTimePickerState extends FieldBaseState<NyFormDateTimePicker> {
  dynamic currentValue;

  _NyFormDateTimePickerState(super.field);

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

    currentValue ??= getMetaData('firstDate') ?? DateTime.now();
  }

  @override
  Widget view(BuildContext context) {
    return DateTimeFormField(
      decoration: getMetaData('decoration') ??
          InputDecoration(
            fillColor: Colors.grey.shade100,
            border: InputBorder.none,
            filled: true,
            labelText: widget.field.name.titleCase,
            isDense: true,
            focusedBorder: const OutlineInputBorder(
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
      onTap: getMetaData('onTap'),
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
      style: getMetaData('style') ??
          const TextStyle(fontSize: 16, color: Colors.black),
      onChanged: widget.onChanged,
    );
  }

  /// Get the metadata from the field
  getMetaData(String key) {
    return widget.field.cast.metaData[key];
  }
}
