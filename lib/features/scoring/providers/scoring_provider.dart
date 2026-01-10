import 'package:flutter/material.dart';
import '../../../core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScoringProvider extends ChangeNotifier {
  final SupabaseService supabaseService;
  final SupabaseClient _client;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Current match state (will be populated when starting/joining a live match)
  String? currentMatchId;
  Map<String, dynamic>? matchData;
  List<Map<String, dynamic>> ballByBall = [];

  ScoringProvider(this.supabaseService) : _client = supabaseService.client;

  // Start a new match (create in Supabase)
  Future<void> createMatch({
    required String team1Name,
    required String team2Name,
    required int overs,
    required String location,
  }) async {
    _setLoading(true);
    try {
      final response = await _client
          .from('matches')
          .insert({
            'team1_name': team1Name,
            'team2_name': team2Name,
            'overs': overs,
            'location': location,
            'status': 'live',
            'team1_score': {'runs': 0, 'wickets': 0, 'overs': 0.0},
            'team2_score': {'runs': 0, 'wickets': 0, 'overs': 0.0},
            'current_batting_team': team1Name,
            'ball_by_ball': [],
          })
          .select()
          .single();

      currentMatchId = response['id'] as String;
      matchData = response as Map<String, dynamic>;
      ballByBall = [];

      notifyListeners();
    } catch (e) {
      debugPrint('Error creating match: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load an existing live match
  Future<void> loadMatch(String matchId) async {
    _setLoading(true);
    try {
      final response = await _client
          .from('matches')
          .select()
          .eq('id', matchId)
          .single();

      currentMatchId = matchId;
      matchData = response as Map<String, dynamic>;
      ballByBall = List<Map<String, dynamic>>.from(matchData?['ball_by_ball'] ?? []);

      // Subscribe to real-time updates
      _client
          .from('matches:id=eq.$matchId')
          .stream(primaryKey: ['id'])
          .listen((data) {
            if (data.isNotEmpty) {
              matchData = data.first;
              ballByBall = List<Map<String, dynamic>>.from(matchData?['ball_by_ball'] ?? []);
              notifyListeners();
            }
          });

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading match: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Record a ball (runs, wicket, extras, etc.)
  Future<void> recordBall({
    required int runs,
    bool isWicket = false,
    bool isNoBall = false,
    bool isWide = false,
    bool isBye = false,
    bool isLegBye = false,
  }) async {
    if (currentMatchId == null || matchData == null) return;

    try {
      final newBall = {
        'runs': runs,
        'wicket': isWicket,
        'no_ball': isNoBall,
        'wide': isWide,
        'bye': isBye,
        'leg_bye': isLegBye,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Update locally first for instant feedback
      ballByBall.add(newBall);
      _updateScore(newBall);

      // Push to Supabase
      await _client
          .from('matches')
          .update({
            'ball_by_ball': ballByBall,
            'team1_score': matchData!['team1_score'],
            'team2_score': matchData!['team2_score'],
            // Add over tracking logic here if needed
          })
          .eq('id', currentMatchId!);

      notifyListeners();
    } catch (e) {
      debugPrint('Error recording ball: $e');
    }
  }

  void _updateScore(Map<String, dynamic> ball) {
    // Simplified scoring logic - expand for full cricket rules
    final battingTeamKey =
        matchData!['current_batting_team'] == matchData!['team1_name']
            ? 'team1_score'
            : 'team2_score';

    final score = Map<String, dynamic>.from(matchData![battingTeamKey]);
    score['runs'] += ball['runs'];

    if (ball['wicket']) {
      score['wickets'] += 1;
    }

    if (ball['wide'] || ball['no_ball']) {
      score['runs'] += 1; // Extra run for wide/no-ball
    }

    matchData![battingTeamKey] = score;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Add more methods: undo ball, change innings, end match, etc.
}