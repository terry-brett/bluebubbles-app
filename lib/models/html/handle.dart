import 'package:bluebubbles/helpers/helpers.dart';
import 'package:bluebubbles/models/html/contact.dart';
import 'package:bluebubbles/models/html/objectbox.dart';
import 'package:bluebubbles/services/services.dart';
import 'package:collection/collection.dart';
import 'package:faker/faker.dart';
import 'package:get/get.dart';

class Handle {
  int? id;
  int? originalROWID;
  String address;
  String? formattedAddress;
  String? country;
  String? defaultEmail;
  String? defaultPhone;
  final String fakeName = faker.person.name();

  final contactRelation = ToOne<Contact>();
  Contact? webContact;

  final RxnString _color = RxnString();
  String? get color => _color.value;
  set color(String? val) => _color.value = val;

  Contact? get contact => webContact;
  String get displayName {
    if (ss.settings.redactedMode.value) {
      if (ss.settings.generateFakeContactNames.value) {
        return fakeName;
      } else if (ss.settings.hideContactInfo.value) {
        return "";
      }
    }
    if (address.startsWith("urn:biz")) return "Business";
    if (contact != null) return contact!.displayName;
    return address.contains("@") ? address : (formattedAddress ?? address);
  }
  String? get initials {
    // Remove any numbers, certain symbols, and non-alphabet characters
    if (address.startsWith("urn:biz")) return null;
    String importantChars = displayName.toUpperCase().replaceAll(RegExp(r'[^a-zA-Z _-]'), "").trim();
    if (importantChars.isEmpty) return null;

    // Split by a space or special character delimiter, take each of the items and
    // reduce it to just the capitalized first letter. Then join the array by an empty char
    String reduced = importantChars
        .split(RegExp(r' |-|_'))
        .take(2)
        .map((e) => e.isEmpty ? '' : e[0].toUpperCase())
        .join('');
    return reduced.isEmpty ? null : reduced;
  }

  Handle({
    this.id,
    this.originalROWID,
    this.address = "",
    this.formattedAddress,
    this.country,
    String? handleColor,
    this.defaultEmail,
    this.defaultPhone,
  }) {
    color = handleColor;
  }

  factory Handle.fromMap(Map<String, dynamic> json) => Handle(
    id: json["ROWID"] ?? json["id"],
    originalROWID: json["originalROWID"],
    address: json["address"],
    formattedAddress: json["formattedAddress"],
    country: json["country"],
    handleColor: json["color"],
    defaultPhone: json['defaultPhone'],
  );

  Handle save({updateColor = false}) {
    return this;
  }

  static List<Handle> bulkSave(List<Handle> handles) {
    return [];
  }

  Handle updateColor(String? newColor) {
    color = newColor;
    save();
    return this;
  }

  Handle updateDefaultPhone(String newPhone) {
    defaultPhone = newPhone;
    save();
    return this;
  }

  Handle updateDefaultEmail(String newEmail) {
    defaultEmail = newEmail;
    save();
    return this;
  }

  static Handle? findOne({int? id, int? originalROWID, String? address}) {
    // ignore: argument_type_not_assignable, return_of_invalid_type, invalid_assignment, for_in_of_invalid_element_type
    return chats.webCachedHandles.firstWhereOrNull((e) => originalROWID != null ? e.originalROWID == originalROWID : e.address == address);
  }

  static List<Handle> find() {
    return [];
  }

  static Handle merge(Handle handle1, Handle handle2) {
    handle1.id ??= handle2.id;
    handle1.originalROWID ??= handle2.originalROWID;
    handle1._color.value ??= handle2._color.value;
    handle1.country ??= handle2.country;
    handle1.formattedAddress ??= handle2.formattedAddress;
    if (isNullOrEmpty(handle1.defaultPhone)!) {
      handle1.defaultPhone = handle2.defaultPhone;
    }
    if (isNullOrEmpty(handle1.defaultEmail)!) {
      handle1.defaultEmail = handle2.defaultEmail;
    }

    return handle1;
  }

  Map<String, dynamic> toMap() => {
    "ROWID": id,
    "originalROWID": originalROWID,
    "address": address,
    "formattedAddress": formattedAddress,
    "country": country,
    "color": color,
    "defaultPhone": defaultPhone,
  };
}
