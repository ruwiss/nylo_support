import 'package:flutter/material.dart';
import 'package:nylo_support/widgets/ny_form.dart';

/// A [NyFormCheckbox] widget for Form Fields
class NyFormCheckbox extends StatefulWidget {
  /// Creates a [NyFormCheckbox] widget
  NyFormCheckbox(
      {required String name,
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
      Function(dynamic value)? onChanged})
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
              checkboxSemanticLabel: checkboxSemanticLabel),
        onChanged = onChanged;

  /// Creates a [NyFormCheckbox] widget from a [Field]
  NyFormCheckbox.fromField(Field field, Function(dynamic value)? onChanged,
      {super.key})
      : field = field,
        onChanged = onChanged;

  /// The field to be rendered
  final Field field;

  /// The callback function to be called when the value changes
  final Function(dynamic value)? onChanged;

  @override
  createState() => _NyFormCheckboxState();
}

class _NyFormCheckboxState extends State<NyFormCheckbox> {
  dynamic currentValue;

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
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      mouseCursor: getMetaData('mouseCursor'),
      title: Text(widget.field.name),
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
      activeColor: getMetaData('activeColor'),
      fillColor: getMetaData('fillColor'),
      checkColor: getMetaData('checkColor'),
      hoverColor: getMetaData('hoverColor'),
      overlayColor: getMetaData('overlayColor'),
      splashRadius: getMetaData('splashRadius'),
      materialTapTargetSize: getMetaData('materialTapTargetSize'),
      visualDensity: getMetaData('visualDensity'),
      focusNode: getMetaData('focusNode'),
      autofocus: getMetaData('autofocus'),
      shape: getMetaData('shape'),
      side: getMetaData('side'),
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
    if (!(metaData is Map)) {
      return null;
    }
    if (!metaData.containsKey(key)) {
      return null;
    }
    return widget.field.cast.metaData[key];
  }
}
