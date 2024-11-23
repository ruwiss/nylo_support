import 'package:flutter/material.dart';
import '/helpers/extensions.dart';
import '/localization/app_localization.dart';
import '/widgets/fields/field_base_state.dart';
import '/widgets/ny_form.dart';
import 'package:recase/recase.dart';

/// A [NyFormPicker] widget for Form Fields
class NyFormPicker extends StatefulWidget {
  /// Creates a [NyFormPicker] widget
  NyFormPicker(
      {super.key,
      required String name,
      required List<String> options,
      String? selectedValue,
      this.onChanged})
      : field = Field(name, value: selectedValue)
          ..cast = FormCast.picker(options: options);

  /// Creates a [NyFormPicker] widget from a [Field]
  const NyFormPicker.fromField(this.field, this.onChanged, {super.key});

  /// The field to be rendered
  final Field field;

  /// The callback function to be called when the value changes
  final Function(dynamic value)? onChanged;

  @override
  // ignore: no_logic_in_create_state
  createState() => _NyFormPickerState(field);
}

class _NyFormPickerState extends FieldBaseState<NyFormPicker> {
  dynamic currentValue;
  _NyFormPickerState(super.field);

  @override
  void initState() {
    super.initState();

    dynamic fieldValue = widget.field.value;
    if (fieldValue is String && fieldValue.isNotEmpty) {
      currentValue = fieldValue;
    }
  }

  @override
  Widget view(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, constraints) {
      double width = constraints.maxWidth;
      Widget container = Container(
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color:
                    color(light: Colors.grey.shade100, dark: surfaceColorDark),
                borderRadius: BorderRadius.circular(8),
              ),
              child: currentValue != null
                  ? SizedBox(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          if (width < 200)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Text(
                                currentValue.toString(),
                                textAlign: width < 200
                                    ? TextAlign.left
                                    : TextAlign.center,
                                style: TextStyle(
                                    color: color(
                                        light: Colors.black87,
                                        dark: Colors.white),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          if (width > 200)
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  currentValue.toString(),
                                  textAlign: width < 200
                                      ? TextAlign.left
                                      : TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: color(
                                          light: Colors.black87,
                                          dark: Colors.white),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          Positioned(
                            left: 0,
                            top: 5,
                            child: Text(
                              widget.field.name.titleCase,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: color(
                                      light: Colors.black54,
                                      dark: Colors.white),
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "${"Select".tr()} ${widget.field.name}",
                            textAlign:
                                width < 200 ? TextAlign.left : TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: color(
                                    light: Colors.black54, dark: Colors.white),
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: color(
                              light: Colors.grey.shade800, dark: Colors.white),
                        )
                      ],
                    ).withGap(10))
          .onTap(() => _selectValue(context));

      return container;
    });
  }

  /// Get the list of options from the field
  List<String> getOptions() {
    if (widget.field.cast.metaData == null) {
      return [];
    }
    return List<String>.from(widget.field.cast.metaData!["options"]);
  }

  /// Select a value from the list of options
  _selectValue(BuildContext context) {
    // get the list of values
    List<String> values = getOptions();

    // show modal bottom sheet
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: color(light: Colors.white, dark: surfaceColorDark),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.field.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              color(light: Colors.black, dark: Colors.white)),
                    ).paddingOnly(top: 10),
                    Text(
                      "Clear".tr(),
                      style: const TextStyle(fontSize: 13, color: Colors.red),
                    ).onTap(() {
                      setState(() {
                        currentValue = null;
                      });
                      Navigator.pop(context);
                    })
                  ],
                ).paddingOnly(bottom: 15),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: ListTile.divideTiles(
                        context: context,
                        color: color(
                            light: Colors.grey.shade100, dark: Colors.black38),
                        tiles: values.map((item) {
                          return ListTile(
                            title: Text(
                              item,
                              style: TextStyle(
                                  color: color(
                                      light: Colors.black87,
                                      dark: Colors.white),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            onTap: () {
                              if (widget.onChanged != null) {
                                widget.onChanged!(item);
                              }
                              setState(() {
                                currentValue = item;
                              });
                              Navigator.pop(context);
                            },
                          );
                        })).toList(),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
