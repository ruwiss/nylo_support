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
        Field("Email",
            cast: FormCast.email(),
            validate: FormValidator.rule(emailValidationRule ?? "email",
                message: emailValidationMessage),
            style: _style),
        Field("Password",
            cast: FormCast.password(viewable: passwordViewable),
            validate: passwordValidationRule == null ? null : FormValidator.rule(
                passwordValidationRule,
                message: passwordValidationMessage),
            style: _style),
      ];

  /// Dummy data for the form
  /// This is used to populate the form with dummy data
  /// It will be removed when your .env file is set to production
  @override
  Map<String, dynamic> dummyData() => _dummyData;
}
