import 'package:flutter/material.dart';

class SmartInputController {
  final TextEditingController textController;
  final dynamic dropdownController;

  SmartInputController({
    TextEditingController? textController,
    this.dropdownController,
  }) : textController = textController ?? TextEditingController();

  String get text => textController.text;
  set text(String value) => textController.text = value;

  void clear() {
    textController.clear();
  }

  void dispose() {
    textController.dispose();
  }
}