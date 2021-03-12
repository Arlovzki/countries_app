import 'package:countries_app/models/country/country.dart';
import 'package:dio/dio.dart';

import 'api_provider.dart';
import 'dart:convert';

enum SearchType { searchByName, searchByCode, searchAll }
Future<List<Country>> getCountry(SearchType searchType,
    {String searchText = "", bool isMulti = false}) async {
  String defaultUrl = urls['all'];
  List<Country> countries = [];

  if (searchText.trim().isNotEmpty) {
    if (searchType == SearchType.searchByName) {
      defaultUrl = "${urls['searchByName']}$searchText";
    } else if (searchType == SearchType.searchByCode) {
      if (isMulti) {
        List codes = searchText.split(";");
        String codeParams = "";
        codes.forEach((element) {
          codeParams = "$codeParams$element;";
        });
        defaultUrl = "${urls['searchByMultiCode']}$codeParams";
      } else {
        defaultUrl = "${urls['searchByCode']}$searchText";
      }
    }
  }

  try {
    Response response = await ApiProvider().makeRequest(
      urlPath: defaultUrl,
    );
    if (response.statusCode == 200) {
      if (searchType == SearchType.searchByCode) {
        if (!isMulti) {
          var responseJson = json.decode(response.data);
          countries.add(Country.fromJson(responseJson));
          return countries;
        }
      }

      List responseJson = json.decode(response.data);
      countries = responseJson.map((m) => new Country.fromJson(m)).toList();
      return countries;
    }
    // ignore: unused_catch_clause
  } on DioError catch (e) {
    return countries;
  } catch (e) {
    return countries;
  }
  return countries;
}
