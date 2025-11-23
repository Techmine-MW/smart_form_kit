import 'package:flutter/services.dart';

class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (text.startsWith('265')) {
      text = text.substring(3);
    }

    if (text.length > 9) {
      text = text.substring(0, 9);
    }

    String formatted = '+265 ';
    if (text.isNotEmpty) {
      formatted += text.substring(0, text.length < 3 ? text.length : 3);
    }

    if (text.length > 3) {
      formatted += ' ${text.substring(3, text.length < 5 ? text.length : 5)}';
    }

    if (text.length > 5) {
      formatted += ' ${text.substring(5, text.length < 7 ? text.length : 7)}';
    }

    if (text.length > 7) {
      formatted += ' ${text.substring(7, text.length < 9 ? text.length : 9)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
