class ApiConfig {
  // TwelveData base URL for forex/crypto/stocks
  static const String baseUrl = 'https://api.twelvedata.com';

  // TODO: Replace with your real API key, or inject via secrets
  static const String apiKey = 'd37c624067bb45a486a63723a0b83a4c';

  // RapidAPI TwelveData mirror (optional). If set (non-empty), ApiClient
  // will use this host and headers instead of baseUrl+apikey query param.
  static const String rapidBaseUrl = 'https://twelve-data1.p.rapidapi.com';
  static const String rapidApiKey = '';
  static const String rapidHost = 'twelve-data1.p.rapidapi.com';
}
