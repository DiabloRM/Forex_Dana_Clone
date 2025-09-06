import 'dart:io';
import 'package:dio/dio.dart';

Future<void> main(List<String> args) async {
  // Read keys from env or args
  final twelveKey = Platform.environment['TWELVE_DATA_API_KEY'] ??
      _argValue(args, '--twelve');
  final rapidKey =
      Platform.environment['RAPIDAPI_KEY'] ?? _argValue(args, '--rapid');

  final symbol = _argValue(args, '--symbol') ?? 'EUR/USD';
  final useRapid = (rapidKey != null && rapidKey.isNotEmpty);

  stdout.writeln(
      'Testing TwelveData (${useRapid ? 'RapidAPI mirror' : 'direct'}) for symbol: $symbol');

  try {
    late final Dio td;
    if (useRapid) {
      td = Dio(BaseOptions(
        baseUrl: 'https://twelve-data1.p.rapidapi.com',
        headers: {
          'X-RapidAPI-Key': rapidKey,
          'X-RapidAPI-Host': 'twelve-data1.p.rapidapi.com',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ));
    } else {
      if (twelveKey == null || twelveKey.isEmpty) {
        stdout.writeln(
            'TwelveData key missing. Pass --twelve=KEY or set TWELVE_DATA_API_KEY.');
      }
      td = Dio(BaseOptions(
        baseUrl: 'https://api.twelvedata.com',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ));
    }

    final quoteRes = await td.get('/quote', queryParameters: {
      'symbol': symbol,
      if (!useRapid) 'apikey': twelveKey,
    });
    stdout.writeln('TwelveData /quote OK:');
    stdout.writeln(quoteRes.data);

    final seriesRes = await td.get('/time_series', queryParameters: {
      'symbol': symbol,
      'interval': '1h',
      'outputsize': '20',
      if (!useRapid) 'apikey': twelveKey,
    });
    stdout.writeln('TwelveData /time_series OK:');
    stdout.writeln(seriesRes.data);
  } catch (e) {
    stderr.writeln('TwelveData error: $e');
  }

  // Binance public test
  try {
    final binance = Dio(BaseOptions(
      baseUrl: 'https://api.binance.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));
    final b = await binance
        .get('/api/v3/ticker/24hr', queryParameters: {'symbol': 'BTCUSDT'});
    stdout.writeln('Binance /api/v3/ticker/24hr OK:');
    stdout.writeln(b.data);
  } catch (e) {
    stderr.writeln('Binance error: $e');
  }
}

String? _argValue(List<String> args, String key) {
  for (final a in args) {
    if (a.startsWith('$key=')) return a.substring(key.length + 1);
  }
  return null;
}
