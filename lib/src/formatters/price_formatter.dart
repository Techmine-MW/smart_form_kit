import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PriceFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,##0.##", "en_US");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(",", "");

    if (text.isEmpty) {
      return newValue.copyWith(text: "");
    }

    final isValid = RegExp(r'^-?\d*\.?\d*$').hasMatch(text);
    if (!isValid) return oldValue;

    if (text == "-") {
      return newValue;
    }

    final double? value = double.tryParse(text);
    if (value == null) return oldValue;

    final newText = _formatter.format(value.abs());
    final formatted = value.isNegative ? "-$newText" : newText;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}