import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'verification_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final phoneNumber = '+94${_phoneController.text}';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await authProvider.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId, resendToken) {
        setState(() => _isLoading = false);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerificationScreen(
              phoneNumber: phoneNumber,
              verificationId: verificationId,
            ),
          ),
        );
      },
      onError: (error) {
        setState(() => _isLoading = false);
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
              'Enter Your Phone Number',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'We\'ll send you a verification code',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textGray,
                  ),
            ),
            const SizedBox(height: 48),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phone Number',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.darkBlue,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.textGray.withOpacity(0.3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            child: const Text(
                              '+94',
                              style: TextStyle(
                                color: AppTheme.neonGreen,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: AppTheme.textWhite,
                              ),
                              decoration: InputDecoration(
                                hintText: '7XXXXXXXX',
                                hintStyle: TextStyle(
                                  color: AppTheme.textGray.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (value.length != 9) {
                                  return 'Enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textGray,
                        ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendVerificationCode,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.darkBlue,
                              ),
                            )
                          : const Text('Send Verification Code'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: 'Login',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.neonGreen,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
