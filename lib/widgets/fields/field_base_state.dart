import 'package:flutter/cupertino.dart';
import '/widgets/ny_form.dart';

import '/widgets/spacing.dart';

abstract class FieldBaseState<T extends StatefulWidget> extends State<T> {
  FieldBaseState(this.field);
  late Field field;

  /// Get metadata from a field
  // ignore: avoid_shadowing_type_parameters
  T getFieldMeta<T>(String name, T defaultValue) {
    if (field.cast.metaData == null || field.cast.metaData![name] == null) {
      return defaultValue;
    }
    return field.cast.metaData![name];
  }

  /// Get the headerSpacing from the field
  double getHeaderSpacing() => getFieldMeta("headerSpacing", 5);

  /// Get the footerSpacing from the field
  double getFooterSpacing() => getFieldMeta("footerSpacing", 5);

  /// The view of the widget
  Widget view(BuildContext context) {
    return const SizedBox.shrink();
  }

  /// Build the widget
  @override
  Widget build(BuildContext context) {
    Widget widget = view(context);

    if (field.header != null || field.footer != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (field.header != null) ...[
            field.header!,
            Spacing.vertical(getHeaderSpacing())
          ],
          widget,
          if (field.footer != null) ...[
            field.footer!,
            Spacing.vertical(getFooterSpacing())
          ],
        ],
      );
    }

    return widget;
  }
}
