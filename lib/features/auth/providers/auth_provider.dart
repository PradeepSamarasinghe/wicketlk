import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/user_model.dart';
import '../../../core/services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService supabaseService;
  final SupabaseClient _client;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _verificationId; // For OTP flow
  int? _resendToken;

  AuthProvider(this.supabaseService) : _client = supabaseService.client {
    _listenToAuthChanges();
  }

  // Listen to Firebase Auth state changes and sync with Supabase user data
  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        await _loadOrCreateUser(firebaseUser.phoneNumber!);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  // Load existing user from Supabase or create a new record if first-time login
  Future<void> _loadOrCreateUser(String phoneNumber) async {
    _setLoading(true);
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('phone_number', phoneNumber)
          .maybeSingle();

      if (response != null) {
        _currentUser = UserModel.fromJson(response as Map<String, dynamic>);
      } else {
        // First-time user – insert minimal record
        final newUser = await _client
            .from('users')
            .insert({
              'phone_number': phoneNumber,
              'stats': {}, // Initialize empty stats
            })
            .select()
            .single();

        _currentUser = UserModel.fromJson(newUser as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error loading/creating user: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Start phone verification (called from PhoneAuthScreen)
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String error) onError,
  }) async {
    _setLoading(true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _setLoading(false);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'Verification failed');
        _setLoading(false);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        onCodeSent(verificationId, resendToken);
        _setLoading(false);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
      forceResendingToken: _resendToken,
      timeout: const Duration(seconds: 60),
    );
  }

  // Verify OTP code (called from VerificationScreen)
  Future<void> verifyOtp(String smsCode) async {
    if (_verificationId == null) return;

    _setLoading(true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Auth listener will automatically load user data
    } catch (e) {
      debugPrint('OTP verification failed: $e');
      _setLoading(false);
    }
  }

  // Save/update profile data (called from CreateProfileScreen or EditProfileScreen)
  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    if (_currentUser == null) return;

    _setLoading(true);
    try {
      await _client
          .from('users')
          .update(profileData)
          .eq('id', _currentUser!.id);

      // Reload user to reflect changes
      await _loadOrCreateUser(_currentUser!.phoneNumber);
    } catch (e) {
      debugPrint('Profile update error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}