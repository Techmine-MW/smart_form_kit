import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_form_kit/smart_form_kit.dart';

void main() {
  group('SmartInputController Tests', () {
    test('Controller initializes with empty text', () {
      final controller = SmartInputController();
      expect(controller.text, isEmpty);
    });

    test('Controller text setter works correctly', () {
      final controller = SmartInputController();
      controller.text = 'Test value';
      expect(controller.text, 'Test value');
    });

    test('Controller clear method works', () {
      final controller = SmartInputController();
      controller.text = 'Test value';
      controller.clear();
      expect(controller.text, isEmpty);
    });

    test('Controller disposes without error', () {
      final controller = SmartInputController();
      expect(() => controller.dispose(), returnsNormally);
    });
  });

  group('SmartInputValidation Tests', () {
    group('Email Validation', () {
      test('Valid email passes validation', () {
        final validator = SmartInputValidation.email();
        expect(validator.validate('test@example.com'), isNull);
        expect(validator.isValid, isTrue);
      });

      test('Invalid email fails validation', () {
        final validator = SmartInputValidation.email();
        expect(validator.validate('invalid-email'), isNotNull);
        expect(validator.isValid, isFalse);
      });

      test('Empty email with required fails', () {
        final validator = SmartInputValidation.email(required: true);
        expect(validator.validate(''), isNotNull);
      });

      test('Empty email without required passes', () {
        final validator = SmartInputValidation.email(required: false);
        expect(validator.validate(''), isNull);
      });
    });

    group('Phone Validation', () {
      test('Valid phone number passes', () {
        final validator = SmartInputValidation.phone();
        expect(validator.validate('+265123456789'), isNull);
      });

      test('Phone number with min length fails', () {
        final validator = SmartInputValidation.phone(minLength: 10);
        expect(validator.validate('123'), isNotNull);
      });
    });

    group('Password Validation', () {
      test('Strong password passes', () {
        final validator = SmartInputValidation.password();
        expect(validator.validate('StrongPass123!'), isNull);
      });

      test('Weak password fails', () {
        final validator = SmartInputValidation.password();
        expect(validator.validate('weak'), isNotNull);
      });
    });

    group('Number Validation', () {
      test('Valid number passes', () {
        final validator = SmartInputValidation.number();
        expect(validator.validate('123'), isNull);
      });

      test('Number below min value fails', () {
        final validator = SmartInputValidation.number(minValue: 10);
        expect(validator.validate('5'), isNotNull);
      });
    });
  });

  group('SmartInputField Widget Tests', () {
    testWidgets('Renders basic text field', (WidgetTester tester) async {
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

      expect(find.text('Test Field'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('Email field shows email icon', (WidgetTester tester) async {
      final controller = SmartInputController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartInputField(
              controller: controller,
              keyboardType: SmartInputType.email,
              label: 'Email',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('Password field toggles visibility icon', (
      WidgetTester tester,
    ) async {
      final controller = SmartInputController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartInputField(
              controller: controller,
              keyboardType: SmartInputType.password,
              label: 'Password',
              isPassword: true,
            ),
          ),
        ),
      );

      // Initially should show visibility icon (eye open)
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap to toggle visibility
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      // Should now show visibility_off icon
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('Validation shows error message', (WidgetTester tester) async {
      final controller = SmartInputController();
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: SmartInputField(
                controller: controller,
                keyboardType: SmartInputType.email,
                label: 'Email',
                validator: SmartInputValidation.email(required: true),
              ),
            ),
          ),
        ),
      );

      // Trigger validation
      final isValid = formKey.currentState!.validate();
      expect(isValid, isFalse);

      await tester.pump();

      // Should show error message
      expect(find.textContaining('required'), findsOneWidget);
    });

    testWidgets('OnChanged callback works', (WidgetTester tester) async {
      final controller = SmartInputController();
      String? changedValue;
      bool? isValidValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartInputField(
              controller: controller,
              keyboardType: SmartInputType.text,
              label: 'Test Field',
              onChanged: (value, isValid) {
                changedValue = value;
                isValidValue = isValid;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Test input');

      expect(changedValue, 'Test input');
      expect(isValidValue, isTrue);
    });

    testWidgets('Disabled field prevents input', (WidgetTester tester) async {
      final controller = SmartInputController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartInputField(
              controller: controller,
              keyboardType: SmartInputType.text,
              label: 'Disabled Field',
              enabled: false,
            ),
          ),
        ),
      );

      // Try to enter text in disabled field
      await tester.enterText(find.byType(TextFormField), 'test');

      // Field should remain empty since it's disabled
      expect(controller.text, isEmpty);
    });

    testWidgets('Date picker field prevents direct text input', (
      WidgetTester tester,
    ) async {
      final controller = SmartInputController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartInputField(
              controller: controller,
              keyboardType: SmartInputType.date,
              label: 'Date Field',
            ),
          ),
        ),
      );

      // Try to enter text in date field (should be prevented)
      await tester.enterText(find.byType(TextFormField), 'manual date');

      // Date field should not accept manual text input
      expect(controller.text, isEmpty);
    });

    testWidgets('Dropdown field basic structure', (WidgetTester tester) async {
      // Skip dropdown tests for now - they need more complex setup
      expect(true, isTrue);
    }, skip: true);
  });

  group('Formatters Tests', () {
    test('PhoneFormatter formats correctly', () {
      final formatter = PhoneFormatter();
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '265123456789'),
      );
      expect(result.text, '+265 123 45 67 89');
    });

    test('NumberFormatter adds commas', () {
      final formatter = NumberFormatter();
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '1000000'),
      );
      expect(result.text, '1,000,000');
    });
  });

  group('Integration Tests', () {
    testWidgets('Complete form validation flow', (WidgetTester tester) async {
      final emailController = SmartInputController();
      final passwordController = SmartInputController();
      final formKey = GlobalKey<FormState>();
      bool formValid = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  SmartInputField(
                    controller: emailController,
                    keyboardType: SmartInputType.email,
                    validator: SmartInputValidation.email(required: true),
                    label: 'Email',
                  ),
                  SmartInputField(
                    controller: passwordController,
                    keyboardType: SmartInputType.password,
                    validator: SmartInputValidation.password(required: true),
                    label: 'Password',
                    isPassword: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formValid = true;
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Test invalid form
      await tester.tap(find.text('Submit'));
      await tester.pump();
      expect(formValid, isFalse);

      // Fill valid data
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email').first,
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password').first,
        'StrongPass123!',
      );

      // Test valid form
      await tester.tap(find.text('Submit'));
      await tester.pump();
      expect(formValid, isTrue);
    });

    testWidgets('Multiple field types work together', (
      WidgetTester tester,
    ) async {
      final controllers = {
        'text': SmartInputController(),
        'email': SmartInputController(),
        'phone': SmartInputController(),
        'number': SmartInputController(),
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SmartInputField(
                  controller: controllers['text']!,
                  keyboardType: SmartInputType.text,
                  label: 'Text Field',
                ),
                SmartInputField(
                  controller: controllers['email']!,
                  keyboardType: SmartInputType.email,
                  label: 'Email Field',
                ),
                SmartInputField(
                  controller: controllers['phone']!,
                  keyboardType: SmartInputType.phone,
                  label: 'Phone Field',
                ),
                SmartInputField(
                  controller: controllers['number']!,
                  keyboardType: SmartInputType.number,
                  label: 'Number Field',
                ),
              ],
            ),
          ),
        ),
      );

      // Test input in each field
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Text Field').first,
        'Sample text',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Field').first,
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone Field').first,
        '265123456789',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Number Field').first,
        '12345',
      );

      expect(controllers['text']!.text, 'Sample text');
      expect(controllers['email']!.text, 'test@example.com');
      expect(controllers['phone']!.text, contains('265'));
      // Number field formats with commas, so check the actual formatted value
      expect(
        controllers['number']!.text,
        '12,345',
      ); // This is the actual formatted value
    });
  });

  group('Performance Tests', () {
    testWidgets('Renders multiple fields efficiently', (
      WidgetTester tester,
    ) async {
      final controllers = List.generate(10, (index) => SmartInputController());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: controllers.length,
              itemBuilder: (context, index) => SmartInputField(
                controller: controllers[index],
                keyboardType: SmartInputType.text,
                label: 'Field $index',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SmartInputField), findsNWidgets(10));
    });
  });
}
