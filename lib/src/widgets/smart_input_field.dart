import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/dropdown_model.dart';
import '../models/input_controller.dart';
import '../models/input_types.dart';
import '../validation/input_validation.dart';
import '../formatters/number_formatter.dart';
import '../formatters/phone_formatter.dart';
import '../formatters/price_formatter.dart';

/// A smart and customizable input field with built-in validation, formatting,
/// and various input types for Flutter applications.
///
/// Features:
/// - Multiple input types (text, email, phone, number, date, etc.)
/// - Built-in validation with professional error messages
/// - Automatic formatting (numbers, prices, phone numbers)
/// - Date/Time pickers
/// - Dropdown support
/// - Loading states with skeleton effects
/// - Customizable styling
class SmartInputField extends StatefulWidget {
  /// Creates a smart input field with comprehensive features
  const SmartInputField({
    super.key,
    required this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.autofocus,
    this.readOnly,
    this.enabled,
    this.isChecking = false,
    this.isLoading = false,
    this.isChecked = false,
    this.enableSearch = false,
    this.clearOption = false,
    this.label,
    this.labelFontSize,
    this.icon,
    this.iconColor,
    this.borderColor,
    this.hoverColor,
    this.fillColor,
    this.onTap,
    this.onEditingComplete,
    this.onTapOutside,
    this.keyboardType,
    this.hint,
    this.tooltipMessage,
    this.autofillHints,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
  });

  /// Controller for managing input field state and value
  final SmartInputController controller;

  /// Focus node for this input field
  final FocusNode? focusNode;

  /// Next focus node to move to when submitted
  final FocusNode? nextFocusNode;

  /// Whether this field should be autofocused
  final bool? autofocus;

  /// Whether the field is read-only
  final bool? readOnly;

  /// Whether the field is enabled
  final bool? enabled;

  /// Whether to show checking state
  final bool? isChecking;

  /// Whether to show loading skeleton
  final bool? isLoading;

  /// Whether the field is checked/verified
  final bool? isChecked;

  /// Whether to enable search in dropdowns
  final bool? enableSearch;

  /// Whether to show clear option in dropdowns
  final bool? clearOption;

  /// Field label text
  final String? label;

  /// Custom label font size
  final double? labelFontSize;

  /// Icon to display in the field
  final IconData? icon;

  /// Custom icon color
  final Color? iconColor;

  /// Custom border color
  final Color? borderColor;

  /// Custom hover color
  final Color? hoverColor;

  /// Custom fill color
  final Color? fillColor;

  /// Called when the field is tapped
  final void Function()? onTap;

  /// Called when editing is completed
  final void Function()? onEditingComplete;

  /// Called when tapping outside the field
  final void Function(PointerDownEvent)? onTapOutside;

  /// Type of input field (email, phone, number, date, etc.)
  final dynamic keyboardType;

  /// Hint widget to display
  final Widget? hint;

  /// Tooltip message
  final String? tooltipMessage;

  /// Autofill hints for the field
  final Iterable<String>? autofillHints;

  /// Whether this is a password field
  final bool isPassword;

  /// Custom prefix icon widget
  final Widget? prefixIcon;

  /// Custom suffix icon widget
  final Widget? suffixIcon;

  /// Validation rules for the field
  final SmartInputValidation? validator;

  /// Called when the value changes with value and validation status
  final void Function(String value, bool isValid)? onChanged;

  /// Called when the field is submitted
  final void Function(String)? onSubmitted;

  /// Maximum number of lines for multiline fields
  final int? maxLines;

  /// Maximum character length
  final int? maxLength;

  /// Additional input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  @override
  State<SmartInputField> createState() => _SmartInputFieldState();
}

class _SmartInputFieldState extends State<SmartInputField> {
  bool _isVisible = false;
  String? _errorText;

  // For textarea resizing
  double _textFieldHeight = 150.0;
  final double _minHeight = 50.0;
  final double _maxHeight = 600.0;

  // Separate state for each picker type
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();
  DateTime _selectedDateTime = DateTime.now();

  // For number formatting
  final NumberFormat _numberFormat = NumberFormat("#,##0", "en_US");
  final NumberFormat _priceFormat = NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    super.initState();
    // Set the current controller based on keyboard type
    if (widget.keyboardType == SmartInputType.price) {
      _initializePriceField();
    } else if (widget.keyboardType == SmartInputType.number) {
      _initializeNumberField();
    }
  }

  void _initializePriceField() {
    final rawValue = widget.controller.textController.text;
    if (rawValue.isNotEmpty && rawValue != "0") {
      widget.controller.textController.text = _formatPrice(rawValue);
    }
  }

  void _initializeNumberField() {
    final rawValue = widget.controller.textController.text;
    if (rawValue.isNotEmpty && rawValue != "0") {
      widget.controller.textController.text = _formatNumber(rawValue);
    }
  }

  String _formatPrice(String value) {
    if (value.isEmpty) return '';
    final cleanValue = value.replaceAll(RegExp(r'[^0-9\.-]'), '');
    final number = double.tryParse(cleanValue);
    if (number == null) return '';
    final formatted = _priceFormat.format(number.abs());
    return number.isNegative ? '-$formatted' : formatted;
  }

  String _formatNumber(String value) {
    if (value.isEmpty) return '';
    final cleanValue = value.replaceAll(RegExp(r'[^0-9-]'), '');
    final number = int.tryParse(cleanValue);
    if (number == null) return '';
    final formatted = _numberFormat.format(number.abs());
    return number.isNegative ? '-$formatted' : formatted;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _formatDate(DateTime date) {
    final formatter =
        widget.validator is SmartInputValidation &&
            (widget.validator as SmartInputValidation).dateFormat != null
        ? DateFormat((widget.validator as SmartInputValidation).dateFormat!)
        : DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  String _formatTime(DateTime time) {
    final formatter =
        widget.validator is SmartInputValidation &&
            (widget.validator as SmartInputValidation).timeFormat != null
        ? DateFormat((widget.validator as SmartInputValidation).timeFormat!)
        : DateFormat('HH:mm');
    return formatter.format(time);
  }

  String _formatDateTime(DateTime dateTime) {
    final formatter =
        widget.validator is SmartInputValidation &&
            (widget.validator as SmartInputValidation).datetimeFormat != null
        ? DateFormat((widget.validator as SmartInputValidation).datetimeFormat!)
        : DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  Future<void> _showDatePicker() async {
    final validator = widget.validator;

    final normalizedMaxDate = _normalizeDate(
      validator?.maxDate ?? DateTime.now(),
    );
    final normalizedMinDate = _normalizeDate(
      validator?.minDate ?? DateTime(2000, 1, 1),
    );

    DateTime initialDate = _normalizeDate(_selectedDate);

    // Clamp the initial date
    if (initialDate.isAfter(normalizedMaxDate)) {
      initialDate = normalizedMaxDate;
    } else if (initialDate.isBefore(normalizedMinDate)) {
      initialDate = normalizedMinDate;
    }

    // Pre-popup setState (normalize selection before showing)
    setState(() {
      _selectedDate = initialDate;
      widget.controller.textController.text = _formatDate(_selectedDate);
    });

    await showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => Material(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        child: SizedBox(
          height: 320,
          width: 400,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  maximumDate: normalizedMaxDate,
                  minimumDate: normalizedMinDate,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      _selectedDate = newDateTime;
                      widget.controller.textController.text = _formatDate(
                        _selectedDate,
                      );
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          FocusScope.of(context).unfocus();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.controller.textController.text = _formatDate(
                              _selectedDate,
                            );
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePicker() async {
    // Pre-popup normalization
    DateTime initialTime = _selectedTime;

    setState(() {
      _selectedTime = initialTime;
      widget.controller.textController.text = _formatTime(_selectedTime);
    });

    await showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => Material(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        child: SizedBox(
          height: 320,
          width: 400,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialTime,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      _selectedTime = newDateTime;
                      widget.controller.textController.text = _formatTime(
                        _selectedTime,
                      );
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          FocusScope.of(context).unfocus();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.controller.textController.text = _formatTime(
                              _selectedTime,
                            );
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDateTimePicker() async {
    final validator = widget.validator;

    final maxDateTime =
        validator?.maxDateTime ?? DateTime.now().add(const Duration(days: 365));
    final minDateTime = validator?.minDateTime ?? DateTime(2000, 1, 1);

    DateTime initialDateTime = _selectedDateTime;

    // Clamp initial date-time
    if (initialDateTime.isAfter(maxDateTime)) {
      initialDateTime = maxDateTime;
    } else if (initialDateTime.isBefore(minDateTime)) {
      initialDateTime = minDateTime;
    }

    // Pre-popup setState
    setState(() {
      _selectedDateTime = initialDateTime;
      widget.controller.textController.text = _formatDateTime(
        _selectedDateTime,
      );
    });

    await showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => Material(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        child: SizedBox(
          height: 320,
          width: 400,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: initialDateTime,
                  maximumDate: maxDateTime,
                  minimumDate: minDateTime,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      _selectedDateTime = newDateTime;
                      widget.controller.textController.text = _formatDateTime(
                        _selectedDateTime,
                      );
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          FocusScope.of(context).unfocus();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.controller.textController.text =
                                _formatDateTime(_selectedDateTime);
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validate(String? value) {
    if (widget.validator != null) {
      setState(() => _errorText = widget.validator!.validate(value));
      return _errorText == null;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isMultiline =
        widget.keyboardType == SmartInputType.multiline ||
        (widget.maxLines != null && widget.maxLines! > 1);
    final isEmail = widget.keyboardType == SmartInputType.email;
    final isPhone = widget.keyboardType == SmartInputType.phone;
    final isUrl = widget.keyboardType == SmartInputType.url;
    final isText = widget.keyboardType == SmartInputType.text;
    final isDate = widget.keyboardType == SmartInputType.date;
    final isTime = widget.keyboardType == SmartInputType.time;
    final isDateTime = widget.keyboardType == SmartInputType.datetime;

    // Dropdown case
    if (widget.keyboardType is DropdownInputType) {
      return _buildDropdown(context, widget.keyboardType as DropdownInputType);
    }

    // Use the current controller for the text field
    final controller = widget.controller.textController;

    // Date picker case
    if (isDate) {
      return _buildPickerField(
        context,
        controller: widget.controller.textController,
        onTap: _showDatePicker,
        icon: Icons.calendar_today_outlined,
      );
    }

    // Time picker case
    if (isTime) {
      return _buildPickerField(
        context,
        controller: widget.controller.textController,
        onTap: _showTimePicker,
        icon: Icons.access_time_outlined,
      );
    }

    // DateTime picker case
    if (isDateTime) {
      return _buildPickerField(
        context,
        controller: widget.controller.textController,
        onTap: _showDateTimePicker,
        icon: Icons.calendar_today_outlined,
      );
    }

    // Multiline textarea with resizing
    if (isMultiline) {
      return _buildTextArea(context);
    }

    // Handle different input types
    final isPriceField = widget.keyboardType == SmartInputType.price;
    final isPhoneField = widget.keyboardType == SmartInputType.phone;
    final isNumberField =
        widget.keyboardType == SmartInputType.number ||
        widget.keyboardType is NumberInputType;

    List<TextInputFormatter> inputFormatters = widget.inputFormatters ?? [];
    if (isPriceField) {
      inputFormatters.add(PriceFormatter());
    } else if (isNumberField) {
      final numberType = widget.keyboardType is NumberInputType
          ? widget.keyboardType as NumberInputType
          : null;

      if (numberType?.allowCommas ?? true) {
        inputFormatters.add(
          NumberFormatter(
            decimal: numberType?.decimal ?? false,
            signed: numberType?.signed ?? false,
            minValue: numberType?.minValue?.toInt(),
            maxValue: numberType?.maxValue?.toInt(),
            maxLength:
                numberType?.maxLength ??
                widget.maxLength ??
                widget.validator?.maxLength,
          ),
        );
      } else {
        // Simple formatter without commas
        inputFormatters.add(
          FilteringTextInputFormatter.allow(
            RegExp(
              numberType?.decimal ?? false
                  ? (numberType?.signed ?? false ? r'[0-9\.\-]' : r'[0-9\.]')
                  : (numberType?.signed ?? false ? r'[0-9\-]' : r'[0-9]'),
            ),
          ),
        );
      }
    } else if (isPhoneField) {
      inputFormatters.addAll([
        FilteringTextInputFormatter.digitsOnly,
        PhoneFormatter(),
      ]);
    }

    // Determine keyboard type for text input
    TextInputType textInputType;
    if (isPriceField) {
      textInputType = TextInputType.numberWithOptions(decimal: true);
    } else if (isNumberField) {
      final numberType = widget.keyboardType is NumberInputType
          ? widget.keyboardType as NumberInputType
          : null;
      textInputType = TextInputType.numberWithOptions(
        decimal: numberType?.decimal ?? false,
        signed: numberType?.signed ?? false,
      );
    } else if (isPhoneField) {
      textInputType = TextInputType.phone;
    } else if (isEmail) {
      textInputType = TextInputType.emailAddress;
    } else if (isUrl) {
      textInputType = TextInputType.url;
    } else if (isText) {
      textInputType = TextInputType.text;
    } else {
      textInputType = TextInputType.text;
    }

    // Default text input field
    return LoadingSkeleton(
      isLoading: widget.isLoading ?? false,
      child: Tooltip(
        message: widget.enabled != null && !widget.enabled!
            ? ''
            : widget.tooltipMessage ?? '',
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha((0.9 * 255).toInt()),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          enabled: widget.enabled,
          readOnly: widget.readOnly ?? false,
          controller: controller,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus ?? false,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          autofillHints: widget.autofillHints,
          onTap: widget.onTap,
          validator: widget.validator?.validate,
          onTapOutside: (_) {
            widget.onTapOutside?.call(PointerDownEvent());
            FocusScope.of(context).unfocus();
          },
          obscureText: widget.isPassword ? !_isVisible : false,
          obscuringCharacter: '•',
          keyboardType: textInputType,
          inputFormatters: inputFormatters,
          maxLength: widget.maxLength ?? widget.validator?.maxLength,
          maxLines: widget.maxLines,
          onFieldSubmitted: (text) {
            final rawValue = text;
            final isValid = _validate(rawValue);
            widget.onSubmitted?.call(rawValue);
            widget.onChanged?.call(rawValue, isValid);
            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }
          },
          onChanged: (value) {
            final isValid = _validate(value);
            widget.onChanged?.call(value, isValid);
          },
          onEditingComplete: widget.onEditingComplete,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            counter: const SizedBox(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            label: widget.label != null && widget.label!.isNotEmpty
                ? Text(
                    widget.label!,
                    style: TextStyle(
                      fontSize: widget.labelFontSize ?? 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.7 * 255).toInt()),
                    ),
                  )
                : null,
            hint: widget.hint,
            prefixIcon:
                widget.prefixIcon ??
                (widget.icon != null
                    ? Icon(
                        widget.icon,
                        color:
                            widget.iconColor ??
                            Theme.of(context).colorScheme.onSurface.withAlpha(
                              (0.6 * 255).toInt(),
                            ),
                        size: 20,
                      )
                    : isEmail
                    ? Icon(
                        Icons.email_outlined,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
                        size: 20,
                      )
                    : isUrl
                    ? Icon(
                        Icons.link_outlined,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
                        size: 20,
                      )
                    : isPhone
                    ? Icon(
                        Icons.phone_outlined,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
                        size: 20,
                      )
                    : null),
            suffixIcon:
                widget.suffixIcon ??
                (widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _isVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Theme.of(context).colorScheme.onSurface
                              .withAlpha((0.6 * 255).toInt()),
                          size: 20,
                        ),
                        tooltip: _isVisible ? 'Hide password' : 'Show password',
                        onPressed: () =>
                            setState(() => _isVisible = !_isVisible),
                      )
                    : isPriceField
                    ? Container(
                        alignment: Alignment.center,
                        width: 70,
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          'MWK',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface
                                .withAlpha((0.7 * 255).toInt()),
                          ),
                        ),
                      )
                    : isNumberField
                    ? Container(
                        alignment: Alignment.center,
                        width: 40,
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.numbers_outlined,
                          color: Theme.of(context).colorScheme.onSurface
                              .withAlpha((0.6 * 255).toInt()),
                          size: 20,
                        ),
                      )
                    : widget.suffixIcon),
            filled: true,
            fillColor:
                widget.fillColor ?? Theme.of(context).colorScheme.surface,
            enabledBorder: _buildBorder(context),
            focusedBorder: _buildBorder(context),
            disabledBorder: _buildBorder(context),
            border: _buildBorder(context),
            errorText: _errorText,
            errorMaxLines: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildPickerField(
    BuildContext context, {
    required TextEditingController controller,
    required Future<void> Function() onTap,
    required IconData icon,
  }) {
    return LoadingSkeleton(
      isLoading: widget.isLoading ?? false,
      child: Tooltip(
        message: widget.enabled != null && !widget.enabled!
            ? ''
            : widget.tooltipMessage ?? '',
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha((0.9 * 255).toInt()),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          controller: controller,
          enabled: widget.enabled,
          readOnly: true,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus ?? false,
          validator: widget.validator?.validate,
          onTap: () async {
            if (widget.enabled ?? true) {
              await onTap();
              final isValid = _validate(controller.text);
              widget.onChanged?.call(controller.text, isValid);
            }
          },
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            counter: const SizedBox(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            label: widget.label != null && widget.label!.isNotEmpty
                ? Text(
                    widget.label!,
                    style: TextStyle(
                      fontSize: widget.labelFontSize ?? 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.7 * 255).toInt()),
                    ),
                  )
                : null,
            hint: widget.hint,
            prefixIcon:
                widget.prefixIcon ??
                (widget.icon != null
                    ? Icon(
                        widget.icon,
                        color:
                            widget.iconColor ??
                            Theme.of(context).colorScheme.onSurface.withAlpha(
                              (0.6 * 255).toInt(),
                            ),
                        size: 20,
                      )
                    : Icon(
                        icon,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
                        size: 20,
                      )),
            suffixIcon: widget.suffixIcon,
            filled: true,
            fillColor:
                widget.fillColor ?? Theme.of(context).colorScheme.surface,
            enabledBorder: _buildBorder(context),
            focusedBorder: _buildBorder(context),
            disabledBorder: _buildBorder(context),
            border: _buildBorder(context),
            errorText: _errorText,
            errorMaxLines: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildTextArea(BuildContext context) {
    return LoadingSkeleton(
      isLoading: widget.isLoading ?? false,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: _textFieldHeight,
            width: double.infinity,
            child: TextFormField(
              controller: widget.controller.textController,
              focusNode: widget.focusNode,
              maxLines: null,
              expands: true,
              validator: widget.validator?.validate,
              textAlignVertical: TextAlignVertical.top,
              enabled: widget.enabled,
              readOnly: widget.readOnly ?? false,
              onTap: widget.onTap,
              onTapOutside: (_) {
                widget.onTapOutside?.call(PointerDownEvent());
                FocusScope.of(context).unfocus();
              },
              onChanged: (value) {
                final isValid = _validate(value);
                widget.onChanged?.call(value, isValid);
              },
              onFieldSubmitted: (text) {
                final isValid = _validate(text);
                widget.onSubmitted?.call(text);
                widget.onChanged?.call(text, isValid);
                if (widget.nextFocusNode != null) {
                  FocusScope.of(context).requestFocus(widget.nextFocusNode);
                }
              },
              onEditingComplete: widget.onEditingComplete,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                counter: const SizedBox(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                label: widget.label != null && widget.label!.isNotEmpty
                    ? Text(
                        widget.label!,
                        style: TextStyle(
                          fontSize: widget.labelFontSize ?? 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface
                              .withAlpha((0.7 * 255).toInt()),
                        ),
                      )
                    : null,
                hint: widget.hint,
                prefixIcon:
                    widget.prefixIcon ??
                    (widget.icon != null
                        ? Icon(
                            widget.icon,
                            color:
                                widget.iconColor ??
                                Theme.of(context).colorScheme.onSurface
                                    .withAlpha((0.6 * 255).toInt()),
                            size: 20,
                          )
                        : null),
                suffixIcon: widget.suffixIcon,
                filled: true,
                fillColor:
                    widget.fillColor ?? Theme.of(context).colorScheme.surface,
                enabledBorder: _buildBorder(context),
                focusedBorder: _buildBorder(context),
                disabledBorder: _buildBorder(context),
                border: _buildBorder(context),
                errorText: _errorText,
                errorMaxLines: 3,
                alignLabelWithHint: true,
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: -3,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  _textFieldHeight += details.delta.dy;
                  if (_textFieldHeight < _minHeight) {
                    _textFieldHeight = _minHeight;
                  }
                  if (_textFieldHeight > _maxHeight) {
                    _textFieldHeight = _maxHeight;
                  }
                });
              },
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: Icon(
                  Icons.drag_indicator,
                  size: 20,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withAlpha((0.3 * 255).toInt()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputBorder _buildBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        width: 1.5,
        color:
            widget.borderColor ??
            Theme.of(
              context,
            ).colorScheme.outline.withAlpha((0.3 * 255).toInt()),
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, DropdownInputType type) {
    return LoadingSkeleton(
      isLoading: widget.isLoading ?? false,
      child: Focus(
        focusNode: widget.focusNode,
        child: _DropdownField(
          items: type.items,
          dropDownValues: type.dropDownValues,
          controller: widget.controller,
          enabled: widget.enabled ?? true,
          clearOption: widget.clearOption ?? false,
          enableSearch: widget.enableSearch ?? false,
          label: widget.label,
          labelFontSize: widget.labelFontSize,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          icon: widget.icon,
          iconColor: widget.iconColor,
          fillColor: widget.fillColor,
          borderColor: widget.borderColor,
          errorText: _errorText,
          onChanged: (value) {
            final isValid = _validate(value);
            widget.onChanged?.call(value, isValid);
          },
          validator: widget.validator?.validate,
        ),
      ),
    );
  }
}

class _DropdownField extends StatefulWidget {
  final List<dynamic> items;
  final List<dynamic> dropDownValues;
  final SmartInputController controller;
  final bool enabled;
  final bool clearOption;
  final bool enableSearch;
  final String? label;
  final double? labelFontSize;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final IconData? icon;
  final Color? iconColor;
  final Color? fillColor;
  final Color? borderColor;
  final String? errorText;
  final void Function(String value)? onChanged;
  final String? Function(String?)? validator;

  const _DropdownField({
    required this.items,
    required this.dropDownValues,
    required this.controller,
    required this.enabled,
    required this.clearOption,
    required this.enableSearch,
    this.label,
    this.labelFontSize,
    this.prefixIcon,
    this.suffixIcon,
    this.icon,
    this.iconColor,
    this.fillColor,
    this.borderColor,
    this.errorText,
    this.onChanged,
    this.validator,
  });

  @override
  State<_DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<_DropdownField> {
  String? _selectedValue;
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    // Initialize with current controller value
    _selectedValue = widget.controller.textController.text;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          final itemText = _getItemText(item).toLowerCase();
          return itemText.contains(query);
        }).toList();
      }
    });
  }

  String _getItemText(dynamic item) {
    if (item is String) return item;
    if (item is DropDownValueModel) return item.name;
    return item.toString();
  }

  dynamic _getItemValue(dynamic item) {
    if (item is String) return item;
    if (item is DropDownValueModel) return item.value;
    return item;
  }

  void _clearSelection() {
    setState(() {
      _selectedValue = null;
      widget.controller.textController.clear();
    });
    widget.onChanged?.call('');
  }

  InputBorder _buildBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        width: 1.5,
        color:
            widget.borderColor ??
            Theme.of(
              context,
            ).colorScheme.outline.withAlpha((0.3 * 255).toInt()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null && widget.label!.isNotEmpty) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: widget.labelFontSize ?? 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withAlpha((0.7 * 255).toInt()),
            ),
          ),
          const SizedBox(height: 4),
        ],

        // Dropdown field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.fillColor ?? Theme.of(context).colorScheme.surface,
          ),
          child: InputDecorator(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              prefixIcon:
                  widget.prefixIcon ??
                  (widget.icon != null
                      ? Icon(
                          widget.icon,
                          color:
                              widget.iconColor ??
                              Theme.of(context).colorScheme.onSurface.withAlpha(
                                (0.6 * 255).toInt(),
                              ),
                          size: 20,
                        )
                      : null),
              suffixIcon: _buildSuffixIcon(),
              border: _buildBorder(context),
              enabledBorder: _buildBorder(context),
              focusedBorder: _buildBorder(context),
              disabledBorder: _buildBorder(context),
            ),
            isEmpty: _selectedValue == null || _selectedValue!.isEmpty,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedValue,
                isExpanded: true,
                icon: const SizedBox.shrink(),
                items: _buildDropdownItems(),
                onChanged: widget.enabled ? _onDropdownChanged : null,
                selectedItemBuilder: (context) {
                  return _filteredItems.map<Widget>((item) {
                    final text = _getItemText(item);
                    return Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),

        // Error text
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (!widget.enabled) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.clearOption &&
            _selectedValue != null &&
            _selectedValue!.isNotEmpty)
          IconButton(
            icon: Icon(
              Icons.clear,
              size: 20,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
            ),
            onPressed: _clearSelection,
          ),
        IconButton(
          icon: Icon(
            _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            size: 24,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
          ),
          onPressed: () {
            if (widget.enableSearch) {
              _showSearchableDropdown();
            } else {
              setState(() => _isExpanded = !_isExpanded);
            }
          },
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return _filteredItems.map<DropdownMenuItem<String>>((item) {
      final text = _getItemText(item);
      final value = _getItemValue(item).toString();

      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

  void _onDropdownChanged(String? newValue) {
    if (newValue == null) return;

    setState(() {
      _selectedValue = newValue;
      widget.controller.textController.text = newValue;
    });
    widget.onChanged?.call(newValue);
  }

  void _showSearchableDropdown() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SearchableDropdownBottomSheet(
        items: widget.items,
        selectedValue: _selectedValue,
        searchController: _searchController,
        onItemSelected: (value) {
          _onDropdownChanged(value);
          Navigator.of(context).pop();
        },
        getItemText: _getItemText,
        getItemValue: _getItemValue,
      ),
    ).then((_) {
      _searchController.clear();
      _onSearchChanged(); // Reset filtered items
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _SearchableDropdownBottomSheet extends StatefulWidget {
  final List<dynamic> items;
  final String? selectedValue;
  final TextEditingController searchController;
  final Function(String) onItemSelected;
  final String Function(dynamic) getItemText;
  final dynamic Function(dynamic) getItemValue;

  const _SearchableDropdownBottomSheet({
    required this.items,
    required this.selectedValue,
    required this.searchController,
    required this.onItemSelected,
    required this.getItemText,
    required this.getItemValue,
  });

  @override
  State<_SearchableDropdownBottomSheet> createState() =>
      _SearchableDropdownBottomSheetState();
}

class _SearchableDropdownBottomSheetState
    extends State<_SearchableDropdownBottomSheet> {
  late List<dynamic> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    widget.searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = widget.searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          final itemText = widget.getItemText(item).toLowerCase();
          return itemText.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Search field
          TextField(
            controller: widget.searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: widget.searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => widget.searchController.clear(),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Items list
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Text(
                      'No items found',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final text = widget.getItemText(item);
                      final value = widget.getItemValue(item).toString();
                      final isSelected = value == widget.selectedValue;

                      return ListTile(
                        leading: isSelected
                            ? Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : const SizedBox(width: 24),
                        title: Text(
                          text,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        onTap: () => widget.onItemSelected(value),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }
}

class LoadingSkeleton extends StatefulWidget {
  final bool isLoading;
  final Widget child;

  const LoadingSkeleton({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  State<LoadingSkeleton> createState() => LoadingSkeletonState();
}

class LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = ColorTween(
      begin: const Color(0xFFE0E0E0),
      end: const Color(0xFFF5F5F5),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _SkeletonAppearance(
          color: _animation.value!,
          child: widget.child,
        );
      },
    );
  }
}

class _SkeletonAppearance extends StatelessWidget {
  final Color color;
  final Widget child;

  const _SkeletonAppearance({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [color, color.withAlpha((0.7 * 255).toInt()), color],
        stops: const [0.0, 0.5, 1.0],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: Opacity(opacity: 0.7, child: child),
    );
  }
}
