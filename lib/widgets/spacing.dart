import 'package:flutter/material.dart';

/// Simple way to add spacing between widgets.
class Spacing extends StatelessWidget {
  const Spacing.vertical(double value, {super.key})
      : _value = value,
        _type = "vertical";

  const Spacing.horizontal(double value, {super.key})
      : _value = value,
        _type = "horizontal";

  final String _type;
  final double? _value;

  @override
  Widget build(BuildContext context) {
    if (_type == "horizontal") {
      return SizedBox(width: _value);
    }
    if (_type == "vertical") {
      return SizedBox(height: _value);
    }
    throw Exception("Invalid spacing type");
  }
}
