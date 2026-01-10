import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/phone_auth_screen.dart';
import 'features/home/providers/home_provider.dart';
import 'features/home/screens/main_navigation_screen.dart';
import 'features/scoring/providers/scoring_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final supabaseService = await SupabaseService.getInstance();

  runApp(MyApp(supabaseService: supabaseService));
}

class MyApp extends StatelessWidget {
  final SupabaseService supabaseService;

  const MyApp({super.key, required this.supabaseService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SupabaseService>.value(value: supabaseService),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(supabaseService),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(supabaseService),
        ),
        ChangeNotifierProvider(
          create: (_) => ScoringProvider(supabaseService),
        ),
      ],
      child: MaterialApp(
        title: 'Wicket.lk',
        theme: AppTheme.themeData,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isAuthenticated) {
              return const MainNavigationScreen();
            }
            return const PhoneAuthScreen();
          },
        ),
        routes: {
          '/login': (context) => const PhoneAuthScreen(),
          '/home': (context) => const MainNavigationScreen(),
        },
      ),
    );
  }
}
