// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

abstract class $DisplayRelation {
  const $DisplayRelation();

  List<Attribute> get attributes;
  List<Tuple> get asList;

  DisplayRelation copyWith({
    List<Attribute>? attributes,
    List<Tuple>? asList,
  }) =>
      DisplayRelation(
        attributes ?? this.attributes,
        asList ?? this.asList,
      );

  DisplayRelation copyUsing(
      void Function(DisplayRelation$Change change) mutator) {
    final change = DisplayRelation$Change._(
      this.attributes,
      this.asList,
    );
    mutator(change);
    return DisplayRelation(
      change.attributes,
      change.asList,
    );
  }

  @override
  String toString() =>
      "DisplayRelation(attributes: $attributes, asList: $asList)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is DisplayRelation &&
      other.runtimeType == runtimeType &&
      attributes == other.attributes &&
      asList == other.asList;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    var result = 17;
    result = 37 * result + attributes.hashCode;
    result = 37 * result + asList.hashCode;
    return result;
  }
}

class DisplayRelation$Change {
  DisplayRelation$Change._(
    this.attributes,
    this.asList,
  );

  List<Attribute> attributes;
  List<Tuple> asList;
}

// ignore: avoid_classes_with_only_static_members
class DisplayRelation$ {
  static final attributes = Lens<DisplayRelation, List<Attribute>>(
    (attributesContainer) => attributesContainer.attributes,
    (attributesContainer, attributes) =>
        attributesContainer.copyWith(attributes: attributes),
  );

  static final asList = Lens<DisplayRelation, List<Tuple>>(
    (asListContainer) => asListContainer.asList,
    (asListContainer, asList) => asListContainer.copyWith(asList: asList),
  );
}

abstract class $Tuple {
  const $Tuple();

  List<Attribute> get attributes;
  List<Atom> get atoms;

  Tuple copyWith({
    List<Attribute>? attributes,
    List<Atom>? atoms,
  }) =>
      Tuple(
        attributes ?? this.attributes,
        atoms ?? this.atoms,
      );

  Tuple copyUsing(void Function(Tuple$Change change) mutator) {
    final change = Tuple$Change._(
      this.attributes,
      this.atoms,
    );
    mutator(change);
    return Tuple(
      change.attributes,
      change.atoms,
    );
  }

  @override
  String toString() => "Tuple(attributes: $attributes, atoms: $atoms)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is Tuple &&
      other.runtimeType == runtimeType &&
      attributes == other.attributes &&
      atoms == other.atoms;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    var result = 17;
    result = 37 * result + attributes.hashCode;
    result = 37 * result + atoms.hashCode;
    return result;
  }
}

class Tuple$Change {
  Tuple$Change._(
    this.attributes,
    this.atoms,
  );

  List<Attribute> attributes;
  List<Atom> atoms;
}

// ignore: avoid_classes_with_only_static_members
class Tuple$ {
  static final attributes = Lens<Tuple, List<Attribute>>(
    (attributesContainer) => attributesContainer.attributes,
    (attributesContainer, attributes) =>
        attributesContainer.copyWith(attributes: attributes),
  );

  static final atoms = Lens<Tuple, List<Atom>>(
    (atomsContainer) => atomsContainer.atoms,
    (atomsContainer, atoms) => atomsContainer.copyWith(atoms: atoms),
  );
}

abstract class $Attribute {
  const $Attribute();

  String get name;
  AttributeType get type;

  Attribute copyWith({
    String? name,
    AttributeType? type,
  }) =>
      Attribute(
        name ?? this.name,
        type ?? this.type,
      );

  Attribute copyUsing(void Function(Attribute$Change change) mutator) {
    final change = Attribute$Change._(
      this.name,
      this.type,
    );
    mutator(change);
    return Attribute(
      change.name,
      change.type,
    );
  }

  @override
  String toString() => "Attribute(name: $name, type: $type)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is Attribute &&
      other.runtimeType == runtimeType &&
      name == other.name &&
      type == other.type;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    var result = 17;
    result = 37 * result + name.hashCode;
    result = 37 * result + type.hashCode;
    return result;
  }
}

class Attribute$Change {
  Attribute$Change._(
    this.name,
    this.type,
  );

  String name;
  AttributeType type;
}

// ignore: avoid_classes_with_only_static_members
class Attribute$ {
  static final name = Lens<Attribute, String>(
    (nameContainer) => nameContainer.name,
    (nameContainer, name) => nameContainer.copyWith(name: name),
  );

  static final type = Lens<Attribute, AttributeType>(
    (typeContainer) => typeContainer.type,
    (typeContainer, type) => typeContainer.copyWith(type: type),
  );
}

abstract class $AttributeType {
  const $AttributeType();

  String get tag;

  AttributeType copyWith({
    String? tag,
  }) =>
      AttributeType(
        tag ?? this.tag,
      );

  AttributeType copyUsing(void Function(AttributeType$Change change) mutator) {
    final change = AttributeType$Change._(
      this.tag,
    );
    mutator(change);
    return AttributeType(
      change.tag,
    );
  }

  @override
  String toString() => "AttributeType(tag: $tag)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is AttributeType &&
      other.runtimeType == runtimeType &&
      tag == other.tag;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return tag.hashCode;
  }
}

class AttributeType$Change {
  AttributeType$Change._(
    this.tag,
  );

  String tag;
}

// ignore: avoid_classes_with_only_static_members
class AttributeType$ {
  static final tag = Lens<AttributeType, String>(
    (tagContainer) => tagContainer.tag,
    (tagContainer, tag) => tagContainer.copyWith(tag: tag),
  );
}

abstract class $Atom {
  const $Atom();

  AttributeType get type;
  String get val;

  Atom copyWith({
    AttributeType? type,
    String? val,
  }) =>
      Atom(
        type ?? this.type,
        val ?? this.val,
      );

  Atom copyUsing(void Function(Atom$Change change) mutator) {
    final change = Atom$Change._(
      this.type,
      this.val,
    );
    mutator(change);
    return Atom(
      change.type,
      change.val,
    );
  }

  @override
  String toString() => "Atom(type: $type, val: $val)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is Atom &&
      other.runtimeType == runtimeType &&
      type == other.type &&
      val == other.val;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    var result = 17;
    result = 37 * result + type.hashCode;
    result = 37 * result + val.hashCode;
    return result;
  }
}

class Atom$Change {
  Atom$Change._(
    this.type,
    this.val,
  );

  AttributeType type;
  String val;
}

// ignore: avoid_classes_with_only_static_members
class Atom$ {
  static final type = Lens<Atom, AttributeType>(
    (typeContainer) => typeContainer.type,
    (typeContainer, type) => typeContainer.copyWith(type: type),
  );

  static final val = Lens<Atom, String>(
    (valContainer) => valContainer.val,
    (valContainer, val) => valContainer.copyWith(val: val),
  );
}
