import 'package:nylo_support/widgets/ny_form.dart';

/// NyLoginForm class
class NyLoginForm extends NyFormData {
  NyLoginForm(
      {String? name,
      this.emailValidationRule,
      this.emailValidationMessage = null,
      this.passwordValidationRule,
      this.passwordValidationMessage = null,
      this.passwordViewable = true,
      String? style,
      Map<String, dynamic> dummyData = const {}})
      : _dummyData = dummyData,
        _style = style ?? "compact",
        super(name ?? "login");

  /// Email field - Validation rule
  String? emailValidationRule;

  /// Email field - Validation message
  String? emailValidationMessage;

  /// Password field - Validation rule
  String? passwordValidationRule;

  /// Password field - Validation message
  String? passwordValidationMessage;

  /// Password viewable
  bool passwordViewable;

  /// Style of the fields
  String? _style;

  /// Dummy data
  Map<String, dynamic> _dummyData = {};

  @override
  fields() => [
        Field("Email", value: ""),
        Field("Password", value: ""),
      ];

  /// Cast the fields to their respective types
  /// All available types are below
  /// https://nylo.dev/docs/5.20.0/form#casts
  @override
  Map<String, dynamic> cast() => {
        "Email": FormCast.email(),
        "Password": FormCast.password(viewable: passwordViewable),
      };

  /// Validate the fields
  /// All available validations are below
  /// https://nylo.dev/docs/5.20.0/validation#validation-rules
  @override
  Map<String, dynamic> validate() => {
        "Email": FormValidator(emailValidationRule ?? "email",
            message: emailValidationMessage),
        "Password": FormValidator(passwordValidationRule ?? "password_v1",
            message: passwordValidationMessage),
      };

  /// Dummy data for the form
  /// This is used to populate the form with dummy data
  /// It will be removed when your .env file is set to production
  @override
  Map<String, dynamic> dummyData() => _dummyData;

  /// Style the fields
  /// This is used to style the fields
  /// Options: compact
  @override
  Map<String, dynamic> style() => {
        "Email": _style,
        "Password": _style,
      };
}
