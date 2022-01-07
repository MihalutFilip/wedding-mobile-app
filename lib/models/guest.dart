import 'package:wedding_mobile_app/models/confirmation_type.dart';

class Guest {
  final String id;
  final String name;
  final ConfirmationType confirmationType;

  Guest({required this.id, required this.name, required this.confirmationType});

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
        id: json['_id'],
        name: json['name'],
        confirmationType:
            ConfirmationType.values[json['confirmationType'] ?? 0]);
  }
}
