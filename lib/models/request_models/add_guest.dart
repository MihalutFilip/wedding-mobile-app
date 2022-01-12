import '../confirmation_type.dart';
import '../guest.dart';

class AddGuest {
  final String name;
  final ConfirmationType confirmationType;
  final bool isChild;

  AddGuest(
      {required this.name,
      required this.confirmationType,
      required this.isChild});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'confirmationType': confirmationType.index,
      'isChild': isChild
    };
  }

  Guest toGuest(String id) {
    return Guest(
        id: id,
        name: name,
        confirmationType: confirmationType,
        isChild: isChild);
  }
}
