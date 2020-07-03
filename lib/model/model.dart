import 'dart:async';

import 'resource.dart';
import '../cache.dart';
import '../exception.dart';

typedef T SevnModelFactory<T extends SevnModel>(
    [Map<String, dynamic> fields]);

class SevnModelException extends SevnException {
  SevnModelException(message, [title = 'Model Error'])
      : super(message, title);
}

abstract class SevnModel<R extends SevnResource>
    implements SevnCache<String, dynamic> {
  final Map<String, dynamic> fields;
  final List<String> knownFields = <String>[];
  final Map<String, SevnModels> _lists = <String, SevnModels>{};
  final Map<String, SevnModelRelationship> _relationships =
      <String, SevnModelRelationship>{};
  R resource;

  SevnModel(this.fields) {
    init();
  }

  SevnModel.create([Map<String, dynamic> fields])
      : this(fields = fields ?? <String, dynamic>{});

  SevnModel.from(Map<String, dynamic> fields) : this(fields);

  static Future<SevnModels<T>> list<T extends SevnModel>(
      SevnResource r, SevnModelFactory<T> f,
      [Map<String, dynamic> params]) async {
    List<Map<String, dynamic>> rL = await r.$list(params);
    return SevnModels(rL, f);
  }

  String get id => fields['id'];
  dynamic get serialised => fields.keys.where((String key) => knownFields.contains(key)).toList().asMap().map<String, dynamic>(
      (int i, String key) => MapEntry<String, dynamic>(key, fields[key]))
    ..addAll(_relationships.map<String, dynamic>(
        (String field, SevnModelRelationship relationship) =>
            MapEntry(field, relationship.serialise())))
    ..addAll(_lists.map<String, dynamic>((String field, SevnModels list) =>
        MapEntry(field, list.serialise())));

  void init() {}

  dynamic $get(String key) => fields[key];

  bool has(String key) => fields.containsKey(key);

  void $set(String key, dynamic value) {
    fields[key] = value;
  }

  void fill(Map<String, dynamic> newFields) {
    fields.addAll(newFields);
    _relationships
        .forEach((String field, SevnModelRelationship relationship) {
      if (newFields.containsKey(field)) {
        relationship.fill(newFields[field]);
      }
    });
  }

  void know(List<String> more) => knownFields.addAll(more);

  bool knows(String fieldName) => knownFields.contains(fieldName);

  Map<Type, SevnModels> get _listsTypeMap => _lists.map<Type, SevnModels>(
      (String field, SevnModels m) => MapEntry(m.list.runtimeType, m));

  SevnModels listOf<T extends Type>(T type) =>
      _listsTypeMap[<T>[].runtimeType];

  SevnModels<M> listFor<M extends SevnModel>(String field) =>
      _lists[field];

  void listOn<T extends SevnModel>(
      String field, List<dynamic> list, SevnModelFactory<T> f) {
    _lists[field] = SevnModels<T>(List<Map<String, dynamic>>.from(list), f);
  }

  bool lists(String fieldName) => _lists.containsKey(fieldName);

  Future<void> pull([Map<String, dynamic> params]) async {
    Map<String, dynamic> result = await resource.$get(id, params);
    fill(result);
  }

  void relate<T extends SevnModel>(String field, T model) {
    _relationships[field] = SevnModelRelationship<T>(model);
  }

  void relateMany<T extends SevnModel>(
      String field, List<dynamic> list, SevnModelFactory<T> f) {
    _lists[field] = SevnModels<T>(List<Map<String, dynamic>>.from(list), f);
  }

  bool relatesOn(String fieldName) => _relationships.containsKey(fieldName);

  SevnModelRelationship relationship(String fieldName) =>
      _relationships[fieldName];

  Future<void> save([Map<String, dynamic> params]) async {
    Map<String, dynamic> result = await resource.$save(serialised, params);
    fill(result);
  }

  Future<void> update([Map<String, dynamic> params]) async {
    Map<String, dynamic> result =
        await resource.$update(id, serialised, params);
    fill(result);
  }

  @override
  String toString() => serialised.toString();

  dynamic noSuchMethod(Invocation invocation) {
    String key = invocation.memberName.toString().replaceAllMapped(
        RegExp(r'Symbol\("(\w+)=?"\)'), (Match m) => m.group(1));
    String snakeCaseKey = key.replaceAllMapped(
        RegExp(r'[A-Z]'), (Match m) => '_${m.group(0).toLowerCase()}');
    if (invocation.isGetter == true) {
      if (lists(key)) {
        return listFor(key).list;
      }
      if (lists(snakeCaseKey)) {
        return listFor(snakeCaseKey).list;
      }
      if (relatesOn(key)) {
        return relationship(key).model;
      }
      if (relatesOn(snakeCaseKey)) {
        return relationship(snakeCaseKey).model;
      }
      if (knows(key) && has(key)) {
        return $get(key);
      }
      if (knows(snakeCaseKey) && has(snakeCaseKey)) {
        return $get(snakeCaseKey);
      }
    } else if (invocation.isSetter == true) {
      dynamic value = invocation.positionalArguments.first;
      if (lists(key)) {
        return listFor(key).refresh(value);
      }
      if (lists(snakeCaseKey)) {
        return listFor(snakeCaseKey).refresh(value);
      }
      if (relatesOn(key)) {
        relationship(key).fill(value);
      }
      if (relatesOn(snakeCaseKey)) {
        relationship(snakeCaseKey).fill(value);
      }
      if (knows(key) && has(key)) {
        return $set(key, value);
      }
      if (knows(snakeCaseKey) && has(snakeCaseKey)) {
        return $set(snakeCaseKey, value);
      }
    }
    return super.noSuchMethod(invocation);
  }
}

class SevnModelRelationship<T extends SevnModel> {
  final T model;

  SevnModelRelationship(this.model);

  void fill(dynamic value) {
    model.fill(value is SevnModel
        ? value.serialised
        : Map<String, dynamic>.from(value));
  }

  dynamic serialise() => model.serialised;
}

class SevnModels<T extends SevnModel> {
  final List<T> list;
  final SevnModelFactory<T> modelFactory;

  SevnModels(List<Map<String, dynamic>> items, SevnModelFactory<T> f)
      : list = items.map<T>(f).toList(),
        modelFactory = f;

  T find(String id) =>
      list.singleWhere((T model) => model.id == id, orElse: () {
        throw SevnModelException(
            'No model of type ${T.toString()} with id $id could be found',
            'Model not found');
      });

  int indexOf(String id) => list.indexWhere((T model) => model.id == id);

  void refresh(List<dynamic> value) {
    list.clear();
    list.addAll(value is List<T>
        ? value
        : List<Map<String, dynamic>>.from(value).map<T>(modelFactory).toList());
  }

  void replaceAt(String id, T model) {
    list[indexOf(id)] = model;
  }

  List<dynamic> serialise() => list.map((T model) => model.serialised).toList();
}
