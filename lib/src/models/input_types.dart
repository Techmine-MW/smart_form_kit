enum SmartInputType {
  text,
  email,
  phone,
  url,
  number,
  price,
  multiline,
  date,
  time,
  datetime,
  password,
  creditCard,
  ipAddress,
  hexColor,
  uuid,
  json,
  isbn,
  macAddress,
  username,
  dropdown,
  custom,
}

enum MobileNetworkOperator { airtel, tnm, zero2 }

class NumberInputType {
  final bool decimal;
  final bool signed;
  final num? minValue;
  final num? maxValue;
  final int? maxLength;
  final bool allowCommas;

  const NumberInputType({
    this.decimal = false,
    this.signed = false,
    this.minValue,
    this.maxValue,
    this.maxLength,
    this.allowCommas = true,
  });
}

class DropdownInputType {
  final List<dynamic> items;
  final List<dynamic> dropDownValues;

  const DropdownInputType({required this.items, required this.dropDownValues});
}
