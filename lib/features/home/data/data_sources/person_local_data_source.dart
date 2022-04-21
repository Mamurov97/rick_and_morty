// ignore_for_file: constant_identifier_names
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/core/error/exception.dart';
import 'package:untitled/features/home/data/models/person_model.dart';

abstract class PersonLocalDataSource {
  Future<List<PersonModel>> getLastPersonsFromCache();

  Future<void> personsToCache(List<PersonModel> persons);
}

const CACHED_PERSONS_LIST = 'CACHED_PERSONS_LIST';

class PersonLocalDataSourceImpl implements PersonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PersonLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PersonModel>> getLastPersonsFromCache() {
    final jsonPersonsList =
        sharedPreferences.getStringList(CACHED_PERSONS_LIST);
    if (jsonPersonsList!.isNotEmpty) {
      print("Get Persons from Cache: ${jsonPersonsList.length}");
      return Future.value(jsonPersonsList
          .map((person) => PersonModel.fromJson(json.decode(person)))
          .toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<String>> personsToCache(List<PersonModel> persons) {
    final List<String> jsonPersonsList =
        persons.map((person) => json.encode(person.toJson())).toList();

    sharedPreferences.setStringList(CACHED_PERSONS_LIST, jsonPersonsList);
    print("Persons to write Cache: ${jsonPersonsList.length}");

    return Future.value(jsonPersonsList);
  }
}
