import 'package:flutter/material.dart';
import 'package:nylo_support/helpers/ny_color.dart';
import 'package:nylo_support/helpers/ny_text_style.dart';

/// BottomModalSheetStyle
///
/// This class is used to style the bottom modal sheet.
class BottomModalSheetStyle {
  // Background color of the bottom modal sheet
  final NyColor? backgroundColor;
  // Barrier color of the bottom modal sheet
  final NyColor? barrierColor;
  // Use root navigator
  final bool useRootNavigator;
  // Route settings
  final RouteSettings? routeSettings;
  // title style
  final NyTextStyle? titleStyle;
  // item style
  final NyTextStyle? itemStyle;
  // clear button style
  final NyTextStyle? clearButtonStyle;

  BottomModalSheetStyle({
    this.backgroundColor,
    this.barrierColor,
    this.useRootNavigator = false,
    this.routeSettings,
    this.titleStyle,
    this.itemStyle,
    this.clearButtonStyle,
  });
}
