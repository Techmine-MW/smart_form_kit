import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberFormatter extends TextInputFormatter {
  final bool decimal;
  final bool signed;
  final int? minValue;
  final int? maxValue;
  final int? maxLength;
  final NumberFormat _formatter;

  NumberFormatter({
    this.decimal = false,
    this.signed = false,
    this.minValue,
    this.maxValue,
    this.maxLength,
  }) : _formatter = NumberFormat("#,##0${decimal ? '.#####' : ''}", "en_US");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(",", "");

    if (text.isEmpty) {
      return newValue.copyWith(text: "");
    }

    String regexPattern = signed ? r'^-?' : r'^';
    regexPattern += decimal ? r'\d*\.?\d*$' : r'\d*$';

    final isValid = RegExp(regexPattern).hasMatch(text);
    if (!isValid) return oldValue;

    if (signed && text == "-") {
      return newValue;
    }

    if (maxLength != null &&
        text.replaceAll(RegExp(r'[^\d]'), '').length > maxLength!) {
      return oldValue;
    }

    final num? value = decimal ? double.tryParse(text) : int.tryParse(text);
    if (value == null) return oldValue;

    if (minValue != null && value < minValue!) return oldValue;
    if (maxValue != null && value > maxValue!) return oldValue;

    final formatted = _formatter.format(value.abs());
    final finalText = value.isNegative ? "-$formatted" : formatted;

    return TextEditingValue(
      text: finalText,
      selection: TextSelection.collapsed(offset: finalText.length),
    );
  }
}
