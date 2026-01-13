import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'create_profile_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const VerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  int _secondsRemaining = 60;
  late DateTime _expiryTime;
  bool _isVerifying = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _expiryTime = DateTime.now().add(const Duration(seconds: 60));
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _secondsRemaining = _expiryTime.difference(DateTime.now()).inSeconds;
          if (_secondsRemaining > 0) {
            _startTimer();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  Future<void> _verifyCode() async {
    if (_code.length != 6) return;

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.verifyOtp(_code, verificationId: widget.verificationId);

      // Wait a moment for auth state to propagate
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if authentication was successful
      if (authProvider.isAuthenticated && authProvider.currentUser != null) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const CreateProfileScreen(),
            ),
          );
        }
      } else if (authProvider.isAuthenticated) {
        // Firebase auth succeeded but Supabase user not loaded yet - wait more
        await Future.delayed(const Duration(seconds: 1));
        if (authProvider.currentUser != null && mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const CreateProfileScreen(),
            ),
          );
        } else {
          setState(() {
            _errorMessage = 'Failed to load user data. Please try again.';
            _isVerifying = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Verification failed. Please try again.';
          _isVerifying = false;
        });
      }
    } catch (e) {
      debugPrint('Verification error: $e');
      setState(() {
        _errorMessage = 'Invalid code: ${e.toString()}';
        _isVerifying = false;
      });
    }
  }

  Future<void> _resendCode() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    await authProvider.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      onCodeSent: (verificationId, resendToken) {
        setState(() {
          _secondsRemaining = 60;
          _expiryTime = DateTime.now().add(const Duration(seconds: 60));
          _startTimer();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification code sent!'),
            backgroundColor: Colors.green,
          ),
        );
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verify Your Phone Number',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter the 6-digit code sent to ${widget.phoneNumber}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textGray,
                  ),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => _CodeInput(
                  controller: _controllers[index],
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 5) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  if (_secondsRemaining > 0)
                    Text(
                      'Resend in ${_secondsRemaining}s',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textGray,
                          ),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _secondsRemaining = 60;
                          _expiryTime = DateTime.now()
                              .add(const Duration(seconds: 60));
                          _startTimer();
                        });
                      },
                      child: Text(
                        'Resend Code',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.neonGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _code.length == 6
                    ? () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                const CreateProfileScreen(),
                          ),
                        );
                      }
                    : null,
                child: const Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _CodeInput({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.darkBlue,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.textGray.withOpacity(0.3),
          ),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          maxLength: 1,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppTheme.textWhite,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
        ),
      ),
    );
  }
}
