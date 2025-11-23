// input_validation.dart
import 'package:intl/intl.dart';

/// Advanced input validation class with comprehensive validation rules
/// and professional error handling for Flutter applications.
class SmartInputValidation {
  final String? label;
  final bool required;
  final int? minLength;
  final int? maxLength;
  final num? minValue;
  final num? maxValue;
  final String? pattern;
  final String? customErrorMessage;
  final bool allowDecimals;
  final bool allowNegative;
  final int? maxDecimalPlaces;
  final bool allowWhitespace;
  final bool trimValue;

  // Date/Time validations
  final DateTime? minDate;
  final DateTime? maxDate;
  final DateTime? minTime;
  final DateTime? maxTime;
  final DateTime? minDateTime;
  final DateTime? maxDateTime;
  final String? dateFormat;
  final String? timeFormat;
  final String? datetimeFormat;

  // Advanced validations
  final ValidationType? validationType;
  final Map<String, dynamic>? customValidation;

  SmartInputValidation._({
    this.label,
    this.required = false,
    this.minLength,
    this.maxLength,
    this.minValue,
    this.maxValue,
    this.pattern,
    this.customErrorMessage,
    this.allowDecimals = false,
    this.allowNegative = false,
    this.maxDecimalPlaces,
    this.allowWhitespace = true,
    this.trimValue = true,
    this.minDate,
    this.maxDate,
    this.minTime,
    this.maxTime,
    this.minDateTime,
    this.maxDateTime,
    this.dateFormat,
    this.timeFormat,
    this.datetimeFormat,
    this.validationType,
    this.customValidation,
  });

  bool _isValid = false;
  bool get isValid => _isValid;

  // ============ FACTORY CONSTRUCTORS ============

  /// Email Validator with advanced options
  factory SmartInputValidation.email({
    String? label,
    bool required = true,
    String? customErrorMessage,
    bool allowPlus = true,
    bool allowMultipleDots = false,
    List<String>? allowedDomains,
    List<String>? blockedDomains,
  }) {
    String pattern = allowPlus
        ? r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$'
        : r'^[a-zA-Z0-9.!#$%&’*/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$';

    if (!allowMultipleDots) {
      pattern =
          r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$';
    }

    return SmartInputValidation._(
      label: label,
      required: required,
      pattern: pattern,
      customErrorMessage: customErrorMessage,
      validationType: ValidationType.email,
      customValidation: {
        'allowedDomains': allowedDomains,
        'blockedDomains': blockedDomains,
      },
    );
  }

  /// Phone Validator with international support
  factory SmartInputValidation.phone({
    String? label,
    bool required = true,
    int minLength = 8,
    int maxLength = 15,
    String? customErrorMessage,
    List<String>? countryCodes,
    bool allowInternational = true,
    List<String>? allowedFormats,
  }) {
    // Enhanced international phone pattern
    const pattern = r'^[\+]?[1-9][\d]{0,15}$|^[0-9\-\s\(\)]{8,20}$';

    return SmartInputValidation._(
      label: label,
      required: required,
      minLength: minLength,
      maxLength: maxLength,
      pattern: pattern,
      customErrorMessage: customErrorMessage,
      validationType: ValidationType.phone,
      customValidation: {
        'countryCodes': countryCodes ?? ['265'],
        'allowInternational': allowInternational,
        'allowedFormats': allowedFormats,
      },
    );
  }

  /// Advanced Password Validator with configurable requirements
  factory SmartInputValidation.password({
    String? label,
    bool required = true,
    int minLength = 8,
    int maxLength = 128,
    String? customErrorMessage,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = true,
    int? minUniqueChars,
    int? maxConsecutiveChars,
    List<String>? commonPasswords,
  }) {
    final buffer = StringBuffer(r'^');

    if (requireUppercase) buffer.write(r'(?=.*[A-Z])');
    if (requireLowercase) buffer.write(r'(?=.*[a-z])');
    if (requireNumbers) buffer.write(r'(?=.*\d)');
    if (requireSpecialChars) buffer.write(r'(?=.*[\W_])');

    buffer.write(r'.{');
    buffer.write(minLength);
    buffer.write(',');
    buffer.write(maxLength);
    buffer.write(r'}$');

    return SmartInputValidation._(
      label: label,
      required: required,
      minLength: minLength,
      maxLength: maxLength,
      pattern: buffer.toString(),
      customErrorMessage: customErrorMessage,
      validationType: ValidationType.password,
      customValidation: {
        'requireUppercase': requireUppercase,
        'requireLowercase': requireLowercase,
        'requireNumbers': requireNumbers,
        'requireSpecialChars': requireSpecialChars,
        'minUniqueChars': minUniqueChars,
        'maxConsecutiveChars': maxConsecutiveChars,
        'commonPasswords': commonPasswords ?? _getCommonPasswords(),
      },
    );
  }

  /// Credit Card Validator
  factory SmartInputValidation.creditCard({
    String? label,
    bool required = true,
    String? customErrorMessage,
    List<CardType> allowedCardTypes = CardType.values,
  }) {
    return SmartInputValidation._(
      label: label,
      required: required,
      pattern: r'^[0-9\s]{13,19}$',
      customErrorMessage: customErrorMessage,
      validationType: ValidationType.creditCard,
      customValidation: {'allowedCardTypes': allowedCardTypes},
    );
  }

  /// URL Validator with protocol options
  factory SmartInputValidation.url({
    String? label,
    bool required = false,
    String? customErrorMessage,
    bool requireProtocol = false,
    List<String>? allowedDomains,
    List<String>? blockedDomains,
  }) {
    final protocol = requireProtocol ? r'^(https?:\/\/)' : r'^(https?:\/\/)?';
    const pattern = r'([\w\-])+\.{1}([a-zA-Z]{2,63})([\/\w\.-]*)*\/?$';

    return SmartInputValidation._(
      label: label,
      required: required,
      pattern: protocol + pattern,
      customErrorMessage: customErrorMessage,
      validationType: ValidationType.url,
      customValidation: {
        'requireProtocol': requireProtocol,
        'allowedDomains': allowedDomains,
        'blockedDomains': blockedDomains,
      },
    );
  }

  /// IP Address Validator (IPv4 & IPv6)
  factory SmartInputValidation.ipAddress({
    String? label,
    bool required = true,
    String? customErrorMessage,
    bool allowIPv4 = true,
    bool allowIPv6 = true,
  }) {
    String pattern = '';
    if (allowIPv4 && allowIPv6) {
      pattern =
          r'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$|^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$';
    } else if (allowIPv4) {
      pattern =
          r'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$';
    } else if (allowIPv6) {
      pattern = r'^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$';
    }

    return SmartInputValidation._(
      label: label,
      required: required,
      pattern: pattern,
      customErrorMessage: customErrorMessage,
      validationType: ValidationType.ipAddress,
    );
  }

  /// Hexadecimal Color Validator
  factory SmartInputValidation.hexColor({
    String? label,
    bool required = true,
    String? customErrorMessage,
    bool allowShortFormat = true,
  }) {
    final pattern = allowShortFormat
        ? r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$'
        : r'^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$';

    return SmartInputValidation._(
      label: label,
      required: required,
      pattern: pattern,
      customErrorMessage: customErrorMessage,
      validationType: ValidationType.hexColor,
    );
  }

  /// UUID Validator
  factory SmartInputValidation.uuid({
    String? label,
    bool required = true,
    String? customErrorMessage,
    List<UuidVersion> versions = UuidVersion.values,
  }) {
    return SmartInputValidation._(
      label: label,
      required: required,
      pattern:
          r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
      customErrorMessage: customErrorMessage,
      validationType: ValidationType.uuid,
      customValidation: {'versions': versions},
    );
  }

  /// JSON Validator
  factory SmartInputValidation.json({
    String? label,
    bool required = true,
    String? customErrorMessage,
  }) {
    return SmartInputValidation._(
      label: label,
      required: required,
      customErrorMessage: customErrorMessage,
      validationType: ValidationType.json,
    );
  }

  /// ISBN Validator (10 & 13)
  factory SmartInputValidation.isbn({
    String? label,
    bool required = true,
    String? customErrorMessage,
  }) {
    const pattern =
        r'^(?:ISBN(?:-1[03])?:? )?(?=[0-9X]{10}$|(?=(?:[0-9]+[- ]){3})[- 0-9X]{13}$|97[89][0-9]{10}$|(?=(?:[0-9]+[- ]){4})[- 0-9]{17}$)(?:97[89][- ]?)?[0-9]{1,5}[- ]?[0-9]+[- ]?[0-9]+[- ]?[0-9X]$';

    return SmartInputValidation._(
      label: label,
      required: required,
      pattern: pattern,
      customErrorMessage: customErrorMessage,
      validationType: ValidationType.isbn,
    );
  }

  /// MAC Address Validator
  factory SmartInputValidation.macAddress({
    String? label,
    bool required = true,
    String? customErrorMessage,
  }) {
    const pattern = r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$';

    return SmartInputValidation._(
      label: label,
      required: required,
      pattern: pattern,
      customErrorMessage: customErrorMessage,
      validationType: ValidationType.macAddress,
    );
  }

  /// Price/Currency Validator
  factory SmartInputValidation.price({
    String? label,
    bool required = true,
    num? minValue,
    num? maxValue,
    int maxDecimalPlaces = 2,
    bool allowNegative = false,
    String? currencySymbol,
    String? customErrorMessage,
  }) {
    final decimalPart = maxDecimalPlaces > 0
        ? r'(\.\d{1,' + maxDecimalPlaces.toString() + r'})?'
        : '';
    final signPart = allowNegative ? r'-?' : '';
    final pattern = r'^' + signPart + r'\d{1,3}(,\d{3})*' + decimalPart + r'$';

    return SmartInputValidation._(
      label: label,
      required: required,
      minValue: minValue,
      maxValue: maxValue,
      allowDecimals: maxDecimalPlaces > 0,
      allowNegative: allowNegative,
      maxDecimalPlaces: maxDecimalPlaces,
      pattern: pattern,
      customErrorMessage: customErrorMessage,
      validationType: ValidationType.price,
      customValidation: {'currencySymbol': currencySymbol},
    );
  }

  /// Number Validator with advanced options
  /// Number Validator with advanced options
  factory SmartInputValidation.number({
    String? label,
    bool required = true,
    num? minValue,
    num? maxValue,
    int maxDecimalPlaces = 0,
    bool allowNegative = false,
    bool allowCommas = true,
    bool allowDecimals = false,
    String? customErrorMessage,
  }) {
    // Sign
    final signPart = allowNegative ? r'-?' : '';

    // Integer part (with or without commas)
    final commaPart = allowCommas ? r'\d{1,3}(,\d{3})*' : r'\d+';

    // Decimal part
    final decimalPart = allowDecimals
        ? (maxDecimalPlaces > 0
              ? r'(\.\d{1,' + maxDecimalPlaces.toString() + r'})?'
              : r'(\.\d+)?') // if decimals allowed but no max specified
        : ''; // no decimals allowed

    final pattern = r'^' + signPart + commaPart + decimalPart + r'$';

    return SmartInputValidation._(
      label: label,
      required: required,
      minValue: minValue,
      maxValue: maxValue,
      allowDecimals: allowDecimals,
      allowNegative: allowNegative,
      maxDecimalPlaces: allowDecimals ? maxDecimalPlaces : 0,
      pattern: pattern,
      customErrorMessage: customErrorMessage,
      validationType: ValidationType.number,
    );
  }

  /// Date Validator with flexible formats
  factory SmartInputValidation.date({
    String? label,
    bool required = true,
    DateTime? minDate,
    DateTime? maxDate,
    String? customErrorMessage,
    String dateFormat = 'dd/MM/yyyy',
    List<String>? additionalFormats,
  }) => SmartInputValidation._(
    label: label,
    required: required,
    minDate: minDate,
    maxDate: maxDate,
    dateFormat: dateFormat,
    customErrorMessage: customErrorMessage,
    validationType: ValidationType.date,
    customValidation: {'additionalFormats': additionalFormats},
  );

  /// Time Validator
  factory SmartInputValidation.time({
    String? label,
    bool required = true,
    DateTime? minTime,
    DateTime? maxTime,
    String? customErrorMessage,
    String timeFormat = 'HH:mm',
    bool allowSeconds = false,
  }) => SmartInputValidation._(
    label: label,
    required: required,
    minTime: minTime,
    maxTime: maxTime,
    timeFormat: timeFormat,
    customErrorMessage: customErrorMessage,
    validationType: ValidationType.time,
    customValidation: {'allowSeconds': allowSeconds},
  );

  /// DateTime Validator
  factory SmartInputValidation.datetime({
    String? label,
    bool required = true,
    DateTime? minDateTime,
    DateTime? maxDateTime,
    String? customErrorMessage,
    String datetimeFormat = 'dd/MM/yyyy HH:mm',
  }) => SmartInputValidation._(
    label: label,
    required: required,
    minDateTime: minDateTime,
    maxDateTime: maxDateTime,
    datetimeFormat: datetimeFormat,
    customErrorMessage: customErrorMessage,
    validationType: ValidationType.datetime,
  );

  /// Generic Text Validator
  factory SmartInputValidation.text({
    String? label,
    bool required = false,
    int? minLength,
    int? maxLength,
    String? pattern,
    String? customErrorMessage,
    bool allowWhitespace = true,
    bool trimValue = true,
  }) => SmartInputValidation._(
    label: label,
    required: required,
    minLength: minLength,
    maxLength: maxLength,
    pattern: pattern,
    customErrorMessage: customErrorMessage,
    allowWhitespace: allowWhitespace,
    trimValue: trimValue,
    validationType: ValidationType.text,
  );

  /// Dropdown/Selection Validator
  factory SmartInputValidation.dropdown({
    String? label,
    bool required = true,
    String? customErrorMessage,
  }) => SmartInputValidation._(
    label: label,
    required: required,
    customErrorMessage: customErrorMessage,
    validationType: ValidationType.dropdown,
  );

  /// Username Validator
  factory SmartInputValidation.username({
    String? label,
    bool required = true,
    int minLength = 3,
    int maxLength = 20,
    String? customErrorMessage,
    bool allowSpecialChars = true,
  }) {
    final pattern = allowSpecialChars
        ? r'^[a-zA-Z][a-zA-Z0-9._]{' +
              (minLength - 1).toString() +
              r',' +
              (maxLength - 1).toString() +
              r'}$'
        : r'^[a-zA-Z][a-zA-Z0-9]{' +
              (minLength - 1).toString() +
              r',' +
              (maxLength - 1).toString() +
              r'}$';

    return SmartInputValidation._(
      label: label,
      required: required,
      minLength: minLength,
      maxLength: maxLength,
      pattern: pattern,
      customErrorMessage:
          customErrorMessage ??
          'Username must start with a letter and can only contain letters, numbers${allowSpecialChars ? ', underscores, and periods' : ''}.',
      validationType: ValidationType.username,
    );
  }

  /// Custom Validator with regex pattern
  factory SmartInputValidation.custom({
    String? label,
    bool required = false,
    String pattern = r'.*',
    String? customErrorMessage,
    Map<String, dynamic>? customRules,
  }) => SmartInputValidation._(
    label: label,
    required: required,
    pattern: pattern,
    customErrorMessage: customErrorMessage,
    validationType: ValidationType.custom,
    customValidation: customRules,
  );

  // ============ VALIDATION METHODS ============

  /// Validate a given value with comprehensive error reporting
  String? validate(String? value, {String? labelOverride}) {
    final fieldLabel = labelOverride ?? label ?? "Field";
    String processedValue = trimValue ? value?.trim() ?? "" : value ?? "";

    // Reset validation state
    _isValid = false;

    // Required validation
    if (required && processedValue.isEmpty) {
      return customErrorMessage ?? "$fieldLabel is required.";
    }

    // Skip further validation if empty and not required
    if (processedValue.isEmpty) {
      _isValid = true;
      return null;
    }

    // Whitespace validation
    if (!allowWhitespace && processedValue.contains(' ')) {
      return customErrorMessage ?? "$fieldLabel cannot contain whitespace.";
    }

    String? error;

    // Type-specific validation
    switch (validationType) {
      case ValidationType.email:
        error = _validateEmail(processedValue, fieldLabel);
        break;
      case ValidationType.phone:
        error = _validatePhone(processedValue, fieldLabel);
        break;
      case ValidationType.password:
        error = _validatePassword(processedValue, fieldLabel);
        break;
      case ValidationType.creditCard:
        error = _validateCreditCard(processedValue, fieldLabel);
        break;
      case ValidationType.url:
        error = _validateUrl(processedValue, fieldLabel);
        break;
      case ValidationType.ipAddress:
        error = _validateIpAddress(processedValue, fieldLabel);
        break;
      case ValidationType.hexColor:
        error = _validateHexColor(processedValue, fieldLabel);
        break;
      case ValidationType.uuid:
        error = _validateUuid(processedValue, fieldLabel);
        break;
      case ValidationType.json:
        error = _validateJson(processedValue, fieldLabel);
        break;
      case ValidationType.isbn:
        error = _validateIsbn(processedValue, fieldLabel);
        break;
      case ValidationType.macAddress:
        error = _validateMacAddress(processedValue, fieldLabel);
        break;
      case ValidationType.date:
        error = _validateDate(processedValue, fieldLabel);
        break;
      case ValidationType.time:
        error = _validateTime(processedValue, fieldLabel);
        break;
      case ValidationType.datetime:
        error = _validateDateTime(processedValue, fieldLabel);
        break;
      case ValidationType.number:
      case ValidationType.price:
        error = _validateNumber(processedValue, fieldLabel);
        break;
      case ValidationType.dropdown:
        error = _validateDropdown(processedValue, fieldLabel);
        break;
      case ValidationType.text:
      case ValidationType.username:
      case ValidationType.custom:
      default:
        error = _validateGeneric(processedValue, fieldLabel);
        break;
    }

    // Final state update
    _isValid = error == null;
    return error;
  }

  // ============ PRIVATE VALIDATION METHODS ============

  String? _validateEmail(String value, String fieldLabel) {
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
      return customErrorMessage ?? "Please enter a valid email address.";
    }

    // Additional email validation
    final domains = customValidation?['allowedDomains'] as List<String>?;
    final blockedDomains = customValidation?['blockedDomains'] as List<String>?;

    if (domains != null) {
      final domain = value.split('@').last;
      if (!domains.any((allowed) => domain.endsWith(allowed))) {
        return "Email domain not allowed.";
      }
    }

    if (blockedDomains != null) {
      final domain = value.split('@').last;
      if (blockedDomains.any((blocked) => domain.endsWith(blocked))) {
        return "Email domain is blocked.";
      }
    }

    return null;
  }

  String? _validatePhone(String value, String fieldLabel) {
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
      return customErrorMessage ?? "Please enter a valid phone number.";
    }

    // Clean phone number for length validation
    final cleanNumber = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    if (minLength != null && cleanNumber.length < minLength!) {
      return "$fieldLabel must be at least $minLength digits.";
    }

    if (maxLength != null && cleanNumber.length > maxLength!) {
      return "$fieldLabel cannot exceed $maxLength digits.";
    }

    return null;
  }

  String? _validatePassword(String value, String fieldLabel) {
    final missingRequirements = <String>[];

    if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
      final rules = customValidation ?? {};

      if (rules['requireUppercase'] == true &&
          !RegExp(r'[A-Z]').hasMatch(value)) {
        missingRequirements.add('uppercase letter');
      }
      if (rules['requireLowercase'] == true &&
          !RegExp(r'[a-z]').hasMatch(value)) {
        missingRequirements.add('lowercase letter');
      }
      if (rules['requireNumbers'] == true && !RegExp(r'\d').hasMatch(value)) {
        missingRequirements.add('number');
      }
      if (rules['requireSpecialChars'] == true &&
          !RegExp(r'[\W_]').hasMatch(value)) {
        missingRequirements.add('special character');
      }
      if (minLength != null && value.length < minLength!) {
        missingRequirements.add('be at least $minLength characters long');
      }

      if (missingRequirements.isNotEmpty) {
        final requirementsList = missingRequirements
            .map((req) => '• $req')
            .join('\n');
        return "Password must contain:\n$requirementsList";
      }
    }

    // Check for common passwords
    final commonPasswords =
        customValidation?['commonPasswords'] as List<String>?;
    if (commonPasswords != null &&
        commonPasswords.contains(value.toLowerCase())) {
      return "This password is too common. Please choose a stronger one.";
    }

    return null;
  }

  String? _validateCreditCard(String value, String fieldLabel) {
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
      return customErrorMessage ?? "Please enter a valid credit card number.";
    }

    // Luhn algorithm validation
    if (!_isValidLuhn(value.replaceAll(RegExp(r'[\s\-]'), ''))) {
      return "Invalid credit card number.";
    }

    return null;
  }

  String? _validateUrl(String value, String fieldLabel) {
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
      return customErrorMessage ?? "Please enter a valid URL.";
    }

    final requireProtocol = customValidation?['requireProtocol'] == true;
    if (requireProtocol && !value.startsWith('http')) {
      return "URL must include http:// or https://";
    }

    return null;
  }

  String? _validateNumber(String value, String fieldLabel) {
    // Clean the value for parsing
    final cleanValue = value.replaceAll(',', '');
    final numValue = allowDecimals
        ? double.tryParse(cleanValue)
        : int.tryParse(cleanValue);

    if (numValue == null) {
      return "Please enter a valid number for $fieldLabel.";
    }

    if (!allowNegative && numValue < 0) {
      return "$fieldLabel cannot be negative.";
    }

    if (minValue != null && numValue < minValue!) {
      return "$fieldLabel cannot be less than $minValue.";
    }

    if (maxValue != null && numValue > maxValue!) {
      return "$fieldLabel cannot be greater than $maxValue.";
    }

    if (allowDecimals && maxDecimalPlaces != null) {
      final decimalPart = value.split('.').length > 1
          ? value.split('.')[1]
          : '';
      if (decimalPart.length > maxDecimalPlaces!) {
        return "$fieldLabel cannot have more than $maxDecimalPlaces decimal place${maxDecimalPlaces! > 1 ? 's' : ''}.";
      }
    }

    return null;
  }

  String? _validateDate(String value, String fieldLabel) {
    try {
      final formatter = DateFormat(dateFormat ?? 'dd/MM/yyyy');
      final date = formatter.parseStrict(value);

      if (minDate != null && date.isBefore(minDate!)) {
        return "$fieldLabel cannot be earlier than ${formatter.format(minDate!)}.";
      }
      if (maxDate != null && date.isAfter(maxDate!)) {
        return "$fieldLabel cannot be later than ${formatter.format(maxDate!)}.";
      }
    } catch (e) {
      final additionalFormats =
          customValidation?['additionalFormats'] as List<String>?;

      if (additionalFormats != null) {
        for (final format in additionalFormats) {
          try {
            DateFormat(format).parseStrict(value);
            return null; // Successfully parsed with alternative format
          } catch (_) {
            continue;
          }
        }
      }

      return customErrorMessage ??
          "Please enter a valid date (expected format: ${dateFormat ?? 'dd/MM/yyyy'}).";
    }
    return null;
  }

  String? _validateTime(String value, String fieldLabel) {
    try {
      final formatter = DateFormat(timeFormat ?? 'HH:mm');
      final time = formatter.parseStrict(value);

      if (minTime != null && time.isBefore(minTime!)) {
        return "$fieldLabel cannot be earlier than ${formatter.format(minTime!)}.";
      }
      if (maxTime != null && time.isAfter(maxTime!)) {
        return "$fieldLabel cannot be later than ${formatter.format(maxTime!)}.";
      }
    } catch (e) {
      return customErrorMessage ??
          "Please enter a valid time (expected format: ${timeFormat ?? 'HH:mm'}).";
    }
    return null;
  }

  String? _validateDateTime(String value, String fieldLabel) {
    try {
      final formatter = DateFormat(datetimeFormat ?? 'dd/MM/yyyy HH:mm');
      final dateTime = formatter.parseStrict(value);

      if (minDateTime != null && dateTime.isBefore(minDateTime!)) {
        return "$fieldLabel cannot be earlier than ${formatter.format(minDateTime!)}.";
      }
      if (maxDateTime != null && dateTime.isAfter(maxDateTime!)) {
        return "$fieldLabel cannot be later than ${formatter.format(maxDateTime!)}.";
      }
    } catch (e) {
      return customErrorMessage ??
          "Please enter a valid date and time (expected format: ${datetimeFormat ?? 'dd/MM/yyyy HH:mm'}).";
    }
    return null;
  }

  String? _validateDropdown(String value, String fieldLabel) {
    if (required && value.isEmpty) {
      return customErrorMessage ?? "Please select a value for $fieldLabel.";
    }
    return null;
  }

  String? _validateGeneric(String value, String fieldLabel) {
    // Length validation
    if (minLength != null && value.length < minLength!) {
      return "$fieldLabel must be at least $minLength characters long.";
    }
    if (maxLength != null && value.length > maxLength!) {
      return "$fieldLabel cannot exceed $maxLength characters.";
    }

    // Whitespace validation - fix this logic
    if (!allowWhitespace && value.contains(RegExp(r'\s'))) {
      return "$fieldLabel cannot contain whitespace.";
    }

    // Pattern validation
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
      if (customErrorMessage != null) {
        return customErrorMessage;
      }
      return "Invalid format for $fieldLabel.";
    }

    return null;
  }

  // Specialized validators
  String? _validateIpAddress(String value, String fieldLabel) {
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
      return customErrorMessage ?? "Please enter a valid IP address.";
    }
    return null;
  }

  String? _validateHexColor(String value, String fieldLabel) {
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
      return customErrorMessage ?? "Please enter a valid hex color code.";
    }
    return null;
  }

  String? _validateUuid(String value, String fieldLabel) {
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
      return customErrorMessage ?? "Please enter a valid UUID.";
    }
    return null;
  }

  String? _validateJson(String value, String fieldLabel) {
    try {
      // ignore: unused_local_variable
      final json = value; // In real implementation, you'd use dart:convert
      // For now, just check if it looks like JSON
      if (!(value.startsWith('{') && value.endsWith('}')) &&
          !(value.startsWith('[') && value.endsWith(']'))) {
        throw FormatException();
      }
    } catch (e) {
      return customErrorMessage ?? "Please enter valid JSON.";
    }
    return null;
  }

  String? _validateIsbn(String value, String fieldLabel) {
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
      return customErrorMessage ?? "Please enter a valid ISBN.";
    }
    return null;
  }

  String? _validateMacAddress(String value, String fieldLabel) {
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
      return customErrorMessage ?? "Please enter a valid MAC address.";
    }
    return null;
  }

  // ============ UTILITY METHODS ============

  /// Luhn algorithm for credit card validation
  bool _isValidLuhn(String number) {
    int sum = 0;
    bool alternate = false;

    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.tryParse(number[i]) ?? -1;
      if (digit == -1) return false;

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return (sum % 10) == 0;
  }

  static List<String> _getCommonPasswords() {
    return [
      'password',
      '123456',
      '12345678',
      '1234',
      'qwerty',
      '12345',
      'dragon',
      'baseball',
      'football',
      'letmein',
      'monkey',
      'abc123',
    ];
  }

  /// Reset validation state
  void reset() {
    _isValid = false;
  }

  /// Check if value is valid without returning error message
  bool check(String? value) {
    return validate(value) == null;
  }
}

// ============ ENUMS ============

enum ValidationType {
  email,
  phone,
  password,
  creditCard,
  url,
  ipAddress,
  hexColor,
  uuid,
  json,
  isbn,
  macAddress,
  number,
  price,
  date,
  time,
  datetime,
  text,
  username,
  dropdown,
  custom,
}

enum CardType { visa, mastercard, americanExpress, discover, dinersClub, jcb }

enum UuidVersion { v1, v2, v3, v4, v5 }
