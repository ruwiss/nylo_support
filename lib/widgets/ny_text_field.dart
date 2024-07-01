import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_support/nylo.dart';
import '/localization/app_localization.dart';
import '/validation/ny_validator.dart';
import '/widgets/ny_state.dart';

/// Nylo's Text Field Widget
class NyTextField extends StatefulWidget {
  final String? labelText;
  final TextStyle? labelStyle;
  final TextEditingController controller;
  final bool obscureText;
  final int? maxLines, minLines;
  final TextInputType keyboardType;
  final bool autoFocus;
  final TextAlign? textAlign;
  final bool enableSuggestions;
  final FocusNode? focusNode;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? validationRules;
  final String? dummyData;
  final Function(String value)? onChanged;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final String obscuringCharacter;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool expands;
  final bool readOnly;
  final bool? showCursor;
  final int? maxLength;
  final MouseCursor? mouseCursor;
  final String? validationErrorMessage;
  final TextCapitalization textCapitalization;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final TextSelectionControls? selectionControls;
  final DragStartBehavior dragStartBehavior;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final InputDecoration? decoration;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final Clip clipBehavior;
  final Function(String handleError)? handleValidationError;
  final bool? passwordVisible;
  final String? type;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final EdgeInsetsGeometry? contentPadding;
  final bool? passwordViewable;
  final bool? validateOnFocusChange;

  /// Default Text Field
  NyTextField(
      {Key? key,
      required this.controller,
      this.labelText,
      this.obscureText = false,
      this.autoFocus = false,
      this.keyboardType = TextInputType.text,
      this.textAlign,
      this.maxLines = 1,
      this.validateOnFocusChange = false,
      this.handleValidationError,
      this.minLines,
      this.enableSuggestions = true,
      this.hintText,
      this.hintStyle,
      this.focusNode,
      this.validationRules,
      this.dummyData,
      this.onChanged,
      this.style,
      this.strutStyle,
      this.textInputAction,
      this.readOnly = false,
      this.showCursor,
      this.maxLength,
      this.enabled,
      this.dragStartBehavior = DragStartBehavior.start,
      this.cursorHeight,
      this.cursorRadius,
      this.cursorColor,
      this.onTap,
      this.onTapOutside,
      this.validationErrorMessage,
      this.mouseCursor,
      this.textCapitalization = TextCapitalization.none,
      this.maxLengthEnforcement,
      this.cursorWidth = 2.0,
      this.onAppPrivateCommand,
      this.inputFormatters,
      this.expands = false,
      this.textAlignVertical,
      this.textDirection,
      this.obscuringCharacter = '•',
      this.autocorrect = true,
      this.smartDashesType,
      this.smartQuotesType,
      this.decoration,
      this.onEditingComplete,
      this.keyboardAppearance,
      this.scrollPadding = const EdgeInsets.all(20.0),
      this.selectionControls,
      this.onSubmitted,
      this.scrollController,
      this.scrollPhysics,
      this.autofillHints = const <String>[],
      this.clipBehavior = Clip.hardEdge,
      this.passwordVisible,
      this.passwordViewable,
      this.prefixIcon,
      this.backgroundColor,
      this.borderRadius,
      this.border,
      this.focusedBorder,
      this.enabledBorder,
      this.contentPadding,
      this.labelStyle,
      this.type = null})
      : super(key: key) {
    if (Nylo.isEnvDeveloping()) {
      String dummyDataValue = dummyData ?? "";
      if (controller.text.isEmpty && dummyDataValue.isNotEmpty) {
        controller.text = dummyDataValue;
      }
    }
  }

  /// Compact Text Field
  NyTextField.compact({
    Key? key,
    this.passwordVisible,
    this.labelText,
    required this.controller,
    this.obscureText = false,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.textAlign,
    this.validateOnFocusChange = false,
    this.maxLines = 1,
    this.handleValidationError,
    this.minLines,
    this.enableSuggestions = true,
    this.hintText,
    this.hintStyle,
    this.focusNode,
    this.validationRules,
    this.dummyData,
    this.onChanged,
    this.style,
    this.strutStyle,
    this.textInputAction,
    this.readOnly = false,
    this.showCursor,
    this.maxLength,
    this.enabled,
    this.dragStartBehavior = DragStartBehavior.start,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.onTap,
    this.onTapOutside,
    this.validationErrorMessage,
    this.mouseCursor,
    this.textCapitalization = TextCapitalization.none,
    this.maxLengthEnforcement,
    this.cursorWidth = 2.0,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.expands = false,
    this.textAlignVertical,
    this.textDirection,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.decoration,
    this.onEditingComplete,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.selectionControls,
    this.onSubmitted,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.clipBehavior = Clip.hardEdge,
    this.prefixIcon,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.contentPadding,
    this.labelStyle,
    this.type = 'compact',
  })  : passwordViewable = false,
        super(key: key) {
    if (Nylo.isEnvDeveloping()) {
      String dummyDataValue = dummyData ?? "";
      if (controller.text.isEmpty && dummyDataValue.isNotEmpty) {
        controller.text = dummyDataValue;
      }
    }
  }

  /// Password Text Field
  NyTextField.password({
    Key? key,
    this.passwordVisible,
    this.labelText,
    required this.controller,
    this.obscureText = true,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.textAlign,
    this.maxLines = 1,
    this.validateOnFocusChange = false,
    this.handleValidationError,
    this.minLines,
    this.enableSuggestions = true,
    this.hintText,
    this.hintStyle,
    this.focusNode,
    this.validationRules,
    this.dummyData,
    this.onChanged,
    this.style,
    this.strutStyle,
    this.textInputAction,
    this.readOnly = false,
    this.showCursor,
    this.maxLength,
    this.enabled,
    this.dragStartBehavior = DragStartBehavior.start,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.onTap,
    this.onTapOutside,
    this.validationErrorMessage,
    this.mouseCursor,
    this.textCapitalization = TextCapitalization.none,
    this.maxLengthEnforcement,
    this.cursorWidth = 2.0,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.expands = false,
    this.textAlignVertical,
    this.textDirection,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.decoration,
    this.onEditingComplete,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.selectionControls,
    this.onSubmitted,
    this.scrollController,
    this.scrollPhysics,
    this.passwordViewable,
    this.autofillHints = const <String>[],
    this.clipBehavior = Clip.hardEdge,
    this.prefixIcon,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.contentPadding,
    this.labelStyle,
    this.type = 'password',
  }) : super(key: key) {
    if (Nylo.isEnvDeveloping()) {
      String dummyDataValue = dummyData ?? "";
      if (controller.text.isEmpty && dummyDataValue.isNotEmpty) {
        controller.text = dummyDataValue;
      }
    }
  }

  /// Email Address Text Field
  NyTextField.emailAddress({
    Key? key,
    this.labelText,
    required this.controller,
    this.obscureText = false,
    this.autoFocus = true,
    this.keyboardType = TextInputType.emailAddress,
    this.textAlign,
    this.validateOnFocusChange = false,
    this.maxLines = 1,
    this.handleValidationError,
    this.minLines,
    this.enableSuggestions = true,
    this.hintText,
    this.hintStyle,
    this.focusNode,
    this.validationRules,
    this.dummyData,
    this.onChanged,
    this.style,
    this.strutStyle,
    this.textInputAction,
    this.readOnly = false,
    this.showCursor,
    this.maxLength,
    this.enabled,
    this.dragStartBehavior = DragStartBehavior.start,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.onTap,
    this.onTapOutside,
    this.validationErrorMessage,
    this.mouseCursor,
    this.textCapitalization = TextCapitalization.none,
    this.maxLengthEnforcement,
    this.cursorWidth = 2.0,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.expands = false,
    this.textAlignVertical,
    this.textDirection,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.smartDashesType,
    this.passwordViewable,
    this.smartQuotesType,
    this.decoration,
    this.onEditingComplete,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.selectionControls,
    this.onSubmitted,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.clipBehavior = Clip.hardEdge,
    this.prefixIcon,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.contentPadding,
    this.labelStyle,
    this.passwordVisible,
    this.type = 'email-address',
  }) : super(key: key) {
    if (Nylo.isEnvDeveloping()) {
      String dummyDataValue = dummyData ?? "";
      if (controller.text.isEmpty && dummyDataValue.isNotEmpty) {
        controller.text = dummyDataValue;
      }
    }
  }

  /// Copy with method
  NyTextField copyWith({
    String? labelText,
    TextStyle? labelStyle,
    TextEditingController? controller,
    bool? obscureText,
    int? maxLines,
    int? minLines,
    TextInputType? keyboardType,
    bool? autoFocus,
    TextAlign? textAlign,
    bool? enableSuggestions,
    FocusNode? focusNode,
    String? hintText,
    TextStyle? hintStyle,
    String? validationRules,
    String? dummyData,
    Function(String value)? onChanged,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlignVertical? textAlignVertical,
    TextDirection? textDirection,
    String? obscuringCharacter,
    bool? autocorrect,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool? expands,
    bool? readOnly,
    bool? showCursor,
    int? maxLength,
    bool? passwordViewable,
    bool? validateOnFocusChange,
    MouseCursor? mouseCursor,
    String? validationErrorMessage,
    TextCapitalization? textCapitalization,
    MaxLengthEnforcement? maxLengthEnforcement,
    AppPrivateCommandCallback? onAppPrivateCommand,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets? scrollPadding,
    TextSelectionControls? selectionControls,
    DragStartBehavior? dragStartBehavior,
    GestureTapCallback? onTap,
    TapRegionCallback? onTapOutside,
    InputDecoration? decoration,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    Clip? clipBehavior,
    Function(String handleError)? handleValidationError,
    bool? passwordVisible,
    String? type,
    Widget? prefixIcon,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    InputBorder? border,
    InputBorder? focusedBorder,
    InputBorder? enabledBorder,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return NyTextField(
      type: type ?? this.type,
      labelText: labelText ?? this.labelText,
      labelStyle: labelStyle ?? this.labelStyle,
      controller: controller ?? this.controller,
      obscureText: obscureText ?? this.obscureText,
      maxLines: maxLines ?? this.maxLines,
      minLines: minLines ?? this.minLines,
      keyboardType: keyboardType ?? this.keyboardType,
      autoFocus: autoFocus ?? this.autoFocus,
      validateOnFocusChange:
          validateOnFocusChange ?? this.validateOnFocusChange,
      textAlign: textAlign ?? this.textAlign,
      enableSuggestions: enableSuggestions ?? this.enableSuggestions,
      focusNode: focusNode ?? this.focusNode,
      hintText: hintText ?? this.hintText,
      passwordViewable: passwordViewable ?? this.passwordViewable,
      hintStyle: hintStyle ?? this.hintStyle,
      validationRules: validationRules ?? this.validationRules,
      dummyData: dummyData ?? this.dummyData,
      onChanged: onChanged ?? this.onChanged,
      textInputAction: textInputAction ?? this.textInputAction,
      style: style ?? this.style,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlignVertical: textAlignVertical ?? this.textAlignVertical,
      textDirection: textDirection ?? this.textDirection,
      obscuringCharacter: obscuringCharacter ?? this.obscuringCharacter,
      autocorrect: autocorrect ?? this.autocorrect,
      smartDashesType: smartDashesType ?? this.smartDashesType,
      smartQuotesType: smartQuotesType ?? this.smartQuotesType,
      expands: expands ?? this.expands,
      readOnly: readOnly ?? this.readOnly,
      showCursor: showCursor ?? this.showCursor,
      maxLength: maxLength ?? this.maxLength,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      validationErrorMessage:
          validationErrorMessage ?? this.validationErrorMessage,
      textCapitalization: textCapitalization ?? this.textCapitalization,
      maxLengthEnforcement: maxLengthEnforcement ?? this.maxLengthEnforcement,
      onAppPrivateCommand: onAppPrivateCommand ?? this.onAppPrivateCommand,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      enabled: enabled ?? this.enabled,
      cursorWidth: cursorWidth ?? this.cursorWidth,
      cursorHeight: cursorHeight ?? this.cursorHeight,
      cursorRadius: cursorRadius ?? this.cursorRadius,
      cursorColor: cursorColor ?? this.cursorColor,
      keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
      scrollPadding: scrollPadding ?? this.scrollPadding,
      selectionControls: selectionControls ?? this.selectionControls,
      dragStartBehavior: dragStartBehavior ?? this.dragStartBehavior,
      onTap: onTap ?? this.onTap,
      onTapOutside: onTapOutside ?? this.onTapOutside,
      decoration: decoration ?? this.decoration,
      onEditingComplete: onEditingComplete ?? this.onEditingComplete,
      onSubmitted: onSubmitted ?? this.onSubmitted,
      scrollController: scrollController ?? this.scrollController,
      scrollPhysics: scrollPhysics ?? this.scrollPhysics,
      autofillHints: autofillHints ?? this.autofillHints,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      handleValidationError:
          handleValidationError ?? this.handleValidationError,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      border: border ?? this.border,
      focusedBorder: focusedBorder ?? this.focusedBorder,
      enabledBorder: enabledBorder ?? this.enabledBorder,
      contentPadding: contentPadding ?? this.contentPadding,
    );
  }

  @override
  _NyTextFieldState createState() => _NyTextFieldState();
}

class _NyTextFieldState extends NyState<NyTextField> {
  FocusNode _focus = FocusNode();
  bool? didChange = false;
  bool? _obscured;
  bool _passwordVisible = false;

  @override
  init() async {
    super.init();
    _obscured = widget.obscureText;
    if (widget.passwordVisible == true) {
      _obscured = true;
    }
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  /// handle focus change
  void _onFocusChange() {
    if (_focus.hasFocus == true) {
      didChange = !(widget.validateOnFocusChange ?? false);
    } else {
      didChange = true;
      setState(() {});
    }
  }

  /// toggle obscured text
  void _toggleObscured() {
    if (_obscured == null) return;
    setState(() {
      _obscured = !_obscured!;
      if (_focus.hasPrimaryFocus) return;
      _focus.canRequestFocus = false;
    });
  }

  /// validate the users input
  String? _validate() {
    if (widget.validationRules == null) {
      return null;
    }
    if (didChange == false) return null;

    String attributeKey = (widget.labelText ?? "");
    try {
      NyValidator.check(
          rules: {attributeKey: widget.validationRules!},
          data: {attributeKey: widget.controller.text},
          messages: widget.validationErrorMessage != null
              ? {attributeKey: "$attributeKey|${widget.validationErrorMessage}"}
              : {});
    } on ValidationException catch (e) {
      String message = e.toTextFieldMessage();
      if (widget.handleValidationError != null) {
        widget.handleValidationError!(message);
        return null;
      }
      return e.toTextFieldMessage();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration = widget.decoration ??
        InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
          errorStyle: TextStyle(fontSize: 12),
          errorMaxLines: 2,
        );
    decoration = decoration.copyWith(errorText: _validate());
    if (widget.backgroundColor != null) {
      decoration = decoration.copyWith(
        filled: true,
        fillColor: widget.backgroundColor,
      );
    }
    if (widget.passwordVisible == true) {
      decoration = decoration.copyWith(
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: GestureDetector(
            onTap: _toggleObscured,
            child: Icon(
              _obscured ?? false
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              size: 24,
            ),
          ),
        ),
      );
    }
    switch (widget.type) {
      case 'compact':
        {
          return TextField(
            key: widget.key,
            decoration: decoration.copyWith(
              prefixIcon: widget.prefixIcon,
              labelText: widget.labelText,
              labelStyle: TextStyle(fontSize: 16, color: Colors.black),
              filled: true,
              fillColor: widget.backgroundColor ?? Colors.grey.shade50,
              isDense: true,
              focusedBorder: widget.focusedBorder ??
                  OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.transparent)),
              enabledBorder: widget.enabledBorder ??
                  OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.transparent)),
              contentPadding: widget.contentPadding ??
                  EdgeInsetsDirectional.symmetric(vertical: 13, horizontal: 13),
              border: widget.border ??
                  OutlineInputBorder(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
            ),
            controller: widget.controller,
            keyboardAppearance: Brightness.light,
            autofocus: widget.autoFocus,
            textAlign: widget.textAlign ?? TextAlign.left,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            keyboardType: widget.keyboardType,
            onTap: widget.onTap,
            textCapitalization: widget.textCapitalization,
            obscureText: _obscured ?? false,
            focusNode: widget.focusNode ?? _focus,
            enableSuggestions: widget.enableSuggestions,
            onChanged: (String value) {
              setState(() {});
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            textInputAction: widget.textInputAction,
            style: widget.style,
            strutStyle: widget.strutStyle,
            textAlignVertical: widget.textAlignVertical,
            textDirection: widget.textDirection,
            readOnly: widget.readOnly,
            showCursor: widget.showCursor,
            obscuringCharacter: widget.obscuringCharacter,
            smartDashesType: widget.smartDashesType,
            smartQuotesType: widget.smartQuotesType,
            expands: widget.expands,
            maxLength: widget.maxLength,
            mouseCursor: widget.mouseCursor,
            maxLengthEnforcement: widget.maxLengthEnforcement,
            onAppPrivateCommand: widget.onAppPrivateCommand,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            cursorWidth: widget.cursorWidth,
            cursorHeight: widget.cursorHeight,
            onTapOutside: widget.onTapOutside,
            cursorRadius: widget.cursorRadius,
            cursorColor: widget.cursorColor,
            scrollPadding: widget.scrollPadding,
            dragStartBehavior: widget.dragStartBehavior,
            selectionControls: widget.selectionControls,
            onEditingComplete: widget.onEditingComplete,
            onSubmitted: widget.onSubmitted,
            scrollController: widget.scrollController,
            scrollPhysics: widget.scrollPhysics,
            autofillHints: widget.autofillHints,
            clipBehavior: widget.clipBehavior,
          );
        }
      case 'email-address':
        {
          return TextField(
            key: widget.key,
            decoration: decoration.copyWith(
              prefixIcon: widget.prefixIcon ?? Icon(Icons.email_outlined),
              labelText: widget.labelText ?? "Email Address".tr(),
              labelStyle: widget.labelStyle ??
                  TextStyle(fontSize: 16, color: Colors.black),
              filled: true,
              fillColor: widget.backgroundColor ?? Colors.grey.shade50,
              isDense: true,
              focusedBorder: widget.focusedBorder ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
              enabledBorder: widget.enabledBorder ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
              contentPadding: widget.contentPadding ??
                  EdgeInsetsDirectional.symmetric(vertical: 13, horizontal: 13),
              border: widget.border ??
                  OutlineInputBorder(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
            ),
            controller: widget.controller,
            keyboardAppearance: Brightness.light,
            autofocus: widget.autoFocus,
            textAlign: widget.textAlign ?? TextAlign.left,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            keyboardType: widget.keyboardType,
            onTap: widget.onTap,
            textCapitalization: widget.textCapitalization,
            obscureText: _obscured ?? false,
            focusNode: widget.focusNode ?? _focus,
            enableSuggestions: widget.enableSuggestions,
            onChanged: (String value) {
              setState(() {});
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            textInputAction: widget.textInputAction,
            style: widget.style,
            strutStyle: widget.strutStyle,
            textAlignVertical: widget.textAlignVertical,
            textDirection: widget.textDirection,
            readOnly: widget.readOnly,
            showCursor: widget.showCursor,
            obscuringCharacter: widget.obscuringCharacter,
            smartDashesType: widget.smartDashesType,
            smartQuotesType: widget.smartQuotesType,
            expands: widget.expands,
            maxLength: widget.maxLength,
            mouseCursor: widget.mouseCursor,
            maxLengthEnforcement: widget.maxLengthEnforcement,
            onAppPrivateCommand: widget.onAppPrivateCommand,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            cursorWidth: widget.cursorWidth,
            cursorHeight: widget.cursorHeight,
            onTapOutside: widget.onTapOutside,
            cursorRadius: widget.cursorRadius,
            cursorColor: widget.cursorColor,
            scrollPadding: widget.scrollPadding,
            dragStartBehavior: widget.dragStartBehavior,
            selectionControls: widget.selectionControls,
            onEditingComplete: widget.onEditingComplete,
            onSubmitted: widget.onSubmitted,
            scrollController: widget.scrollController,
            scrollPhysics: widget.scrollPhysics,
            autofillHints: widget.autofillHints,
            clipBehavior: widget.clipBehavior,
          );
        }
      case 'password':
        {
          return TextField(
            key: widget.key,
            decoration: decoration.copyWith(
              prefixIcon: widget.prefixIcon ?? Icon(Icons.lock_rounded),
              labelText: widget.labelText ?? "Password".tr(),
              labelStyle: TextStyle(fontSize: 16, color: Colors.black),
              filled: true,
              fillColor: widget.backgroundColor ?? Colors.grey.shade50,
              isDense: true,
              suffixIcon: widget.passwordViewable == true
                  ? IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    )
                  : null,
              contentPadding: widget.contentPadding ??
                  EdgeInsetsDirectional.symmetric(vertical: 14, horizontal: 14),
              focusedBorder: widget.focusedBorder ??
                  OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.transparent)),
              enabledBorder: widget.enabledBorder ??
                  OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.transparent)),
              border: widget.border ??
                  OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(12),
                  ),
            ),
            controller: widget.controller,
            keyboardAppearance: Brightness.light,
            autofocus: widget.autoFocus,
            textAlign: widget.textAlign ?? TextAlign.left,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            keyboardType: widget.keyboardType,
            onTap: widget.onTap,
            textCapitalization: widget.textCapitalization,
            obscureText: widget.passwordViewable == true
                ? !_passwordVisible
                : _obscured ?? false,
            focusNode: widget.focusNode ?? _focus,
            enableSuggestions: widget.enableSuggestions,
            onChanged: (String value) {
              setState(() {});
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            textInputAction: widget.textInputAction,
            style: widget.style,
            strutStyle: widget.strutStyle,
            textAlignVertical: widget.textAlignVertical,
            textDirection: widget.textDirection,
            readOnly: widget.readOnly,
            showCursor: widget.showCursor,
            obscuringCharacter: widget.obscuringCharacter,
            smartDashesType: widget.smartDashesType,
            smartQuotesType: widget.smartQuotesType,
            expands: widget.expands,
            maxLength: widget.maxLength,
            mouseCursor: widget.mouseCursor,
            maxLengthEnforcement: widget.maxLengthEnforcement,
            onAppPrivateCommand: widget.onAppPrivateCommand,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            cursorWidth: widget.cursorWidth,
            cursorHeight: widget.cursorHeight,
            onTapOutside: widget.onTapOutside,
            cursorRadius: widget.cursorRadius,
            cursorColor: widget.cursorColor,
            scrollPadding: widget.scrollPadding,
            dragStartBehavior: widget.dragStartBehavior,
            selectionControls: widget.selectionControls,
            onEditingComplete: widget.onEditingComplete,
            onSubmitted: widget.onSubmitted,
            scrollController: widget.scrollController,
            scrollPhysics: widget.scrollPhysics,
            autofillHints: widget.autofillHints,
            clipBehavior: widget.clipBehavior,
          );
        }
      default:
        {
          return TextField(
            key: widget.key,
            decoration: decoration,
            controller: widget.controller,
            keyboardAppearance: Brightness.light,
            autofocus: widget.autoFocus,
            textAlign: widget.textAlign ?? TextAlign.left,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            keyboardType: widget.keyboardType,
            onTap: widget.onTap,
            textCapitalization: widget.textCapitalization,
            obscureText: _obscured ?? false,
            focusNode: widget.focusNode ?? _focus,
            enableSuggestions: widget.enableSuggestions,
            onChanged: (String value) {
              setState(() {});
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            textInputAction: widget.textInputAction,
            style: widget.style,
            strutStyle: widget.strutStyle,
            textAlignVertical: widget.textAlignVertical,
            textDirection: widget.textDirection,
            readOnly: widget.readOnly,
            showCursor: widget.showCursor,
            obscuringCharacter: widget.obscuringCharacter,
            smartDashesType: widget.smartDashesType,
            smartQuotesType: widget.smartQuotesType,
            expands: widget.expands,
            maxLength: widget.maxLength,
            mouseCursor: widget.mouseCursor,
            maxLengthEnforcement: widget.maxLengthEnforcement,
            onAppPrivateCommand: widget.onAppPrivateCommand,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            cursorWidth: widget.cursorWidth,
            cursorHeight: widget.cursorHeight,
            onTapOutside: widget.onTapOutside,
            cursorRadius: widget.cursorRadius,
            cursorColor: widget.cursorColor,
            scrollPadding: widget.scrollPadding,
            dragStartBehavior: widget.dragStartBehavior,
            selectionControls: widget.selectionControls,
            onEditingComplete: widget.onEditingComplete,
            onSubmitted: widget.onSubmitted,
            scrollController: widget.scrollController,
            scrollPhysics: widget.scrollPhysics,
            autofillHints: widget.autofillHints,
            clipBehavior: widget.clipBehavior,
          );
        }
    }
  }
}
