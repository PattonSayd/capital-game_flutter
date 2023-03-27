import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../domain/models/country.dart';

class Api {
  const Api();

  Future<List<Country>> fetchCountries() async {
    final response =
        await http.get(Uri.parse('https://restcountries.com/v2/all'));
    final body = jsonDecode(response.body);
    final capitals = (body as List<dynamic>)
        .where((e) => e['name'] != null && e['capital'] != null)
        .map((e) => Country(e['name'], e['capital']))
        .toList();
    return capitals;
  }
}

class Assets {
  final JsonLoader _loader;

  Assets(this._loader);

  Map<String, List<String>>? _pictures;

  Future<void> loadPictures() async {
    final assets = await _loader.load();
    _pictures = <String, List<String>>{
      for (final asset in assets.entries)
        asset.key: List<String>.from(asset.value),
    };
  }

  List<String> getPictures(String? capital) =>
      _pictures?[capital] ?? <String>[];
}

abstract class JsonLoader {
  Future<Map<String, dynamic>> load();
}

class AssetsJsonLoader implements JsonLoader {
  const AssetsJsonLoader();

  @override
  Future<Map<String, dynamic>> load() async {
    final raw = await rootBundle.loadString('assets/pictures.json');
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}
