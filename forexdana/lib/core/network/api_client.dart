import 'package:dio/dio.dart';
import 'api_config.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    final useRapid = ApiConfig.rapidApiKey.isNotEmpty;
    dio = Dio(
      BaseOptions(
        baseUrl: useRapid ? ApiConfig.rapidBaseUrl : ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          if (useRapid) 'X-RapidAPI-Key': ApiConfig.rapidApiKey,
          if (useRapid) 'X-RapidAPI-Host': ApiConfig.rapidHost,
        },
      ),
    );
  }

  Future<Response<dynamic>> get(String path,
      {Map<String, dynamic>? query}) async {
    final useRapid = ApiConfig.rapidApiKey.isNotEmpty;
    final qp = {
      if (query != null) ...query,
      if (!useRapid) 'apikey': ApiConfig.apiKey,
    };
    return dio.get(path, queryParameters: qp);
  }
}
