import 'package:flutter/material.dart';
import 'package:smart_form_kit/smart_form_kit.dart';

void main() {
  runApp(const SmartFormKitExampleApp());
}

class SmartFormKitExampleApp extends StatelessWidget {
  const SmartFormKitExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Form Kit Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const RegistrationFormExample(),
    const PaymentFormExample(),
    const AdvancedFormExample(),
    const ValidationDemoExample(),
  ];

  final List<String> _pageTitles = [
    'Registration Form',
    'Payment Form',
    'Advanced Features',
    'Validation Demo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_currentIndex]),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Registration',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Advanced',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified),
            label: 'Validation',
          ),
        ],
      ),
    );
  }
}

/// Example 1: Complete Registration Form
class RegistrationFormExample extends StatefulWidget {
  const RegistrationFormExample({super.key});

  @override
  State<RegistrationFormExample> createState() =>
      _RegistrationFormExampleState();
}

class _RegistrationFormExampleState extends State<RegistrationFormExample> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = SmartInputController();
  final _lastNameController = SmartInputController();
  final _emailController = SmartInputController();
  final _phoneController = SmartInputController();
  final _passwordController = SmartInputController();
  final _confirmPasswordController = SmartInputController();
  final _birthDateController = SmartInputController();

  bool _isLoading = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        _showSuccessDialog();
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success!'),
        content: const Text('Registration completed successfully.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _birthDateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Create Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please fill in all required fields to create your account.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Personal Information Section
            _buildSectionHeader('Personal Information'),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: SmartInputField(
                    controller: _firstNameController,
                    keyboardType: SmartInputType.text,
                    validator: SmartInputValidation.text(
                      label: 'First Name',
                      required: true,
                      minLength: 2,
                      maxLength: 50,
                    ),
                    label: 'First Name *',
                    icon: Icons.person_outline,
                    maxLength: 50,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SmartInputField(
                    controller: _lastNameController,
                    keyboardType: SmartInputType.text,
                    validator: SmartInputValidation.text(
                      label: 'Last Name',
                      required: true,
                      minLength: 2,
                      maxLength: 50,
                    ),
                    label: 'Last Name *',
                    maxLength: 50,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SmartInputField(
              controller: _emailController,
              keyboardType: SmartInputType.email,
              validator: SmartInputValidation.email(
                label: 'Email Address',
                required: true,
                allowedDomains: ['gmail.com', 'yahoo.com', 'outlook.com'],
              ),
              label: 'Email Address *',
              icon: Icons.email_outlined,
              tooltipMessage: 'We\'ll never share your email with anyone else',
            ),
            const SizedBox(height: 16),

            SmartInputField(
              controller: _phoneController,
              keyboardType: SmartInputType.phone,
              validator: SmartInputValidation.phone(
                label: 'Phone Number',
                required: true,
                minLength: 10,
                maxLength: 15,
              ),
              label: 'Phone Number *',
              icon: Icons.phone_outlined,
              inputFormatters: [PhoneFormatter()],
            ),
            const SizedBox(height: 16),

            SmartInputField(
              controller: _birthDateController,
              keyboardType: SmartInputType.date,
              validator: SmartInputValidation.date(
                label: 'Birth Date',
                required: true,
                minDate: DateTime(1900),
                maxDate:
                    DateTime.now().subtract(const Duration(days: 365 * 18)),
                dateFormat: 'dd/MM/yyyy',
              ),
              label: 'Birth Date *',
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 24),

            // Security Section
            _buildSectionHeader('Security'),
            const SizedBox(height: 16),

            SmartInputField(
              controller: _passwordController,
              keyboardType: SmartInputType.password,
              validator: SmartInputValidation.password(
                label: 'Password',
                required: true,
                minLength: 8,
                requireUppercase: true,
                requireLowercase: true,
                requireNumbers: true,
                requireSpecialChars: true,
              ),
              label: 'Password *',
              isPassword: true,
              icon: Icons.lock_outline,
            ),
            const SizedBox(height: 16),

            SmartInputField(
              controller: _confirmPasswordController,
              keyboardType: SmartInputType.password,
              validator: SmartInputValidation.custom(
                label: 'Confirm Password',
                required: true,
                customErrorMessage: 'Passwords must match',
                customRules: {'matchField': _passwordController},
              ),
              label: 'Confirm Password *',
              isPassword: true,
              icon: Icons.lock_outline,
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text(
                      'Create Account',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _resetForm,
              child: const Text('Reset Form'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          height: 2,
          width: 20,
          color: Colors.blue[700],
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }
}

/// Example 2: Payment Form
class PaymentFormExample extends StatefulWidget {
  const PaymentFormExample({super.key});

  @override
  State<PaymentFormExample> createState() => _PaymentFormExampleState();
}

class _PaymentFormExampleState extends State<PaymentFormExample> {
  final _amountController = SmartInputController();
  final _cardNumberController = SmartInputController();
  final _expiryDateController = SmartInputController();
  final _cvvController = SmartInputController();
  final _nameController = SmartInputController();

  void _processPayment() {
    // Payment processing logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: const Text('Your payment has been processed successfully.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter your payment information securely.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                SmartInputField(
                  controller: _amountController,
                  keyboardType: SmartInputType.price,
                  validator: SmartInputValidation.price(
                    label: 'Amount',
                    required: true,
                    minValue: 1,
                    maxValue: 100000,
                    maxDecimalPlaces: 2,
                    allowNegative: false,
                  ),
                  label: 'Amount (MWK)',
                  prefixIcon: const Icon(Icons.attach_money_outlined),
                ),
                const SizedBox(height: 16),
                SmartInputField(
                  controller: _nameController,
                  keyboardType: SmartInputType.text,
                  validator: SmartInputValidation.text(
                    label: 'Cardholder Name',
                    required: true,
                    minLength: 3,
                  ),
                  label: 'Cardholder Name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                SmartInputField(
                  controller: _cardNumberController,
                  keyboardType: SmartInputType.creditCard,
                  validator: SmartInputValidation.creditCard(),
                  label: 'Card Number',
                  icon: Icons.credit_card_outlined,
                  maxLength: 19,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SmartInputField(
                        controller: _expiryDateController,
                        keyboardType: SmartInputType.date,
                        validator: SmartInputValidation.date(
                          label: 'Expiry Date',
                          required: true,
                          minDate: DateTime.now(),
                          maxDate: DateTime.now()
                              .add(const Duration(days: 365 * 10)),
                          dateFormat: 'MM/yy',
                        ),
                        label: 'Expiry Date',
                        icon: Icons.calendar_today_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SmartInputField(
                        controller: _cvvController,
                        keyboardType: SmartInputType.number,
                        validator: SmartInputValidation.number(
                          label: 'CVV',
                          required: true,
                          minValue: 100,
                          maxValue: 999,
                        ),
                        label: 'CVV',
                        icon: Icons.lock_outline,
                        maxLength: 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Example 3: Advanced Features Demo
class AdvancedFormExample extends StatefulWidget {
  const AdvancedFormExample({super.key});

  @override
  State<AdvancedFormExample> createState() => _AdvancedFormExampleState();
}

class _AdvancedFormExampleState extends State<AdvancedFormExample> {
  final _multilineController = SmartInputController();
  final _urlController = SmartInputController();
  final _usernameController = SmartInputController();
  final _customController = SmartInputController();

  final List<DropDownValueModel> _countries = [
    DropDownValueModel(name: 'Malawi', value: 'MW'),
    DropDownValueModel(name: 'South Africa', value: 'ZA'),
    DropDownValueModel(name: 'Zambia', value: 'ZM'),
    DropDownValueModel(name: 'Tanzania', value: 'TZ'),
    DropDownValueModel(name: 'Kenya', value: 'KE'),
    DropDownValueModel(name: 'Nigeria', value: 'NG'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(
            'Advanced Features',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore advanced input types and features.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Multiline Text Area
          _buildFeatureCard(
            title: 'Multiline Text Area',
            description: 'Resizable text area for long content',
            child: SmartInputField(
              controller: _multilineController,
              keyboardType: SmartInputType.multiline,
              validator: SmartInputValidation.text(
                label: 'Description',
                minLength: 10,
                maxLength: 500,
              ),
              label: 'Description',
              maxLines: null,
              icon: Icons.description_outlined,
            ),
          ),

          const SizedBox(height: 20),

          // URL Input
          _buildFeatureCard(
            title: 'URL Input',
            description: 'Website URL with protocol validation',
            child: SmartInputField(
              controller: _urlController,
              keyboardType: SmartInputType.url,
              validator: SmartInputValidation.url(
                requireProtocol: true,
                allowedDomains: ['techminemw.com', 'github.com'],
              ),
              label: 'Website URL',
              icon: Icons.link_outlined,
            ),
          ),

          const SizedBox(height: 20),

          // Username with Custom Validation
          _buildFeatureCard(
            title: 'Custom Username',
            description: 'Username with specific format requirements',
            child: SmartInputField(
              controller: _usernameController,
              keyboardType: SmartInputType.text,
              validator: SmartInputValidation.username(
                minLength: 4,
                maxLength: 20,
                allowSpecialChars: false,
              ),
              label: 'Username',
              icon: Icons.person_outline,
            ),
          ),

          const SizedBox(height: 20),

          // Searchable Dropdown
          _buildFeatureCard(
            title: 'Searchable Dropdown',
            description: 'Dropdown with search functionality',
            child: SmartInputField(
              controller: SmartInputController(),
              keyboardType: DropdownInputType(
                items: _countries,
                dropDownValues: _countries,
              ),
              validator: SmartInputValidation.dropdown(),
              label: 'Select Country',
              enableSearch: true,
              clearOption: true,
              icon: Icons.location_on_outlined,
            ),
          ),

          const SizedBox(height: 20),

          // Custom Pattern Validation
          _buildFeatureCard(
            title: 'Custom Pattern',
            description: 'Input following specific format (XXX-123)',
            child: SmartInputField(
              controller: _customController,
              keyboardType: SmartInputType.text,
              validator: SmartInputValidation.custom(
                pattern: r'^[A-Z]{3}-\d{3}$',
                customErrorMessage: 'Must follow format: ABC-123',
              ),
              label: 'Custom Code',
              icon: Icons.code_outlined,
              maxLength: 7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// Example 4: Validation Demo
class ValidationDemoExample extends StatefulWidget {
  const ValidationDemoExample({super.key});

  @override
  State<ValidationDemoExample> createState() => _ValidationDemoExampleState();
}

class _ValidationDemoExampleState extends State<ValidationDemoExample> {
  final Map<String, SmartInputController> _controllers = {};
  final Map<String, SmartInputValidation> _validators = {};

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final fields = {
      'email': SmartInputValidation.email(),
      'phone': SmartInputValidation.phone(),
      'password': SmartInputValidation.password(),
      'number': SmartInputValidation.number(minValue: 1, maxValue: 100),
      'url': SmartInputValidation.url(),
      'date': SmartInputValidation.date(),
    };

    for (var entry in fields.entries) {
      _controllers[entry.key] = SmartInputController();
      _validators[entry.key] = entry.value;
    }
  }

  void _testAllValidations() {
    bool allValid = true;

    for (var key in _controllers.keys) {
      final controller = _controllers[key]!;
      final validator = _validators[key]!;
      final error = validator.validate(controller.text);

      if (error != null) {
        allValid = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$key: $error'),
            backgroundColor: Colors.red,
          ),
        );
        break;
      }
    }

    if (allValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All validations passed!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Validation Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Test different validation types in real-time.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                _buildValidationField('Email', 'email', Icons.email_outlined),
                _buildValidationField('Phone', 'phone', Icons.phone_outlined),
                _buildValidationField(
                    'Password', 'password', Icons.lock_outlined),
                _buildValidationField(
                    'Number (1-100)', 'number', Icons.numbers_outlined),
                _buildValidationField('URL', 'url', Icons.link_outlined),
                _buildValidationField(
                    'Date', 'date', Icons.calendar_today_outlined),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _testAllValidations,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              'Test All Validations',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationField(String label, String key, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SmartInputField(
        controller: _controllers[key]!,
        keyboardType: _getKeyboardType(key),
        validator: _validators[key]!,
        label: label,
        icon: icon,
        onChanged: (value, isValid) {
          // Real-time validation feedback
          if (value.isNotEmpty) {
            // ignore: unused_local_variable
            final color = isValid ? Colors.green : Colors.red;
            // You could add visual feedback here
          }
        },
      ),
    );
  }

  SmartInputType _getKeyboardType(String key) {
    switch (key) {
      case 'email':
        return SmartInputType.email;
      case 'phone':
        return SmartInputType.phone;
      case 'password':
        return SmartInputType.password;
      case 'number':
        return SmartInputType.number;
      case 'url':
        return SmartInputType.url;
      case 'date':
        return SmartInputType.date;
      default:
        return SmartInputType.text;
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
