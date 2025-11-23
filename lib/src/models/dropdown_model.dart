/// Simple model for dropdown items with display name and value
class DropDownValueModel {
  final String name;
  final dynamic value;

  const DropDownValueModel({required this.name, required this.value});

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropDownValueModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          value == other.value;

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
