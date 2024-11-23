import 'package:flutter/material.dart';
import '/widgets/fields/field_base_state.dart';
import '/widgets/ny_form.dart';
import 'package:recase/recase.dart';

/// A [NyFormCheckbox] widget for Form Fields
class NyFormCheckbox extends StatefulWidget {
  /// Creates a [NyFormCheckbox] widget
  NyFormCheckbox(
      {super.key,
      required String name,
      bool? value,
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
      ListTileControlAffinity controlAffinity =
          ListTileControlAffinity.platform,
      EdgeInsetsGeometry? contentPadding,
      bool tristate = false,
      ShapeBorder? checkboxShape,
      Color? selectedTileColor,
      ValueChanged<bool?>? onFocusChange,
      bool? enableFeedback,
      String? checkboxSemanticLabel,
      this.onChanged})
      : field = Field(name, value: value)
          ..cast = FormCast.checkbox(
              mouseCursor: mouseCursor,
              activeColor: activeColor,
              fillColor: fillColor,
              checkColor: checkColor,
              hoverColor: hoverColor,
              overlayColor: overlayColor,
              splashRadius: splashRadius,
              materialTapTargetSize: materialTapTargetSize,
              visualDensity: visualDensity,
              focusNode: focusNode,
              autofocus: autofocus,
              shape: shape,
              side: side,
              isError: isError,
              enabled: enabled,
              tileColor: tileColor,
              subtitle: subtitle,
              isThreeLine: isThreeLine,
              dense: dense,
              secondary: secondary,
              selected: selected,
              controlAffinity: controlAffinity,
              contentPadding: contentPadding,
              tristate: tristate,
              checkboxShape: checkboxShape,
              selectedTileColor: selectedTileColor,
              onFocusChange: onFocusChange,
              enableFeedback: enableFeedback,
              checkboxSemanticLabel: checkboxSemanticLabel);

  /// Creates a [NyFormCheckbox] widget from a [Field]
  const NyFormCheckbox.fromField(this.field, this.onChanged, {super.key});

  /// The field to be rendered
  final Field field;

  /// The callback function to be called when the value changes
  final Function(dynamic value)? onChanged;

  @override
  // ignore: no_logic_in_create_state
  createState() => _NyFormCheckboxState(field);
}

class _NyFormCheckboxState extends FieldBaseState<NyFormCheckbox> {
  dynamic currentValue;

  _NyFormCheckboxState(super.field);

  @override
  void initState() {
    super.initState();
    dynamic fieldValue = widget.field.value;

    if (fieldValue is String) {
      if (fieldValue.toLowerCase() == "true") {
        currentValue = true;
      } else if (fieldValue.toLowerCase() == "false") {
        currentValue = false;
      }
    }

    if (fieldValue is bool) {
      currentValue = fieldValue;
    }

    currentValue ??= false;
  }

  @override
  Widget view(BuildContext context) {
    Widget? title = getMetaData('title');

    title ??= Text(
      widget.field.name.titleCase,
      style: TextStyle(
        color: color(light: Colors.black, dark: Colors.white),
      ),
    );
    if (title is Text && (title.data == null || title.data!.isEmpty)) {
      title = Text(
        widget.field.name.titleCase,
        style: TextStyle(
          color: color(light: Colors.black, dark: Colors.white),
        ),
      );
    }

    Color? fillColorMetaData = color(
        light: getMetaData('fillColor') ?? Colors.transparent,
        dark: Colors.black);
    WidgetStateProperty<Color?>? fillColor =
        WidgetStateProperty.all(fillColorMetaData);

    Color? overlayColorMetaData = getMetaData('overlayColor');
    WidgetStateProperty<Color?>? overlayColor;
    if (overlayColorMetaData != null) {
      overlayColor = WidgetStateProperty.all(overlayColorMetaData);
    }

    return CheckboxListTile(
      mouseCursor: getMetaData('mouseCursor'),
      title: title,
      value: currentValue,
      onChanged: (value) {
        setState(() {
          currentValue = value;
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: color(
          light: getMetaData('activeColor') ?? Colors.black,
          dark: Colors.black),
      fillColor: fillColor,
      checkColor: color(
          light: getMetaData('checkColor') ?? Colors.black, dark: Colors.white),
      hoverColor: getMetaData('hoverColor'),
      overlayColor: overlayColor,
      splashRadius: getMetaData('splashRadius'),
      materialTapTargetSize: getMetaData('materialTapTargetSize'),
      visualDensity: getMetaData('visualDensity'),
      focusNode: getMetaData('focusNode'),
      autofocus: getMetaData('autofocus'),
      shape: getMetaData('shape'),
      side: whenTheme(
          light: () => getMetaData('side'),
          dark: () => BorderSide(
              width: 2, color: color(light: Colors.black, dark: Colors.white))),
      isError: getMetaData('isError'),
      enabled: getMetaData('enabled'),
      tileColor: getMetaData('tileColor'),
      subtitle: getMetaData('subtitle'),
      isThreeLine: getMetaData('isThreeLine'),
      dense: getMetaData('dense'),
      secondary: getMetaData('secondary'),
      selected: getMetaData('selected'),
      contentPadding: getMetaData('contentPadding'),
      tristate: getMetaData('tristate'),
      checkboxShape: getMetaData('checkboxShape'),
      selectedTileColor: getMetaData('selectedTileColor'),
      onFocusChange: getMetaData('onFocusChange'),
      enableFeedback: getMetaData('enableFeedback'),
      checkboxSemanticLabel: getMetaData('checkboxSemanticLabel'),
    );
  }

  /// Get the metadata from the field
  getMetaData(String key) {
    dynamic metaData = widget.field.cast.metaData;
    if (metaData is! Map) {
      return null;
    }
    if (!metaData.containsKey(key)) {
      return null;
    }
    return widget.field.cast.metaData[key];
  }
}
