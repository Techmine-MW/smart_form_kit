# Smart Form Kit

<div align="center">

![Smart Form Kit](https://img.shields.io/badge/Flutter-Package-blue?style=for-the-badge&logo=flutter)
![Version](https://img.shields.io/pub/v/smart_form_kit?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-blue?style=for-the-badge)

**A comprehensive Flutter form package with smart validation, formatting, and multiple input types. Built by Techmine INC. for robust form handling in Flutter applications.**

[Features](#features) • [Installation](#installation) • [Quick Start](#quick-start) • [Documentation](#documentation) • [Examples](#examples)
</div>
</div>

## 🚀 Overview

Smart Form Kit is an enterprise-grade Flutter package that provides highly customizable, validated, and formatted input fields. It eliminates the complexity of form handling with built-in validation, automatic formatting, and professional error handling.

### Why Smart Form Kit?

| Feature | Traditional Forms | Smart Form Kit |
|---------|------------------|----------------|
| **Validation** | Manual implementation | ✅ Built-in 25+ validators |
| **Formatting** | Custom formatters | ✅ Automatic formatting |
| **Error Handling** | Basic error texts | ✅ Professional error messages |
| **Customization** | Limited options | ✅ Highly customizable |
| **Internationalization** | Complex setup | ✅ Built-in support |

## ✨ Features

### 🎯 Input Types

- **Text & Multiline** - Single/multi-line text inputs
- **Email** - Advanced email validation with domain restrictions
- **Phone** - International phone number support
- **Password** - Configurable strength requirements
- **Number & Price** - Automatic formatting with commas/decimal
- **Date/Time** - Built-in pickers with validation
- **URL** - Protocol and domain validation
- **Dropdown** - Searchable dropdown fields
- **Custom** - Fully customizable validators

### 🛡️ Advanced Validation

- **25+ Validation Types** - Comprehensive coverage
- **Real-time Validation** - Instant feedback
- **Custom Error Messages** - Professional UX
- **Conditional Validation** - Dynamic rules
- **International Support** - Phone, currency, dates

### 🎨 Professional UX

- **Automatic Formatting** - Numbers, phones, prices
- **Loading States** - Skeleton animations
- **Error States** - Clear visual feedback
- **Accessibility** - Full a11y support
- **Theming** - Consistent with your app

### 🔧 Developer Experience

- **Type-Safe** - Full Dart null-safety
- **Well Documented** - Comprehensive examples
- **Easy Integration** - Drop-in replacement
- **Extensible** - Custom validators and formatters
- **Production Ready** - Battle-tested code

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  smart_form_kit: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### Basic Usage

```dart
import 'package:smart_form_kit/smart_form_kit.dart';

class LoginForm extends StatelessWidget {
  final _emailController = SmartInputController();
  final _passwordController = SmartInputController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SmartInputField(
          controller: _emailController,
          keyboardType: SmartInputType.email,
          validator: TInputValidation.email(
            label: 'Email Address',
            customErrorMessage: 'Please enter a valid email address',
          ),
          label: 'Email Address',
        ),
        SizedBox(height: 16),
        SmartInputField(
          controller: _passwordController,
          keyboardType: SmartInputType.password,
          validator: TInputValidation.password(
            minLength: 8,
            requireSpecialChars: true,
          ),
          label: 'Password',
          isPassword: true,
        ),
      ],
    );
  }
}
```

## 📚 Documentation

### Input Types

#### Email Input

```dart
SmartInputField(
  controller: _emailController,
  keyboardType: SmartInputType.email,
  validator: TInputValidation.email(
    label: 'Email',
    allowedDomains: ['gmail.com', 'company.com'],
    blockedDomains: ['temp-mail.org'],
  ),
)
```

#### Phone Input

```dart
SmartInputField(
  controller: _phoneController,
  keyboardType: SmartInputType.phone,
  validator: TInputValidation.phone(
    countryCodes: ['265', '1', '44'],
    minLength: 10,
  ),
  inputFormatters: [PhoneFormatter()],
)
```

#### Password Input

```dart
SmartInputField(
  controller: _passwordController,
  keyboardType: SmartInputType.password,
  validator: TInputValidation.password(
    minLength: 12,
    requireUppercase: true,
    requireLowercase: true,
    requireNumbers: true,
    requireSpecialChars: true,
    maxConsecutiveChars: 3,
  ),
  isPassword: true,
)
```

#### Number & Price Inputs

```dart
// Number input
SmartInputField(
  controller: _numberController,
  keyboardType: SmartInputType.number,
  validator: TInputValidation.number(
    minValue: 0,
    maxValue: 1000,
    allowNegative: false,
  ),
)

// Price input
SmartInputField(
  controller: _priceController,
  keyboardType: SmartInputType.price,
  validator: TInputValidation.price(
    minValue: 0,
    maxDecimalPlaces: 2,
    currencySymbol: 'MWK',
  ),
)
```

#### Date/Time Inputs

```dart
// Date input
SmartInputField(
  controller: _dateController,
  keyboardType: SmartInputType.date,
  validator: TInputValidation.date(
    minDate: DateTime(2000),
    maxDate: DateTime.now(),
    dateFormat: 'dd/MM/yyyy',
  ),
)

// Time input
SmartInputField(
  controller: _timeController,
  keyboardType: SmartInputType.time,
  validator: TInputValidation.time(
    minTime: DateTime(2023, 1, 1, 8, 0), // 8:00 AM
    maxTime: DateTime(2023, 1, 1, 18, 0), // 6:00 PM
  ),
)
```

### Advanced Validation

#### Custom Validator

```dart
SmartInputField(
  controller: _customController,
  validator: TInputValidation.custom(
    pattern: r'^[A-Z]{3}-\d{3}$', // Custom pattern
    customErrorMessage: 'Must follow format: ABC-123',
    customRules: {
      'minLength': 7,
      'maxLength': 7,
    },
  ),
)
```

#### Conditional Validation

```dart
TInputValidation _getDynamicValidator(String type) {
  switch (type) {
    case 'email':
      return TInputValidation.email();
    case 'phone':
      return TInputValidation.phone();
    default:
      return TInputValidation.text();
  }
}
```

### Formatters

#### Phone Formatter

```dart
inputFormatters: [
  FilteringTextInputFormatter.digitsOnly,
  PhoneFormatter(), // Formats as +265 XXX XXX XXX
]
```

#### Number Formatter

```dart
inputFormatters: [
  NumberFormatter(
    decimal: true,
    signed: false,
    maxDecimalPlaces: 2,
  ),
]
```

#### Price Formatter

```dart
inputFormatters: [
  PriceFormatter(), // Formats with commas and decimals
]
```

### Advanced Features

#### Loading States

```dart
SmartInputField(
  controller: _controller,
  isLoading: true, // Shows skeleton loading
  label: 'Loading Field',
)
```

#### Custom Styling

```dart
SmartInputField(
  controller: _controller,
  label: 'Custom Styled Field',
  borderColor: Colors.blue,
  fillColor: Colors.grey[100],
  icon: Icons.person,
  labelFontSize: 16,
)
```

#### Dropdown Fields

```dart
SmartInputField(
  controller: _dropdownController,
  keyboardType: DropdownInputType(
    items: ['Option 1', 'Option 2', 'Option 3'],
    dropDownValues: [
      DropDownValueModel(name: 'Option 1', value: '1'),
      DropDownValueModel(name: 'Option 2', value: '2'),
    ],
  ),
  validator: TInputValidation.dropdown(),
  enableSearch: true,
  clearOption: true,
)
```

## 🎯 Complete Examples

### Registration Form

```dart
class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = SmartInputController();
  final _phoneController = SmartInputController();
  final _passwordController = SmartInputController();
  final _confirmPasswordController = SmartInputController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with registration
      print('Registration successful!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SmartInputField(
            controller: _emailController,
            keyboardType: SmartInputType.email,
            validator: TInputValidation.email(
              label: 'Email Address',
            ),
            label: 'Email Address',
            icon: Icons.email,
          ),
          SizedBox(height: 16),
          SmartInputField(
            controller: _phoneController,
            keyboardType: SmartInputType.phone,
            validator: TInputValidation.phone(),
            label: 'Phone Number',
            icon: Icons.phone,
          ),
          SizedBox(height: 16),
          SmartInputField(
            controller: _passwordController,
            keyboardType: SmartInputType.password,
            validator: TInputValidation.password(
              minLength: 8,
              requireSpecialChars: true,
            ),
            label: 'Password',
            isPassword: true,
          ),
          SizedBox(height: 16),
          SmartInputField(
            controller: _confirmPasswordController,
            keyboardType: SmartInputType.password,
            validator: TInputValidation.custom(
              customErrorMessage: 'Passwords must match',
              customRules: {
                'matchField': _passwordController,
              },
            ),
            label: 'Confirm Password',
            isPassword: true,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}
```

### Payment Form

```dart
class PaymentForm extends StatelessWidget {
  final _amountController = SmartInputController();
  final _cardController = SmartInputController();
  final _dateController = SmartInputController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SmartInputField(
          controller: _amountController,
          keyboardType: SmartInputType.price,
          validator: TInputValidation.price(
            minValue: 1,
            maxValue: 10000,
            currencySymbol: 'MWK',
          ),
          label: 'Amount',
          prefixIcon: Icon(Icons.attach_money),
        ),
        SizedBox(height: 16),
        SmartInputField(
          controller: _cardController,
          keyboardType: SmartInputType.creditCard,
          validator: TInputValidation.creditCard(),
          label: 'Card Number',
          icon: Icons.credit_card,
        ),
        SizedBox(height: 16),
        SmartInputField(
          controller: _dateController,
          keyboardType: SmartInputType.date,
          validator: TInputValidation.date(
            minDate: DateTime.now(),
            maxDate: DateTime.now().add(Duration(days: 365)),
          ),
          label: 'Expiry Date',
          icon: Icons.calendar_today,
        ),
      ],
    );
  }
}
```

## 🔧 API Reference

### SmartInputField Properties

| Property | Type | Description |
|----------|------|-------------|
| `controller` | `SmartInputController` | Required field controller |
| `keyboardType` | `SmartInputType` | Input type (email, phone, etc.) |
| `validator` | `TInputValidation` | Validation rules |
| `label` | `String` | Field label |
| `isPassword` | `bool` | Password visibility toggle |
| `isLoading` | `bool` | Loading skeleton state |
| `enabled` | `bool` | Enable/disable field |
| `readOnly` | `bool` | Read-only mode |
| `maxLines` | `int` | Multi-line support |
| `maxLength` | `int` | Character limit |
| `onChanged` | `Function(String, bool)` | Value change callback |
| `inputFormatters` | `List<TextInputFormatter>` | Custom formatters |

### Validation Types

| Validator | Description | Options |
|-----------|-------------|---------|
| `email()` | Email validation | Domains, format |
| `phone()` | Phone validation | Country codes, length |
| `password()` | Password strength | Length, characters |
| `number()` | Number validation | Range, decimals |
| `price()` | Currency validation | Format, symbols |
| `date()` | Date validation | Range, format |
| `url()` | URL validation | Protocol, domains |
| `custom()` | Custom validation | Pattern, rules |

## 🛠️ Migration Guide

### From Traditional TextField

**Before:**

```dart
TextFormField(
  controller: _controller,
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
      return 'Invalid email';
    }
    return null;
  },
)
```

**After:**

```dart
SmartInputField(
  controller: _controller,
  keyboardType: SmartInputType.email,
  validator: TInputValidation.email(),
)
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

```bash
git clone https://github.com/Techmine-MW/smart_form_kit.git
cd smart_form_kit
flutter pub get
cd example
flutter run
```

## 📄 License

```
MIT License

Copyright (c) 2025 Techmine INC.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 👥 Authors

- **Techmine INC.** - [techminemw.com](https://techminemw.com)

## 🌟 Support

- **Documentation**: [docs.techminemw.com/smart-form-kit](https://docs.techminemw.com/smart-form-kit)
- **Issues**: [GitHub Issues](https://github.com/Techmine-MW/smart_form_kit/issues)
- **Email**: <info@techminemw.com>

## 🙏 Acknowledgments

- Flutter Team for the amazing framework
- Community contributors
- Our users for valuable feedback

---

<div align="center">

**Built with ❤️ by [Techmine INC.](https://techminemw.com)**

[![Techmine INC.](https://img.shields.io/badge/Powered%20by-Tech%20Mine%20MW-2E8B57.svg)](https://techminemw.com)

</div>
