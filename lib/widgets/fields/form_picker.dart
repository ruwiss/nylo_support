import 'package:flutter/material.dart';
import 'package:nylo_support/helpers/extensions.dart';
import 'package:nylo_support/localization/app_localization.dart';
import 'package:nylo_support/widgets/ny_form.dart';

/// A [NyFormPicker] widget for Form Fields
class NyFormPicker extends StatefulWidget {
  /// Creates a [NyFormPicker] widget
  NyFormPicker(
      {required String name,
      required List<String> options,
      String? selectedValue,
      Function(dynamic value)? onChanged})
      : field = Field(name, options: options, selected: selectedValue),
        onChanged = onChanged;

  /// Creates a [NyFormPicker] widget from a [Field]
  NyFormPicker.fromField(Field field, Function(dynamic value)? onChanged,
      {super.key})
      : field = field,
        onChanged = onChanged;

  /// The field to be rendered
  final Field field;

  /// The callback function to be called when the value changes
  final Function(dynamic value)? onChanged;

  @override
  createState() => _NyFormPickerState();
}

class _NyFormPickerState extends State<NyFormPicker> {
  dynamic currentValue;

  @override
  void initState() {
    super.initState();

    if (widget.field.selected != null) {
      currentValue = widget.field.selected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, constraints) {
      double width = constraints.maxWidth;
      return Container(
              height: 50,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: currentValue != null
                  ? Container(
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
                                    fontSize: 13, fontWeight: FontWeight.bold),
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
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          Positioned(
                            left: 0,
                            top: 5,
                            child: Text(
                              "${widget.field.name}",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
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
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey.shade800,
                        )
                      ],
                    ).withGap(10))
          .onTap(() => _selectValue(context));
    });
  }

  /// Select a value from the list of options
  _selectValue(BuildContext context) {
    // get the list of values
    List<String> values = widget.field.options as List<String>;

    // show modal bottom sheet
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.field.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ).paddingOnly(top: 10),
                    Text(
                      "Clear".tr(),
                      style: TextStyle(fontSize: 13, color: Colors.red),
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
                        tiles: values.map((item) {
                          return ListTile(
                            title: Text(
                              item,
                              style: TextStyle(
                                  color: Colors.black,
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
