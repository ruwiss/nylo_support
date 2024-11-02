import 'package:flutter/cupertino.dart';
import '/helpers/extensions.dart';
import '/nylo.dart';

import 'form/form.dart';
import 'form/form_data.dart';
import 'ny_state.dart';

/// ButtonState is a stateful widget that manages the state of a button.
class ButtonState extends StatefulWidget {
  const ButtonState({
    super.key,
    required this.child,
    this.onSubmit,
    this.loading,
    this.onFailure,
    this.showToastError,
    this.skeletonizerLoading,
  });

  final Widget Function(VoidCallback? onPressed) child;
  final Widget? loading;
  final (Function()? onPressed, (dynamic, Function(dynamic data))?)? onSubmit;
  final Function(dynamic data)? onFailure;
  final bool? showToastError;
  final bool? skeletonizerLoading;

  @override
  createState() => _ButtonStateState();
}

class _ButtonStateState extends NyState<ButtonState> {
  /// Check if the form is loading
  bool formLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.onSubmit?.$2?.$1 is NyFormData &&
        (widget.onSubmit?.$2?.$1 as NyFormData).getLoadData is Future
            Function()) {
      formLoading = true;

      (widget.onSubmit!.$2!.$1 as NyFormData).isReady.listen((ready) {
        if (ready) {
          setState(() {
            formLoading = false;
          });
        }
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLocked(widget.child.toString()) || formLoading) {
      if (widget.skeletonizerLoading == true) {
        return widget.child(null).toSkeleton();
      }
      return widget.loading ??
          SizedBox(
            height: 50,
            child: Nylo.appLoader(),
          );
    }
    return widget.child(() {
      if (widget.onSubmit == null) return;
      if (widget.onSubmit!.$2 != null) {
        assert(widget.onSubmit!.$2!.$1 != null,
            "Form ID is required for form submission");
        assert(
            widget.onSubmit!.$2!.$1 is String ||
                widget.onSubmit!.$2!.$1 is NyFormData,
            "Form ID must be a String or NyFormData");
        late String formId;
        if (widget.onSubmit!.$2!.$1 is NyFormData) {
          formId = (widget.onSubmit!.$2!.$1 as NyFormData).name!;
        } else {
          formId = widget.onSubmit!.$2!.$1 as String;
        }
        NyForm.submit(formId, onSuccess: (data) {
          if (widget.onSubmit!.$2!.$2 is Future Function(dynamic data)) {
            lockRelease(widget.child.toString(), perform: () async {
              await widget.onSubmit!.$2!.$2(data);
            });
          } else {
            widget.onSubmit!.$2!.$2(data);
          }
        },
            onFailure: widget.onFailure,
            showToastError: widget.showToastError ?? true);
      }
      try {
        if (widget.onSubmit!.$1 is Future Function()) {
          lockRelease(widget.child.toString(), perform: () async {
            await widget.onSubmit!.$1!();
          });
        } else {
          if (widget.onSubmit!.$1 != null) widget.onSubmit!.$1!();
        }
      } catch (e) {
        if (widget.onFailure != null) widget.onFailure!(e);
      }
    });
  }
}
