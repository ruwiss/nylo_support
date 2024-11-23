import '/widgets/ny_base_state.dart';
import '/event_bus/event_bus_plus.dart';
import 'package:flutter/material.dart';
import '/widgets/event_bus/update_state.dart';
import '/widgets/ny_stateful_widget.dart';

abstract class NyState<T extends StatefulWidget> extends NyBaseState<T> {
  /// Base NyState
  NyState({super.path});

  @override
  void initState() {
    super.initState();

    /// Set the state name if the widget is a NyStatefulWidget
    if (widget is NyStatefulWidget) {
      stateName = (widget as NyStatefulWidget).controller.state;
    }

    if (allowStateUpdates) {
      List<EventBusHistoryEntry> eventHistory = eventBus!.history
          .where((element) =>
              element.event.runtimeType.toString() == 'UpdateState')
          .toList();
      if (eventHistory.isNotEmpty) {
        stateData = eventHistory.last.event.props[1];
      }
      eventSubscription = eventBus!.on<UpdateState>().listen((event) async {
        if (event.stateName != stateName) return;

        await stateUpdated(event.data);
        setState(() {});
      });
    }

    if (!shouldLoadView) {
      init();
      return;
    }

    awaitData(
      perform: () async {
        await init();
        hasInitComplete = true;
      },
      shouldSetStateBefore: false,
    );
  }
}
