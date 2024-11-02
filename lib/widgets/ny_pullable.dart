import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

/// The Pullable widget helps you refresh the content.
class Pullable extends StatelessWidget {
  Pullable({super.key, required this.child, this.onRefresh, this.headerStyle});

  /// Classic Header
  Pullable.classicHeader({super.key, required this.child, this.onRefresh})
      : headerStyle = "ClassicHeader";

  /// WaterDrop Header
  Pullable.waterDropHeader({super.key, required this.child, this.onRefresh})
      : headerStyle = "WaterDropHeader";

  /// MaterialClassic Header
  Pullable.materialClassicHeader(
      {super.key, required this.child, this.onRefresh})
      : headerStyle = "MaterialClassicHeader";

  /// WaterDropMaterial Header
  Pullable.waterDropMaterialHeader(
      {super.key, required this.child, this.onRefresh})
      : headerStyle = "WaterDropMaterialHeader";

  /// Bezier Header
  Pullable.bezierHeader({super.key, required this.child, this.onRefresh})
      : headerStyle = "BezierHeader";

  final Widget child;
  final Function()? onRefresh;
  final String? headerStyle;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: headerType(),
      controller: refreshController,
      onRefresh: () async {
        if (onRefresh == null) {
          refreshController.refreshCompleted(resetFooterState: true);
          return;
        }
        if (onRefresh is Future Function()) {
          await onRefresh!();
        } else {
          onRefresh!();
        }
        refreshController.refreshCompleted(resetFooterState: true);
      },
      child: child,
    );
  }

  /// Returns the header type
  Widget headerType() {
    switch (headerStyle) {
      case "ClassicHeader":
        {
          return const ClassicHeader();
        }
      case "WaterDropHeader":
        {
          return const WaterDropHeader();
        }
      case "MaterialClassicHeader":
        {
          return const MaterialClassicHeader();
        }
      case "WaterDropMaterialHeader":
        {
          return const WaterDropMaterialHeader();
        }
      case "BezierHeader":
        {
          return BezierHeader();
        }
      default:
        {
          return const WaterDropHeader();
        }
    }
  }
}
