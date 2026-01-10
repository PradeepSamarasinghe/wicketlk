import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient client;

  SupabaseService._();

  static Future<SupabaseService> getInstance() async {
    if (_instance == null) {
      _instance = SupabaseService._();
      await dotenv.load(fileName: ".env");  // Loads .env
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (url == null || anonKey == null) {
      throw Exception('Supabase URL or Anon Key not found in .env');
    }

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: true,  // Set to false in production
    );

    client = Supabase.instance.client;
  }
}