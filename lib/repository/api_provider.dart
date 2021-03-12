import 'package:dio/dio.dart';

const String baseUrl = "https://restcountries.eu/rest/v2/";
const String imageUrl = "https://flagcdn.com/w320/";

const urls = {
  'searchByName': 'name/',
  'searchByCode': 'alpha/',
  'searchByMultiCode':
      'alpha?codes=', //for multi search, add ?codes={code};{code};{code}
  'all': 'all',
};

class ApiProvider {
  final CancelToken token = CancelToken();

  Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 100000,
      receiveTimeout: 100000,
      headers: {'Accept': 'application/json'},
      contentType: Headers.jsonContentType,
      responseType: ResponseType.plain,
    ),
  );

  Future makeRequest({
    String urlPath,
  }) async {
    return await this.get(urlPath);
  }

  get(String url) async {
    return await dio.get(url, cancelToken: token);
  }
}
