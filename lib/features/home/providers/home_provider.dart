// File: lib/features/home/providers/home_provider.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/models/user_model.dart'; // If you have other models, import them

class HomeProvider extends ChangeNotifier {
  final SupabaseService supabaseService;
  final SupabaseClient _client;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Example data structures (replace with real models later)
  List<Map<String, dynamic>> upcomingMatches = [];
  List<Map<String, dynamic>> recentActivity = [];
  Map<String, dynamic>? userStats;

  HomeProvider(this.supabaseService) : _client = supabaseService.client {
    // Load data on initialization (e.g., when user logs in)
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    _setLoading(true);
    try {
      final userId = supabaseService.client.auth.currentUser?.id;
      if (userId == null) return;

      // Example: Fetch upcoming matches where user is registered
      final matchesResponse = await _client
          .from('matches')
          .select()
          .or('team1_players.contains.$userId,team2_players.contains.$userId')
          .eq('status', 'upcoming')
          .order('match_date', ascending: true)
          .limit(5);

      upcomingMatches = List<Map<String, dynamic>>.from(matchesResponse);

      // Example: Fetch recent activity (you can create an activity log table)
      // Or derive from matches/tournaments
      final activityResponse = await _client
          .from('matches')
          .select()
          .or('team1_players.contains.$userId,team2_players.contains.$userId')
          .eq('status', 'completed')
          .order('match_date', ascending: false)
          .limit(10);

      recentActivity = List<Map<String, dynamic>>.from(activityResponse);

      // Fetch user stats (already in users table)
      final userResponse = await _client
          .from('users')
          .select('stats')
          .eq('id', userId)
          .single();

      userStats = userResponse['stats'] as Map<String, dynamic>?;

    } catch (e) {
      debugPrint('Error loading home data: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Add more methods as needed (e.g., refresh, join match, etc.)
}