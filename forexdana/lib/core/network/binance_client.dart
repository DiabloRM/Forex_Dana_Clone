import 'package:dio/dio.dart';

class BinanceClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.binance.com'));

  Future<List<dynamic>> fetch24hTickers(List<String> symbols) async {
    // Binance supports single-symbol /api/v3/ticker/24hr. For multi, batch sequentially.
    final results = <dynamic>[];
    for (final s in symbols) {
      final res = await _dio.get('/api/v3/ticker/24hr', queryParameters: {
        'symbol': s,
      });
      results.add(res.data);
    }
    return results;
  }
}
