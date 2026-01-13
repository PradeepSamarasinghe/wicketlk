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
    debugPrint('Loading/creating user for phone: $phoneNumber');
    _setLoading(true);
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('phone_number', phoneNumber)
          .maybeSingle();

      debugPrint('Supabase response: $response');

      if (response != null) {
        _currentUser = UserModel.fromJson(response as Map<String, dynamic>);
        debugPrint('Loaded existing user: ${_currentUser?.id}');
      } else {
        // First-time user – insert minimal record
        debugPrint('Creating new user...');
        final newUser = await _client
            .from('users')
            .insert({
              'phone_number': phoneNumber,
              'stats': {}, // Initialize empty stats
            })
            .select()
            .single();

        _currentUser = UserModel.fromJson(newUser as Map<String, dynamic>);
        debugPrint('Created new user: ${_currentUser?.id}');
      }
    } catch (e) {
      debugPrint('Error loading/creating user: $e');
      rethrow;
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
  Future<void> verifyOtp(String smsCode, {String? verificationId}) async {
    final verId = verificationId ?? _verificationId;
    if (verId == null) {
      throw Exception('No verification ID available');
    }

    _setLoading(true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verId,
        smsCode: smsCode,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
      // Wait for user data to be loaded from Supabase
      if (userCredential.user?.phoneNumber != null) {
        await _loadOrCreateUser(userCredential.user!.phoneNumber!);
      }
    } catch (e) {
      debugPrint('OTP verification failed: $e');
      _setLoading(false);
      rethrow; // Re-throw so UI can show error
    }
  }

  // Save/update profile data (called from CreateProfileScreen or EditProfileScreen)
  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    // If currentUser is null, try to load from Firebase auth
    if (_currentUser == null) {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      debugPrint('Firebase user: ${firebaseUser?.uid}, phone: ${firebaseUser?.phoneNumber}');
      
      if (firebaseUser?.phoneNumber != null) {
        try {
          await _loadOrCreateUser(firebaseUser!.phoneNumber!);
        } catch (e) {
          debugPrint('Failed to load user in updateProfile: $e');
        }
      }
    }
    
    // If still null, wait a bit and retry (race condition fix)
    if (_currentUser == null) {
      await Future.delayed(const Duration(seconds: 2));
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser?.phoneNumber != null) {
        try {
          await _loadOrCreateUser(firebaseUser!.phoneNumber!);
        } catch (e) {
          debugPrint('Retry failed: $e');
        }
      }
    }
    
    if (_currentUser == null) {
      debugPrint('Profile update error: No current user found');
      throw Exception('User not found. Please try logging in again.');
    }

    _setLoading(true);
    try {
      debugPrint('Updating profile for user ${_currentUser!.id}: $profileData');
      
      await _client
          .from('users')
          .update(profileData)
          .eq('id', _currentUser!.id);

      debugPrint('Profile updated successfully');
      
      // Reload user to reflect changes
      await _loadOrCreateUser(_currentUser!.phoneNumber);
    } catch (e) {
      debugPrint('Profile update error: $e');
      rethrow;
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