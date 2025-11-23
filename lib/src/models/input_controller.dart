import 'package:flutter/material.dart';

/// Controller for managing SmartInputField state and values
class SmartInputController {
  final TextEditingController textController;

  SmartInputController({TextEditingController? textController})
    : textController = textController ?? TextEditingController();

  /// Get the current text value
  String get text => textController.text;

  /// Set the text value
  set text(String value) => textController.text = value;

  /// Clear the text value
  void clear() {
    textController.clear();
  }

  /// Dispose of controller
  void dispose() {
    textController.dispose();
  }
}
