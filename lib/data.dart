import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'models.dart';

class Api {
  static Future<List<Country>> fetchCountries() async {
    final response =
        await http.get(Uri.parse('https://restcountries.com/v2/all'));
    final body = jsonDecode(response.body);
    final capitals = (body as List<dynamic>)
        .map((e) => Country(e['name'], e['capital']))
        .toList();
    return capitals;
  }
}

class Assests {
  static Map<String, List<String>>? _pictures;

  static Future<void> load() async {
    final raw = await rootBundle.loadString('assets/pictures.json');
    final assets = jsonDecode(raw) as Map<String, dynamic>;
    _pictures = <String, List<String>>{
      for (final asset in assets.entries)
        asset.key: List<String>.from(asset.value),
    };
  }

  static List<String> capitalPictures() => _pictures?['capital'] ?? <String>[];
}
