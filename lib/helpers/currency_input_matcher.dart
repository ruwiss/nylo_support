import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

/// Currency meta data
class CurrencyMeta {
  /// Currency symbol
  String symbol;

  /// Initial value
  String initialValue = "";

  /// Currency formatter
  CurrencyInputFormatter formatter;

  CurrencyMeta(
      {required this.symbol, required this.formatter, this.initialValue = ""});
}

/// Currency input matcher
class CurrencyInputMatcher {
  static final RegExp _currencyRegExp = RegExp(r'^\d{1,3}(,\d{3})*(\.\d{2})?$');

  /// Check if the currency is supported
  static bool isSupported(String value) {
    return _currencyRegExp.hasMatch(value);
  }

  /// Get all supported currencies
  static List<String> currencies = [
    "gbp",
    "usd",
    "vnd",
    "thb",
    "twd",
    "eur",
    "myr",
    "jpy",
    "aud",
    "cny",
    "cad",
    "inr",
    "idr",
    "sgd",
    "zar",
    "pkr",
  ];

  /// Get the currency meta data
  static CurrencyMeta getCurrencyMeta(String castTo,
      {required String value, void Function(num? value)? onChanged}) {
    String defaultValue = "";
    String symbol = "";
    CurrencyInputFormatter? formatter;
    switch (castTo) {
      case "currency:gbp":
        symbol = "£";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:usd":
        symbol = "\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:vnd":
        symbol = "₫";
        defaultValue = value + " " + symbol;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " " + symbol,
        );
        break;
      case "currency:thb":
        symbol = "฿";
        defaultValue = value + " " + symbol;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " " + symbol,
        );
        break;
      case "currency:twd":
        symbol = "NT\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:eur":
        symbol = "€";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
            onValueChange: onChanged, trailingSymbol: " " + symbol);
        break;
      case "currency:myr":
        symbol = "RM";
        defaultValue = "$symbol $value";
        formatter = CurrencyInputFormatter(
            onValueChange: onChanged, leadingSymbol: symbol);
        break;
      case "currency:jpy":
        symbol = "¥";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:aud":
        symbol = "A\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:cny":
        symbol = "¥";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:cad":
        symbol = "\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:inr":
        symbol = "₹";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:idr":
        symbol = "Rp";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:sgd":
        symbol = "S\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:zar":
        symbol = "R";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:pkr":
        symbol = "Rs";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
    }

    if (formatter == null) {
      throw Exception("Currency not supported");
    }

    return CurrencyMeta(
        symbol: symbol, formatter: formatter, initialValue: defaultValue);
  }
}
