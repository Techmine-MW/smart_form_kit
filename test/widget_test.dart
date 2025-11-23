import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_form_kit/smart_form_kit.dart';

void main() {
  // Simple widget tests without golden files
  testWidgets('SmartInputField renders without crashing', (
    WidgetTester tester,
  ) async {
    final controller = SmartInputController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SmartInputField(
            controller: controller,
            keyboardType: SmartInputType.text,
            label: 'Test Field',
          ),
        ),
      ),
    );

    expect(find.byType(SmartInputField), findsOneWidget);
  });

  testWidgets('SmartInputField different states render', (
    WidgetTester tester,
  ) async {
    final controller = SmartInputController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              // Normal state
              SmartInputField(
                controller: controller,
                keyboardType: SmartInputType.text,
                label: 'Normal Field',
              ),
              // Error state
              SmartInputField(
                controller: SmartInputController(),
                keyboardType: SmartInputType.email,
                label: 'Error Field',
                validator: SmartInputValidation.email(),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(SmartInputField), findsNWidgets(2));
  });
}
